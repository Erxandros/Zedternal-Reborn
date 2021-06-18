class WMPerk extends KFPerk;

var private WMPlayerReplicationInfo MyWMPRI;
var private WMGameReplicationInfo MyWMGRI;

var private bool bUsedSacrifice;
var private const GameExplosion ShrapnelExplosionTemplate;
var private const Texture2d WhiteMaterial;
var private const array< class<KFWeaponDefinition> > PrimaryWeaponPaths;
var const array< class<KFWeaponDefinition> > KnivesWeaponDef;

var private byte KnifeIndexFromClient;
var private int StartingWeaponClassIndex;

// Supplier Info
struct SuppliedPawnInfo
{
	var WMPawn_Human SuppliedPawn;
	var bool bSuppliedAmmo;
	var bool bSuppliedArmor;
	var bool bSuppliedGrenades;
};
var private array<SuppliedPawnInfo> SuppliedPawnList;

// Passive bonuses : to accelerate calculation, global permanent passive bonuses are cached into these variables
var private float PassiveDamageGiven;
var private float PassiveDamageTaken;
var private float PassiveHealAmount;
var private float PassiveHardAttackDamage;
var private float PassiveStunPower;
var private float PassiveStumblePower;
var private float PassiveKnockdownPower;
var private float PassiveSnarePower;
var private float PassiveMovementSpeed;
var private float PassiveSwitchSpeed;
var private float PassiveMeleeAttackSpeed;
var private float PassiveReloadRateScale;
var private float PassiveRecoil;
var private float PassiveBobDamp;
var private float PassiveMagazineCapacity;
var private float PassiveSpareAmmo;
var private float PassiveRateOfFire;
var private float PassiveTightChoke;
var private float PassivePenetration;

//Timers class to keep track of cached variables and flags
var private WMPerk_Timers WMTimers;

simulated event PreBeginPlay()
{
	super.PreBeginPlay();

	WMTimers = Spawn(class'WMPerk_Timers', self);

	if (WMPlayerController(OwnerPC) != None)
		GetKnifeIndexFromClient();
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner != None)
	{
		MyWMPRI = WMPlayerReplicationInfo(KFPlayerController(Owner).PlayerReplicationInfo);
		if (MyWMPRI == None)
			MyWMPRI = WMPlayerReplicationInfo(MyPRI);
	}
	MyWMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMTimers == None)
		WMTimers = Spawn(class'WMPerk_Timers', self); //Try again just in case
}

function bool ShouldGetAllTheXP()
{
	return True;
}

function OnWaveStart()
{
	Super.OnWaveStart();
	ResetSupplier();
}

simulated function PlayerDied()
{
	super.PlayerDied();

	if (InteractionTrigger != None)
	{
		InteractionTrigger.DestroyTrigger();
	}
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	OwnerPawn = KFPawn_Human(PlayerPawn);
	bForceNetUpdate = True;

	OwnerPC = KFPlayerController(Owner);
	if (OwnerPC != None)
	{
		MyPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
	}

	PerkSetOwnerHealthAndArmorZedternal(True);

	// apply all other pawn changes
	ApplySkillsToPawn();
}

simulated function PerkSetOwnerHealthAndArmorZedternal(optional bool bModifyHealth)
{
	local WMPawn_Human WMPH;
	local WMPlayerReplicationInfo WMPRI;

	// don't allow clients to set health, since health/healthmax/playerhealth/playerhealthpercent is replicated
	if (Role < ROLE_Authority)
		return;

	if (CheckOwnerPawn())
		WMPH = WMPawn_Human(OwnerPawn);

	if (WMPH != None)
	{
		if (bModifyHealth)
		{
			WMPH.Health = WMPH.default.Health;
			ModifyHealth(WMPH.Health);
		}

		WMPH.HealthMax = WMPH.default.Health;
		ModifyHealth(WMPH.HealthMax);
		WMPH.Health = Min(WMPH.Health, WMPH.HealthMax);

		if (OwnerPC == None)
			OwnerPC = KFPlayerController(Owner);

		MyPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
		if (MyPRI != None)
			WMPRI = WMPlayerReplicationInfo(MyPRI);

		if (WMPRI != None)
		{
			WMPRI.PlayerHealthInt = WMPH.Health;
			WMPRI.PlayerHealth = FloatToByte(float(WMPH.Health) / float(WMPH.HealthMax));
			WMPRI.PlayerHealthPercent = WMPRI.PlayerHealth;
		}

		WMPH.ZedternalMaxArmor = WMPH.default.ZedternalMaxArmor;
		ModifyArmorInt(WMPH.ZedternalMaxArmor);
		WMPH.ZedternalArmor = Min(WMPH.ZedternalArmor, WMPH.ZedternalMaxArmor);
		WMPH.AdjustArmorPct();

		if (WMPRI != None)
			WMPRI.PlayerArmorInt = WMPH.ZedternalArmor;
	}
}

function ApplySkillsToPawn()
{
	local KFGameReplicationInfo KFGRI;

	if (CheckOwnerPawn())
	{
		OwnerPawn.UpdateGroundSpeed();
		OwnerPawn.bMovesFastInZedTime = IsUnAffectedByZedTime();

		if (MyPRI == None)
		{
			MyPRI = KFPlayerReplicationInfo(OwnerPawn.PlayerReplicationInfo);
		}

		MyPRI.bExtraFireRange = IsRangeActive();
		MyPRI.bSplashActive = IsGroundFireActive();
		MyPRI.bNukeActive = False;
		MyPRI.bConcussiveActive = False;
		MyPRI.PerkSupplyLevel = 0;

		ApplyWeightLimits();
		ApplyBatteryRechargeRate();
		ServerComputePassiveBonuses();
		ClientAndServerComputePassiveBonuses();

		KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
		if (KFGRI != None && !KFGRI.bTraderIsOpen)
			ResetSupplier();
	}
}

function AddDefaultInventory(KFPawn P)
{
	local int i, choice;
	local KFInventoryManager KFIM;
	local WMGameInfo_Endless WMGI;
	local array< class<KFWeaponDefinition> > StartingWeaponsList;

	if (P != None && P.InvManager != None)
	{
		KFIM = KFInventoryManager(P.InvManager);
		if (KFIM != None)
		{
			//Grenades added on spawn
			KFIM.GiveInitialGrenadeCount();
		}

		WMGI = WMGameInfo_Endless(MyKFGI);

		if (WMGI != None && WMGI.PerkStartingWeapon.length > 0)
		{
			StartingWeaponsList = WMGI.PerkStartingWeapon;
			for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponNumber; i++)
			{
				if (StartingWeaponsList.Length > 0)
				{
					choice = Rand(StartingWeaponsList.Length);

					if (StartingWeaponsList[choice] != None)
						P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(StartingWeaponsList[choice].default.WeaponClassPath, class'Class')));

					StartingWeaponsList.Remove(choice, 1);
				}
				else
					i = class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponNumber;
			}
		}
		else
			P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetPrimaryWeaponClassPath(), class'Class')));

		// Secondary weapon is spawned through the pawn unless we want an additional one not anymore
		P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetSecondaryWeaponClassPath(), class'Class')));
		P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetKnifeWeaponClassPath(), class'Class')));
	}
}

/* Returns the primary weapon's class path for this perk */
simulated function string GetPrimaryWeaponClassPath()
{
	StartingWeaponClassIndex = Rand(PrimaryWeaponPaths.length);
	AutoBuyLoadOutPath.InsertItem(0,PrimaryWeaponPaths[StartingWeaponClassIndex]);
	return PrimaryWeaponPaths[StartingWeaponClassIndex].default.WeaponClassPath;
}

reliable server function SetKnifeIndexFromClient(byte index)
{
	KnifeIndexFromClient = index;
}

reliable client function GetKnifeIndexFromClient()
{
	local WMPlayerController WMPC;
	local byte index;

	WMPC = WMPlayerController(OwnerPC);

	if (WMPC != None)
		index = WMPC.KnifeIndex;
	else
		index = 0;

	SetKnifeIndexFromClient(index);
}

simulated function string GetKnifeWeaponClassPath()
{
	if (KnifeIndexFromClient < 0 || KnifeIndexFromClient > KnivesWeaponDef.length)
		KnifeIndexFromClient = 0;

	KnifeWeaponDef = KnivesWeaponDef[KnifeIndexFromClient];
	return KnifeWeaponDef.default.WeaponClassPath;
}

function bool ShouldAutosellWeapon(class<KFWeaponDefinition> DefClass)
{
	//Because survivalists get a random first weapon in their auto buy load out, if they ever swap
	//      to another valid on-perk T1 then attempt to autobuy, they could be left in situations where
	//      they sell the new valid T1, but don't have enough money to buy any other weapons. In this
	//      case, we shouldn't sell the weapon if it's also part of the primary weapons that they could
	//      start with in a valid match.
	if (super.ShouldAutosellWeapon(DefClass))
	{
		return PrimaryWeaponPaths.Find(DefClass) == INDEX_NONE;
	}

	return False;
}

function OnWaveEnded()
{
	Super.OnWaveEnded();
	bUsedSacrifice = False;
	if (OwnerPC != None)
		OwnerPC.SetPerkEffect(False);
}

static simulated function bool IsWeaponOnSpecificPerk(KFWeapon W, class<KFPerk> Perk)
{
	if (W != None)
		return W.static.GetWeaponPerkClass(Perk) == Perk;

	return False;
}

static function bool IsDamageTypeOnSpecificPerk(class<KFDamageType> KFDT, class<KFPerk> Perk)
{
	if (KFDT != None)
		return KFDT.default.ModifierPerkList.Find(Perk) > INDEX_NONE;

	return False;
}

simulated function bool isValidWeapon(class<KFWeapon> WeaponClass, KFWeapon KFW)
{
	if (KFW == None)
		return False;
	else if (KFW.class == WeaponClass)
		return True;
	else if (KFWeap_DualBase(KFW) != None && KFWeap_DualBase(KFW).SingleClass == WeaponClass)
		return True;

	return False;
}

simulated function string GetGrenadeImagePath()
{
	return GrenadeWeaponDef.Static.GetImagePath();
}

simulated function class<KFWeaponDefinition> GetGrenadeWeaponDef()
{
	return GrenadeWeaponDef;
}

function ServerComputePassiveBonuses()
{
	local byte i, index;

	PassiveDamageGiven = 1.0f;
	PassiveDamageTaken = 1.0f;
	PassiveHealAmount = 1.0f;
	PassiveHardAttackDamage = 1.0f;
	PassiveStunPower = 1.0f;
	PassiveStumblePower = 1.0f;
	PassiveKnockdownPower = 1.0f;
	PassiveSnarePower = 1.0f;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDamageGivenPassive(PassiveDamageGiven, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyDamageTakenPassive(PassiveDamageTaken, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyHealAmountPassive(PassiveHealAmount, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyHardAttackDamagePassive(PassiveHardAttackDamage, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyStunPowerPassive(PassiveStunPower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyStumblePowerPassive(PassiveStumblePower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyKnockdownPowerPassive(PassiveKnockdownPower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifySnarePowerPassive(PassiveSnarePower, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageGivenPassive(PassiveDamageGiven, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageTakenPassive(PassiveDamageTaken, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealAmountPassive(PassiveHealAmount, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHardAttackDamagePassive(PassiveHardAttackDamage, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStunPowerPassive(PassiveStunPower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStumblePowerPassive(PassiveStumblePower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyKnockdownPowerPassive(PassiveKnockdownPower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySnarePowerPassive(PassiveSnarePower, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyDamageGivenPassive(PassiveDamageGiven, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyDamageTakenPassive(PassiveDamageTaken, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyHealAmountPassive(PassiveHealAmount, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyHardAttackDamagePassive(PassiveHardAttackDamage, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyStunPowerPassive(PassiveStunPower, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyStumblePowerPassive(PassiveStumblePower, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyKnockdownPowerPassive(PassiveKnockdownPower, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifySnarePowerPassive(PassiveSnarePower, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}
}

simulated function ClientAndServerComputePassiveBonuses()
{
	local byte i, index;

	PassiveMovementSpeed = 1.0f;
	PassiveSwitchSpeed = 1.0f;
	PassiveMeleeAttackSpeed = 1.0f;
	PassiveReloadRateScale = 1.0f;
	PassiveRecoil = 1.0f;
	PassiveBobDamp = 1.0f;
	PassiveMagazineCapacity = 1.0f;
	PassiveSpareAmmo = 1.0f;
	PassiveRateOfFire = 1.0f;
	PassiveTightChoke = 1.0f;
	PassivePenetration = 1.0f;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySpeedPassive(PassiveMovementSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponSwitchTimePassive(PassiveSwitchSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyMeleeAttackSpeedPassive(PassiveMeleeAttackSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.GetReloadRateScalePassive(PassiveReloadRateScale, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyRecoilPassive(PassiveRecoil, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponBopDampingPassive(PassiveBobDamp, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyMagSizeAndNumberPassive(PassiveMagazineCapacity, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifySpareAmmoAmountPassive(PassiveSpareAmmo, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyRateOfFirePassive(PassiveRateOfFire, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyTightChokePassive(PassiveTightChoke, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyPenetrationPassive(PassivePenetration, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpeedPassive(PassiveMovementSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponSwitchTimePassive(PassiveSwitchSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMeleeAttackSpeedPassive(PassiveMeleeAttackSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetReloadRateScalePassive(PassiveReloadRateScale, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRecoilPassive(PassiveRecoil, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponBopDampingPassive(PassiveBobDamp, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMagSizeAndNumberPassive(PassiveMagazineCapacity, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpareAmmoAmountPassive(PassiveSpareAmmo, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRateOfFirePassive(PassiveRateOfFire, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyTightChokePassive(PassiveTightChoke, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyPenetrationPassive(PassivePenetration, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifySpeedPassive(PassiveMovementSpeed, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyWeaponSwitchTimePassive(PassiveSwitchSpeed, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyMeleeAttackSpeedPassive(PassiveMeleeAttackSpeed, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetReloadRateScalePassive(PassiveReloadRateScale, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyRecoilPassive(PassiveRecoil, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyWeaponBopDampingPassive(PassiveBobDamp, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyMagSizeAndNumberPassive(PassiveMagazineCapacity, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifySpareAmmoAmountPassive(PassiveSpareAmmo, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyRateOfFirePassive(PassiveRateOfFire, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyTightChokePassive(PassiveTightChoke, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyPenetrationPassive(PassivePenetration, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}
}

simulated function ResetSupplier()
{
	local float PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage;
	local int GrenadeAmount;
	local byte count;

	if (MyPRI != None && IsSupplierActive())
	{
		if (SuppliedPawnList.Length > 0)
			SuppliedPawnList.Remove(0, SuppliedPawnList.Length);

		SupplierModifiers(PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
		if (PrimaryAmmoPercentage > 0.0f || SecondaryAmmoPercentage > 0.0f)
			++count;
		if (ArmorPercentage > 0.0f)
			++count;
		if (GrenadeAmount > 0)
			++count;

		MyPRI.PerkSupplyLevel = Clamp(count, 0, 2);

		if (InteractionTrigger != None)
		{
			InteractionTrigger.Destroy();
			InteractionTrigger = None;
		}

		if (CheckOwnerPawn() && MyPRI.PerkSupplyLevel > 0)
		{
			InteractionTrigger = Spawn(class'KFUsablePerkTrigger', OwnerPawn, , OwnerPawn.Location, OwnerPawn.Rotation, , True);
			InteractionTrigger.SetBase(OwnerPawn);

			if (PrimaryAmmoPercentage > 0.0f || SecondaryAmmoPercentage > 0.0f || ArmorPercentage > 0.0f)
				InteractionTrigger.SetInteractionIndex(IMT_ReceiveAmmo);
			else
				InteractionTrigger.SetInteractionIndex(IMT_ReceiveGrenades);

			OwnerPC.SetPendingInteractionMessage();
		}
	}
	else if (InteractionTrigger != None)
	{
		InteractionTrigger.Destroy();
	}
}

function ModifyDamageGiven(out int InDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx)
{
	local int i, index;
	local KFWeapon MyKFW;
	local int DefaultDamage;

	DefaultDamage = InDamage;

	if (DamageCauser != None)
	{
		if (DamageCauser.IsA('Weapon'))
		{
			MyKFW = KFWeapon(DamageCauser);
		}
		else if (DamageCauser.IsA('Projectile'))
		{
			MyKFW = KFWeapon(DamageCauser.Owner);
		}
		else
			MyKFW = None;
	}

	// Server Custom Balance
	if (DamageType != None)
	{
		for (i = 0; i < class'ZedternalReborn.Config_Player'.default.Player_DamageGivenFactor.length; ++i)
		{
			if (ClassIsChildOf(DamageType, class'ZedternalReborn.Config_Player'.default.Player_DamageGivenFactor[i].DamageType))
				InDamage += Round(float(DefaultDamage) * (class'ZedternalReborn.Config_Player'.default.Player_DamageGivenFactor[i].Factor - 1.0f));
		}
	}
	InDamage = Max(0, InDamage);
	DefaultDamage = InDamage;
	InDamage = Round(float(DefaultDamage) * PassiveDamageGiven);

	// GetWeapon : MyKFW = None when player deals damage with flamethrower/freezethrower...
	if (DamageType != None && (
		class<KFDT_Fire_FlameThrower>(DamageType) != None ||
		class<KFDT_Fire_CaulkBurn>(DamageType) != None ||
		class<KFDT_Microwave>(DamageType) != None ||
		class<KFDT_Fire_Ground>(DamageType) != None ||
		class<KFDT_Freeze_Ground>(DamageType) != None))
	{
		MyKFW = GetOwnerWeapon();
	}

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bEquipmentUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyDamageGiven(InDamage, DefaultDamage, DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
	}

	if (InDamage < 0)
		InDamage = 0;
}

function ModifyHardAttackDamage(out int InDamage)
{
	local int i, index;
	local KFWeapon MyKFW;
	local int DefaultDamage;

	if (InDamage == 0)
		return;

	DefaultDamage = InDamage;
	InDamage *= PassiveHardAttackDamage;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyHardAttackDamage(InDamage, DefaultDamage, OwnerPawn);
		}
	}

	if (InDamage < 0)
		InDamage = 0;
}

function ModifyDamageTaken(out int InDamage, optional class<DamageType> DamageType, optional Controller InstigatedBy)
{
	local int i, index;
	local KFWeapon MyKFW;
	local KFInventoryManager KFIM;
	local int DefaultDamage;

	if (InDamage == 0 || class<WMDT_BringTheHeat>(DamageType) != None)
	{
		InDamage = 0;
		return;
	}

	DefaultDamage = InDamage;

	MyKFW = GetOwnerWeapon();
	if (MyKFW == None && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != None && KFIM.PendingWeapon != None)
		{
			MyKFW = KFWeapon(KFIM.PendingWeapon);
		}
	}

	// Server Custom Balance
	if (DamageType != None)
	{
		for (i = 0; i < class'ZedternalReborn.Config_Player'.default.Player_DamageTakenFactor.length; ++i)
		{
			if (ClassIsChildOf(DamageType, class'ZedternalReborn.Config_Player'.default.Player_DamageTakenFactor[i].DamageType))
				InDamage += Round(float(DefaultDamage) * (class'ZedternalReborn.Config_Player'.default.Player_DamageTakenFactor[i].Factor - 1.0f));
		}

		if (MyKFW.IsMeleeWeapon() && class'ZedternalReborn.Config_Player'.default.Player_DamageTakenFactorWhileHoldingMelee != 0)
		{
			InDamage += Round(float(DefaultDamage) * (class'ZedternalReborn.Config_Player'.default.Player_DamageTakenFactorWhileHoldingMelee - 1.0f));
		}
	}

	InDamage = Max(1, InDamage);
	DefaultDamage = InDamage;
	InDamage = Round(float(DefaultDamage) * PassiveDamageTaken);

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyDamageTaken(InDamage, DefaultDamage, OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
	}

	if (InDamage < 0)
		InDamage = 1;
}

function ModifyHealth(out int InHealth)
{
	local byte i, index;
	local int DefaultHealth;

	// Server Custom Balance
	InHealth = class'ZedternalReborn.Config_Player'.default.Player_Health;
	if (InHealth <= 0)
		InHealth = 100;

	DefaultHealth = InHealth;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyHealth(InHealth, DefaultHealth);
		}
	}
}

function ModifyArmor(out byte MaxArmor)
{
	return;
}

function ModifyArmorInt(out int MaxArmor)
{
	local byte i, index;
	local int DefaultArmor;

	// Server Custom Balance
	MaxArmor = class'ZedternalReborn.Config_Player'.default.Player_Armor;
	if (MaxArmor <= 0)
		MaxArmor = 100;

	DefaultArmor = MaxArmor;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyArmor(MaxArmor, DefaultArmor);
		}
	}
}

simulated function ModifyMeleeAttackSpeed(out float InDuration, KFWeapon KFW)
{
	local int i, index;
	local float DefaultDuration;

	DefaultDuration = InDuration;
	InDuration *= PassiveMeleeAttackSpeed;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bSkillUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, KFW);
		}
	}

	if (InDuration <= 0)
		InDuration = 0.05f;
}

simulated function float GetReloadRateScale(KFWeapon KFW)
{
	local int i, index;
	local float InReloadRateScale;

	InReloadRateScale = PassiveReloadRateScale;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetReloadRateScale(InReloadRateScale, KFW, OwnerPawn);
		}
	}

	if (InReloadRateScale <= 0.05f)
		return 0.05f;
	else
		return InReloadRateScale;
}

function bool ModifyHealAmount(out float HealAmount)
{
	local int i, index;
	local KFWeapon MyKFW;
	local float DefaultHealAmount;

	DefaultHealAmount = HealAmount;

	// Server Custom Balance
	HealAmount *= class'ZedternalReborn.Config_Player'.default.Player_HealAmountFactor;

	HealAmount *= PassiveHealAmount;
	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyHealAmount(HealAmount, DefaultHealAmount);
		}
	}

	return IsHealingSurgeActive();
}

simulated function ModifyHealerRechargeTime(out float RechargeRate)
{
	local byte i, index;
	local float DefaultRechargeRate;

	DefaultRechargeRate = RechargeRate;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate);
		}
	}
}

simulated function ModifySpeed(out float Speed)
{
	local byte i, index;
	local float DefaultSpeed;

	DefaultSpeed = Speed;
	Speed *= PassiveMovementSpeed;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySpeed(Speed, DefaultSpeed, OwnerPawn);
		}
	}
}

simulated function ModifyRecoil(out float CurrentRecoilModifier, KFWeapon KFW)
{
	local int i, index;
	local float DefaultRecoilModifier;

	DefaultRecoilModifier = CurrentRecoilModifier;
	CurrentRecoilModifier *= PassiveRecoil;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bSkillUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, KFW);
		}
	}

	if (CurrentRecoilModifier < DefaultRecoilModifier * 0.08f)
		CurrentRecoilModifier = DefaultRecoilModifier * 0.08f;
}

simulated function ModifyWeaponBopDamping(out float BobDamping, KFWeapon PawnWeapon)
{
	local int i, index;
	local float InBobDamping, DefaultBobDamping;

	DefaultBobDamping = BobDamping;
	InBobDamping = DefaultBobDamping * PassiveBobDamp;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bPerkUpgrade[index], PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, PawnWeapon))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.GetWeaponUpgrade(index), PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bSkillUpgrade[index], PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bEquipmentUpgrade[index], PawnWeapon);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, PawnWeapon);
		}
	}

	BobDamping = InBobDamping;
}

simulated function ModifyMagSizeAndNumber(KFWeapon KFW, out int MagazineCapacity, optional array< class<KFPerk> > WeaponPerkClass, optional bool bSecondary = False, optional name WeaponClassname)
{
	local int i, index;
	local int DefaultMagazineCapacity;
	local int MagCapacity;

	MagCapacity = MagazineCapacity;
	DefaultMagazineCapacity = MagCapacity;

	if (MyWMPRI != None && MyWMGRI != None && KFWeap_Healer_Syringe(KFW) == None && KFWeap_Welder(KFW) == None)
	{
		MagCapacity = Round(float(MagCapacity) * PassiveMagazineCapacity);

		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bPerkUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.GetWeaponUpgrade(index), KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bSkillUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bEquipmentUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
	}

	if (KFWeap_Bow_Crossbow(KFW) == None && KFWeap_Bow_CompoundBow(KFW) == None) // crossbow and bow does not work well with more than 1 ammo per clip
	{
		if (!bSecondary)
			MagazineCapacity = Clamp(MagCapacity, 0, MaxInt); //Prevent integer overflow
		else
			MagazineCapacity = Clamp(MagCapacity, 0, 255); //Prevent byte overflow
	}
	else
		MagazineCapacity = 1;

	InitiateWeapon(KFW);
}

simulated function ModifySpareAmmoAmount(KFWeapon KFW, out int PrimarySpareAmmo, optional const out STraderItem TraderItem, optional bool bSecondary = False)
{
	local int i, index;
	local int DefaultSpareAmmo;

	if (KFW != None && PrimarySpareAmmo > 0)
	{
		DefaultSpareAmmo = PrimarySpareAmmo;
		PrimarySpareAmmo = Round(float(PrimarySpareAmmo) * PassiveSpareAmmo);
		if (MyWMPRI != None && MyWMGRI != None)
		{
			for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_PerkUpgrade[i];
				MyWMGRI.perkUpgrades[index].static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bPerkUpgrade[index], KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_WeaponUpgrade[i];
				if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
					MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.GetWeaponUpgrade(index), KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bSkillUpgrade[index], KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bEquipmentUpgrade[index], KFW, TraderItem, bSecondary);
			}
			for (i = 0; i <= 1; ++i)
			{
				if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
					MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, KFW, TraderItem, bSecondary);
			}
		}

		if (!bSecondary)
			PrimarySpareAmmo = Clamp(PrimarySpareAmmo, 0, MaxInt); //Prevent integer overflow
		else
			PrimarySpareAmmo = Clamp(PrimarySpareAmmo, 0, 255); //Prevent byte overflow
	}
}

simulated function ModifyMaxSpareAmmoAmount(KFWeapon KFW, out int MaxSpareAmmo, optional const out STraderItem TraderItem, optional bool bSecondary = False)
{
	ModifySpareAmmoAmount(KFW, MaxSpareAmmo, TraderItem, bSecondary);
}

simulated function ModifyMaxSpareGrenadeAmount()
{
	local byte i, index;
	local int SpareGrenade;
	local int DefaultSpareGrenade;

	DefaultSpareGrenade = default.MaxGrenadeCount;
	SpareGrenade = DefaultSpareGrenade;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade);
		}

		MaxGrenadeCount = SpareGrenade;
	}
}

simulated function ModifyWeldingRate(out float FastenRate, out float UnfastenRate)
{
	local byte i, index;
	local float DefaultFastenRate, DefaultUnfastenRate;

	DefaultFastenRate = FastenRate;
	DefaultUnfastenRate = UnfastenRate;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate);
		}
	}
}

function float GetZedTimeExtensionMax(byte Level)
{
	local byte i, index;
	local float DefaultExtension;
	local float Extension;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		DefaultExtension = 1.0f;
		Extension = 1.0f;

		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetZedTimeExtension(Extension, DefaultExtension);
		}
	}

	return Extension;
}

function ApplyWeightLimits()
{
	local byte i, index;
	local KFInventoryManager KFIM;
	local int DefaultWeightLimit;
	local int InWeightLimit;

	if (OwnerPawn != None)
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);

		if (KFIM != None)
		{
			// Server Custom Balance
			InWeightLimit = class'ZedternalReborn.Config_Player'.default.Player_Weight;
			if (InWeightLimit == 0)
				InWeightLimit = KFIM.default.MaxCarryBlocks;

			DefaultWeightLimit = InWeightLimit;

			if (MyWMPRI != None && MyWMGRI != None)
			{
				for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
				{
					index = MyWMPRI.Purchase_PerkUpgrade[i];
					MyWMGRI.perkUpgrades[index].static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bPerkUpgrade[index]);
				}
				for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
				{
					index = MyWMPRI.Purchase_SkillUpgrade[i];
					MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bSkillUpgrade[index]);
				}
				for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
				{
					index = MyWMPRI.Purchase_EquipmentUpgrade[i];
					MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bEquipmentUpgrade[index]);
				}
				for (i = 0; i <= 1; ++i)
				{
					if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
						MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit);
				}
			}

			KFIM.MaxCarryBlocks = InWeightLimit;
			CheckForOverWeight(KFIM);
		}
	}
}

function ModifyDoTScaler(out float DoTScaler, optional class<KFDamageType> KFDT, optional bool bNapalmInfected)
{
	local byte i, index;
	local float DefaultDoTScaler;

	DefaultDoTScaler = DoTScaler;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bPerkUpgrade[index], KFDT, bNapalmInfected);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bSkillUpgrade[index], KFDT, bNapalmInfected);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bEquipmentUpgrade[index], KFDT, bNapalmInfected);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, KFDT, bNapalmInfected);
		}
	}
}

simulated function ModifyRateOfFire(out float InRate, KFWeapon KFW)
{
	local int i, index;
	local float DefaultRate;

	DefaultRate = InRate;
	if (KFWeap_FlameBase(KFW) == None)
		InRate *= PassiveRateOfFire;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bSkillUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyRateOfFire(InRate, DefaultRate, KFW);
		}
	}

	if (InRate <= 0.005f)
		InRate = 0.005f;
}

simulated function float GetTightChokeModifier()
{
	local int i, index;
	local float InTight, DefaultTight;
	local KFWeapon KFW;
	local KFInventoryManager KFIM;

	if (WMTimers.TightChokeModifierFlag)
	{
		return WMTimers.SavedTightChokeModifierValue;
	}

	KFW = GetOwnerWeapon();
	if (KFW == None && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != None && KFIM.PendingWeapon != None)
			KFW = KFWeapon(KFIM.PendingWeapon);
	}

	DefaultTight = 1.0f;
	InTight = DefaultTight * PassiveTightChoke;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyTightChoke(InTight, DefaultTight, KFW, OwnerPawn);
		}
	}

	if (InTight <= 0.005f)
		InTight = 0.005f;

	WMTimers.SavedTightChokeModifierValue = InTight;
	WMTimers.SetTightChokeModifierTimer();

	return InTight;
}

simulated function float GetPenetrationModifier(byte Level, class<KFDamageType> DamageType, optional bool bForce)
{
	local int i, index;
	local KFWeapon MyKFW;
	local float DefaultPenetration;
	local float InPenetration;

	if (WMTimers.PenetrationModifierFlag)
	{
		return WMTimers.SavedPenetrationModifierValue;
	}

	InPenetration = 1.0f;
	DefaultPenetration = InPenetration;
	InPenetration *= PassivePenetration;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bPerkUpgrade[index], DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.GetWeaponUpgrade(index), DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bSkillUpgrade[index], DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bEquipmentUpgrade[index], DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyPenetration(InPenetration, DefaultPenetration, DamageType, OwnerPawn, bForce);
		}
	}

	WMTimers.SavedPenetrationModifierValue = InPenetration;
	WMTimers.SetPenetrationModifierTimer();

	return InPenetration;
}

function float GetStunPowerModifier(optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	local int i, index;
	local KFWeapon MyKFW;
	local float DefaultStunPower;
	local float InStunPower;

	if (WMTimers.StunPowerModifierFlag)
	{
		return WMTimers.SavedStunPowerModifierValue;
	}

	InStunPower = 1.0f;
	DefaultStunPower = InStunPower;
	InStunPower *= PassiveStunPower;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bPerkUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.GetWeaponUpgrade(index), DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bSkillUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bEquipmentUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyStunPower(InStunPower, DefaultStunPower, DamageType, HitZoneIdx);
		}
	}

	WMTimers.SavedStunPowerModifierValue = InStunPower;
	WMTimers.SetStunPowerModifierTimer();

	return InStunPower;
}

function float GetStumblePowerModifier(optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart)
{
	local int i, index;
	local KFWeapon MyKFW;
	local float DefaultStumblePower;
	local float InStumblePower;

	if (WMTimers.StumblePowerModifierFlag)
	{
		return WMTimers.SavedStumblePowerModifierValue;
	}

	InStumblePower = 1.0f;
	DefaultStumblePower = InStumblePower;
	InStumblePower *= PassiveStumblePower;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bPerkUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.GetWeaponUpgrade(index), KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bSkillUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bEquipmentUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyStumblePower(InStumblePower, DefaultStumblePower, KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
	}

	WMTimers.SavedStumblePowerModifierValue = InStumblePower;
	WMTimers.SetStumblePowerModifierTimer();

	return InStumblePower;
}

function float GetKnockdownPowerModifier(optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting = False)
{
	local int i, index;
	local KFWeapon MyKFW;
	local float DefaultKnockdownPower;
	local float InKnockdownPower;

	if (WMTimers.KnockdownPowerModifierFlag)
	{
		return WMTimers.SavedKnockdownPowerModifierValue;
	}

	InKnockdownPower = 1.0f;
	DefaultKnockdownPower = InKnockdownPower;
	InKnockdownPower *= PassiveKnockdownPower;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bPerkUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bSkillUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
	}

	WMTimers.SavedKnockdownPowerModifierValue = InKnockdownPower;
	WMTimers.SetKnockdownPowerModifierTimer();

	return InKnockdownPower;
}

simulated function float GetSnareSpeedModifier()
{
	return 0.7f;
}

simulated function float GetSnarePowerModifier(optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	local byte i, index;
	local float DefaultSnarePower;
	local float InSnarePower;

	if (WMTimers.SnarePowerModifierFlag)
	{
		return WMTimers.SavedSnarePowerModifierValue;
	}

	InSnarePower = 1.0f;
	DefaultSnarePower = InSnarePower;
	InSnarePower *= PassiveSnarePower;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bPerkUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bSkillUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bEquipmentUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySnarePower(InSnarePower, DefaultSnarePower, DamageType, HitZoneIdx);
		}
	}

	WMTimers.SavedSnarePowerModifierValue = FMax(0.0f, InSnarePower - 1.0f);
	WMTimers.SetSnarePowerModifierTimer();

	return FMax(0.0f, InSnarePower - 1.0f);
}

simulated function ModifyWeaponSwitchTime(out float ModifiedSwitchTime)
{
	local int i, index;
	local float DefaultSwitchTime;
	local KFWeapon KFW;
	local KFInventoryManager KFIM;

	KFW = GetOwnerWeapon();
	if (KFW == None && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != None && KFIM.PendingWeapon != None)
			KFW = KFWeapon(KFIM.PendingWeapon);
	}

	DefaultSwitchTime = ModifiedSwitchTime;
	ModifiedSwitchTime *= PassiveSwitchSpeed;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bSkillUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, KFW);
		}
	}
}

function AddVampireHealth(KFPlayerController KFPC, class<DamageType> DT)
{
	local byte i, index;
	local int DefaultHealth;
	local int InHealth;

	InHealth = 0;
	DefaultHealth = InHealth;

	if (KFPC.Pawn != None)
	{
		// Server Custom Balance
		if (DT != None)
		{
			for (i = 0; i < class'ZedternalReborn.Config_Player'.default.Player_VampireEffect.length; ++i)
			{
				if (ClassIsChildOf(DT ,class'ZedternalReborn.Config_Player'.default.Player_VampireEffect[i].DamageType))
					InHealth += class'ZedternalReborn.Config_Player'.default.Player_VampireEffect[i].HealAmount;
			}
		}
		InHealth = Max(0, InHealth);
		DefaultHealth = InHealth;

		if (MyWMPRI != None && MyWMGRI != None)
		{
			for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_PerkUpgrade[i];
				MyWMGRI.perkUpgrades[index].static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bPerkUpgrade[index], KFPC, DT);
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				MyWMGRI.skillUpgrades[index].SkillUpgrade.static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bSkillUpgrade[index], KFPC, DT);
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bEquipmentUpgrade[index], KFPC, DT);
			}
			for (i = 0; i <= 1; ++i)
			{
				if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
					MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.AddVampireHealth(InHealth, DefaultHealth, KFPC, DT);
			}
		}

		KFPC.Pawn.HealDamage(InHealth, KFPC, class'KFDT_Healing', False, False);
	}
}

function bool CanSpreadNapalm()
{
	local byte i, index;
	local bool bCanSpreadNapalm;

	bCanSpreadNapalm = False;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.perkUpgrades[index].static.CanSpreadNapalm(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanSpreadNapalm(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.CanSpreadNapalm(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return True;
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCanSpreadNapalm = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.CanSpreadNapalm(OwnerPawn);
				if (bCanSpreadNapalm)
					return True;
			}
		}
	}

	return False;
}

simulated function bool CanKnockDownOnBump(KFPawn_Monster KFPM)
{
	local byte i, index;
	local bool bCanKnockDown;

	bCanKnockDown = False;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCanKnockDown = MyWMGRI.perkUpgrades[index].static.ShouldKnockDownOnBump(MyWMPRI.bPerkUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCanKnockDown = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldKnockDownOnBump(MyWMPRI.bSkillUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCanKnockDown = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ShouldKnockDownOnBump(MyWMPRI.bEquipmentUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return True;
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCanKnockDown = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ShouldKnockDownOnBump(KFPM, OwnerPawn);
				if (bCanKnockDown)
					return True;
			}
		}
	}

	return False;
}

simulated function bool ShouldNeverDud()
{
	local byte i, index;
	local bool bCouldExplode;
	local KFWeapon KFW;
	local KFInventoryManager KFIM;

	KFW = GetOwnerWeapon();
	if (KFW == None && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != None && KFIM.PendingWeapon != None)
			KFW = KFWeapon(KFIM.PendingWeapon);
	}

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCouldExplode = MyWMGRI.perkUpgrades[index].static.ShouldNeverDud(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCouldExplode = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldNeverDud(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCouldExplode = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ShouldNeverDud(MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCouldExplode = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ShouldNeverDud(KFW, OwnerPawn);
				if (bCouldExplode)
					return True;
			}
		}
	}

	return False;
}

function bool CouldBeZedShrapnel(class<KFDamageType> KFDT)
{
	local byte i, index;
	local bool bCouldExplode;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCouldExplode = MyWMGRI.perkUpgrades[index].static.CouldBeZedShrapnel(MyWMPRI.bPerkUpgrade[index], KFDT);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCouldExplode = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CouldBeZedShrapnel(MyWMPRI.bSkillUpgrade[index], KFDT);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCouldExplode = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.CouldBeZedShrapnel(MyWMPRI.bEquipmentUpgrade[index], KFDT);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCouldExplode = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.CouldBeZedShrapnel(KFDT);
				if (bCouldExplode)
					return True;
			}
		}
	}

	return False;
}

function GameExplosion GetExplosionTemplate()
{
	return default.ShrapnelExplosionTemplate;
}

simulated function bool ShouldShrapnel()
{
	local byte i, index;
	local bool bShouldExplode;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bShouldExplode = MyWMGRI.perkUpgrades[index].static.ShouldShrapnel(MyWMPRI.bPerkUpgrade[index]);
			if (bShouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bShouldExplode = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldShrapnel(MyWMPRI.bSkillUpgrade[index]);
			if (bShouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bShouldExplode = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ShouldShrapnel(MyWMPRI.bEquipmentUpgrade[index]);
			if (bShouldExplode)
				return True;
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bShouldExplode = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ShouldShrapnel();
				if (bShouldExplode)
					return True;
			}
		}
	}

	return False;
}

simulated function bool IsRangeActive()
{
	local byte i, index;
	local bool bRangeActive;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bRangeActive = MyWMGRI.perkUpgrades[index].static.IsRangeActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyPRI.bExtraFireRange = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bRangeActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsRangeActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyPRI.bExtraFireRange = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bRangeActive = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.IsRangeActive(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyPRI.bExtraFireRange = True;
				return True;
			}
		}
	}

	return False;
}

simulated function bool IsGroundFireActive()
{
	local byte i, index;
	local bool bSplashActive;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bSplashActive = MyWMGRI.perkUpgrades[index].static.IsGroundFireActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyPRI.bSplashActive = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bSplashActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsGroundFireActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyPRI.bSplashActive = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bSplashActive = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.IsGroundFireActive(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyPRI.bSplashActive = True;
				return True;
			}
		}
	}

	return False;
}

simulated function bool GetUsingTactialReload(KFWeapon KFW)
{
	local byte i, index;
	local bool bTacticalReload;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bTacticalReload = MyWMGRI.perkUpgrades[index].static.GetUsingTactialReload(MyWMPRI.bPerkUpgrade[index], KFW);
			if (bTacticalReload)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bTacticalReload = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetUsingTactialReload(MyWMPRI.bSkillUpgrade[index], KFW);
			if (bTacticalReload)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bTacticalReload = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetUsingTactialReload(MyWMPRI.bEquipmentUpgrade[index], KFW);
			if (bTacticalReload)
				return True;
		}
	}

	return False;
}

simulated function InitiateWeapon(KFWeapon KFW)
{
	local int i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.InitiateWeapon(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.InitiateWeapon(MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.InitiateWeapon(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.InitiateWeapon(MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.InitiateWeapon(KFW, OwnerPawn);
		}
	}

	ModifyMaxSpareGrenadeAmount();
}

simulated function float GetSelfHealingSurgePct()
{
	local byte i, index;
	local float InHealingPct;

	InHealingPct = 0.0f;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetSelfHealingSurgePct(InHealingPct);
		}
	}

	return InHealingPct;
}

simulated function bool IsHealingSurgeActive()
{
	return True;
}

simulated event float GetIronSightSpeedModifier(KFWeapon KFW)
{
	local int i, index;
	local float InSpeed, DefaultSpeed;

	DefaultSpeed = 1.0f;
	InSpeed = DefaultSpeed;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed);
		}
	}

	return InSpeed;
}

simulated event float GetCrouchSpeedModifier(KFWeapon KFW)
{
	local int i, index;
	local float InSpeed, DefaultSpeed;

	DefaultSpeed = 1.0f;
	InSpeed = DefaultSpeed;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed);
		}
	}

	return InSpeed;
}

function simulated SetSuccessfullParry()
{
	local byte i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.SuccessfullParry(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.SuccessfullParry(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.SuccessfullParry(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.SuccessfullParry(OwnerPawn);
		}
	}
}

function bool CanNotBeGrabbed()
{
	local byte i, index;
	local bool bNoGrab;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bNoGrab = MyWMGRI.perkUpgrades[index].static.CanNotBeGrabbed(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bNoGrab)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bNoGrab = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanNotBeGrabbed(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bNoGrab)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bNoGrab = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.CanNotBeGrabbed(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bNoGrab)
				return True;
		}
	}

	return False;
}

simulated function bool ShouldRandSirenResist()
{
	local byte i, index;
	local bool bResist;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bResist = MyWMGRI.perkUpgrades[index].static.ProjSirenResist(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bResist)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bResist = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ProjSirenResist(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bResist)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bResist = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ProjSirenResist(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bResist)
				return True;
		}
	}

	return False;
}

simulated function bool GetIsUberAmmoActive(KFWeapon KFW)
{
	local byte i, index;
	local bool bUber;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bUber = MyWMGRI.perkUpgrades[index].static.GetIsUberAmmoActive(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bUber = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetIsUberAmmoActive(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bUber = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetIsUberAmmoActive(MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return True;
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bUber = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetIsUberAmmoActive(KFW, OwnerPawn);
				if (bUber)
					return True;
			}
		}
	}

	return False;
}

function HealingDamage(int HealAmount, KFPawn KFP, class<DamageType> DamageType)
{
	local byte i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.HealingDamage(MyWMPRI.bPerkUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.HealingDamage(MyWMPRI.bSkillUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.HealingDamage(MyWMPRI.bEquipmentUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.HealingDamage(HealAmount, KFP, OwnerPawn, DamageType);
		}
	}
}

simulated function float GetZedTimeModifier(KFWeapon W)
{
	local byte i, index;
	local float InModifier;

	InModifier = 0.0f;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetZedTimeModifier(InModifier, MyWMPRI.bPerkUpgrade[index], W);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetZedTimeModifier(InModifier, MyWMPRI.bSkillUpgrade[index], W);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetZedTimeModifier(InModifier, MyWMPRI.bEquipmentUpgrade[index], W);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetZedTimeModifier(InModifier, W);
		}
	}

	return InModifier;
}

simulated function bool CanSeeEnemyHealth()
{
	local byte i, index;
	local bool bCanSee;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCanSee = MyWMGRI.perkUpgrades[index].static.CanSeeEnemyHealth(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCanSee)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCanSee = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanSeeEnemyHealth(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bCanSee)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCanSee = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.CanSeeEnemyHealth(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bCanSee)
				return True;
		}
	}

	return False;
}

simulated function bool IsCallOutActive()
{
	local byte i, index;
	local bool bCallOut;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		bCanSeeCloakedZeds = False;

		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCallOut = MyWMGRI.perkUpgrades[index].static.IsCallOutActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCallOut)
			{
				bCanSeeCloakedZeds = True;
				return bCanSeeCloakedZeds;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCallOut = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsCallOutActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bCallOut)
			{
				bCanSeeCloakedZeds = True;
				return bCanSeeCloakedZeds;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCallOut = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.IsCallOutActive(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bCallOut)
			{
				bCanSeeCloakedZeds = True;
				return bCanSeeCloakedZeds;
			}
		}
	}

	return bCanSeeCloakedZeds;
}

simulated function float GetCloakDetectionRange()
{
	local byte i, index;
	local float DefaultRange;
	local float InRange;

	InRange = 2000.0f;
	DefaultRange = InRange;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyCloakDetectionRange(InRange, DefaultRange);
		}
	}

	return InRange;
}

simulated function ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch)
{
	local byte i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ReceiveLocalizedMessage(MyWMPRI.bPerkUpgrade[index], Message, OwnerPawn, Switch);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ReceiveLocalizedMessage(MyWMPRI.bSkillUpgrade[index], Message, OwnerPawn, Switch);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ReceiveLocalizedMessage(MyWMPRI.bEquipmentUpgrade[index], Message, OwnerPawn, Switch);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ReceiveLocalizedMessage(Message, OwnerPawn, Switch);
		}
	}
}

simulated function bool ShouldSacrifice()
{
	local byte i, index;
	local bool bSacrifice;

	if (!bUsedSacrifice)
	{
		if (MyWMPRI != None && MyWMGRI != None)
		{
			for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_PerkUpgrade[i];
				bSacrifice = MyWMGRI.perkUpgrades[index].static.ShouldSacrifice(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
				if (bSacrifice)
					return True;
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				bSacrifice = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldSacrifice(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
				if (bSacrifice)
					return True;
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				bSacrifice = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ShouldSacrifice(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
				if (bSacrifice)
					return True;
			}
		}
	}

	return False;
}

function NotifyPerkSacrificeExploded()
{
	bUsedSacrifice = True;
	if (OwnerPawn != None)
		OwnerPawn.HealDamage(50, OwnerPawn.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');
}

simulated function bool DoorShouldNuke()
{
	local byte i, index;
	local bool bTrap;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bTrap = MyWMGRI.perkUpgrades[index].static.DoorShouldNuke(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bTrap = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.DoorShouldNuke(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bTrap = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.DoorShouldNuke(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
	}

	return False;
}

simulated function bool CanExplosiveWeld()
{
	local byte i, index;
	local bool bTrap;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bTrap = MyWMGRI.perkUpgrades[index].static.CanExplosiveWeld(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bTrap = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanExplosiveWeld(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bTrap = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.CanExplosiveWeld(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
	}

	return False;
}

simulated function Interact(KFPawn_Human KFPH)
{
	local int Idx;
	local bool bCanSupplyAmmo, bCanSupplyArmor, bCanSupplyGrenades;
	local bool bReceivedAmmo, bReceivedArmor, bReceivedGrenades;
	local float PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage;
	local int GrenadeAmount;
	local KFWeapon KFW;
	local WMPawn_Human WMPH;
	local KFPlayerController KFPC;
	local KFInventoryManager KFIM;
	local KFPlayerReplicationInfo UserPRI, OwnerPRI;
	local SuppliedPawnInfo SPI;

	// Do nothing if supplier isn't active
	if (!IsSupplierActive())
		return;

	if (WMPawn_Human(KFPH) != None)
		WMPH = WMPawn_Human(KFPH);
	else
		return;

	bCanSupplyAmmo = True;
	bCanSupplyArmor = True;
	bCanSupplyGrenades = True;
	Idx = SuppliedPawnList.Find('SuppliedPawn', WMPH);
	if (Idx != INDEX_NONE)
	{
		bCanSupplyAmmo = !SuppliedPawnList[Idx].bSuppliedAmmo;
		bCanSupplyArmor = !SuppliedPawnList[Idx].bSuppliedArmor;
		bCanSupplyGrenades = !SuppliedPawnList[Idx].bSuppliedGrenades;
		if (!bCanSupplyAmmo && !bCanSupplyArmor && !bCanSupplyGrenades)
			return;
	}

	SupplierModifiers(PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);

	if (bCanSupplyAmmo && (PrimaryAmmoPercentage > 0.0f || SecondaryAmmoPercentage > 0.0f))
	{
		foreach WMPH.InvManager.InventoryActors(class'KFWeapon', KFW)
		{
			if (KFW.static.DenyPerkResupply())
				continue;

			bReceivedAmmo = (KFW.AddAmmo(FCeil(KFW.GetMaxAmmoAmount(0) * PrimaryAmmoPercentage)) > 0) ? True : False;

			if (KFW.CanRefillSecondaryAmmo())
				bReceivedAmmo = (KFW.AddSecondaryAmmo(FCeil(KFW.GetMaxAmmoAmount(1) * SecondaryAmmoPercentage)) > 0) ? True : bReceivedAmmo;
		}
	}

	if (bCanSupplyArmor && ArmorPercentage > 0.0f && WMPH.ZedternalArmor != WMPH.GetMaxArmor())
	{
		WMPH.AddArmor(WMPH.ZedternalMaxArmor * ArmorPercentage);
		bReceivedArmor = True;
	}

	if (bCanSupplyGrenades && GrenadeAmount > 0)
	{
		KFIM = KFInventoryManager(WMPH.InvManager);
		if (KFIM != None)
			bReceivedGrenades = KFIM.AddGrenades(GrenadeAmount);
	}

	// Add to array (if necessary) and flag as supplied as needed
	if (bReceivedAmmo || bReceivedArmor || bReceivedGrenades)
	{
		if (Idx == INDEX_NONE)
		{
			SPI.SuppliedPawn = WMPH;
			SPI.bSuppliedAmmo = bReceivedAmmo;
			SPI.bSuppliedArmor = bReceivedArmor;
			SPI.bSuppliedGrenades = bReceivedGrenades;
			Idx = SuppliedPawnList.Length;
			SuppliedPawnList.AddItem(SPI);
		}
		else
		{
			SuppliedPawnList[Idx].bSuppliedAmmo = SuppliedPawnList[Idx].bSuppliedAmmo || bReceivedAmmo;
			SuppliedPawnList[Idx].bSuppliedArmor = SuppliedPawnList[Idx].bSuppliedArmor || bReceivedArmor;
			SuppliedPawnList[Idx].bSuppliedGrenades = SuppliedPawnList[Idx].bSuppliedGrenades || bReceivedGrenades;
		}

		if (Role == ROLE_Authority)
		{
			KFPC = KFPlayerController(WMPH.Controller);
			if (KFPC != None)
			{
				if (bReceivedAmmo)
				{
					OwnerPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', bReceivedArmor ? GMT_GaveAmmoAndArmorTo : GMT_GaveAmmoTo, KFPC.PlayerReplicationInfo);
					KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', bReceivedArmor ? GMT_ReceivedAmmoAndArmorFrom : GMT_ReceivedAmmoFrom, OwnerPC.PlayerReplicationInfo);
				}
				else if (bReceivedArmor)
				{
					OwnerPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_GaveArmorTo, KFPC.PlayerReplicationInfo);
					KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_ReceivedArmorFrom, OwnerPC.PlayerReplicationInfo);
				}
				else if (bReceivedGrenades)
				{
					OwnerPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_GaveGrenadesTo, KFPC.PlayerReplicationInfo);
					KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_ReceivedGrenadesFrom, OwnerPC.PlayerReplicationInfo);
				}

				UserPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
				OwnerPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
				if (UserPRI != None && OwnerPRI != None)
					UserPRI.MarkSupplierOwnerUsed(OwnerPRI, SuppliedPawnList[Idx].bSuppliedAmmo, SuppliedPawnList[Idx].bSuppliedArmor || SuppliedPawnList[Idx].bSuppliedGrenades);
			}
		}
	}
	else if (Role == ROLE_Authority)
	{
		KFPC = KFPlayerController(WMPH.Controller);
		if (KFPC != None)
		{
			if (ArmorPercentage > 0.0f)
				KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_AmmoAndArmorAreFull, OwnerPC.PlayerReplicationInfo);
			else
				KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_AmmoIsFull, OwnerPC.PlayerReplicationInfo);
		}
	}
}

simulated function bool CanInteract(KFPawn_Human MyKFPH)
{
	local float PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage;
	local int GrenadeAmount, Idx;

	if (IsSupplierActive() && WMPawn_Human(MyKFPH) != None)
	{
		Idx = SuppliedPawnList.Find('SuppliedPawn', WMPawn_Human(MyKFPH));

		// Pawn hasn't gotten anything from us yet
		if (Idx == INDEX_NONE)
			return True;

		SupplierModifiers(PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);

		// Pawn hasn't gotten something
		return (!SuppliedPawnList[Idx].bSuppliedAmmo && (PrimaryAmmoPercentage > 0.0f || SecondaryAmmoPercentage > 0.0f)) ||
		(!SuppliedPawnList[Idx].bSuppliedArmor && ArmorPercentage > 0.0f) ||
		(!SuppliedPawnList[Idx].bSuppliedGrenades && GrenadeAmount > 0);
	}
}

simulated function bool IsSupplierActive()
{
	local byte i, index;
	local bool bActive;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bActive = MyWMGRI.perkUpgrades[index].static.IsSupplierActive(MyWMPRI.bPerkUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsSupplierActive(MyWMPRI.bSkillUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.IsSupplierActive(MyWMPRI.bEquipmentUpgrade[index]);
			if (bActive)
				return True;
		}
	}

	return False;
}

simulated function SupplierModifiers(out float PrimaryAmmoPercentage, out float SecondaryAmmoPercentage, out float ArmorPercentage, out int GrenadeAmount)
{
	local byte i, index;

	PrimaryAmmoPercentage = 0.0f;
	SecondaryAmmoPercentage = 0.0f;
	ArmorPercentage = 0.0f;
	GrenadeAmount = 0;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.SupplierModifiers(MyWMPRI.bPerkUpgrade[index], PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.SupplierModifiers(MyWMPRI.bSkillUpgrade[index], PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.SupplierModifiers(MyWMPRI.bEquipmentUpgrade[index], PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
		}
	}

	PrimaryAmmoPercentage = FClamp(PrimaryAmmoPercentage, 0.0f, 100.0f);
	SecondaryAmmoPercentage = FClamp(SecondaryAmmoPercentage, 0.0f, 100.0f);
	ArmorPercentage = FClamp(ArmorPercentage, 0.0f, 100.0f);
	GrenadeAmount = Clamp(GrenadeAmount, 0, 255);
}

function WaveEnd(KFPlayerController KFPC)
{
	local byte i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.WaveEnd(MyWMPRI.bPerkUpgrade[index], KFPC);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.WaveEnd(MyWMPRI.bSkillUpgrade[index], KFPC);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.WaveEnd(MyWMPRI.bEquipmentUpgrade[index], KFPC);
		}
	}
}

simulated function DrawSpecialPerkHUD(Canvas C)
{
	local byte i, index;
	local KFPawn_Monster KFPM;
	local vector ViewLocation, ViewDir;
	local float DetectionRangeSq, ThisDot;
	local float HealthBarLength, HealthbarHeight;

	if (OwnerPawn != None)
	{
		DetectionRangeSq = Square(GetCloakDetectionRange());

		if (CanSeeEnemyHealth())
		{
			HealthbarLength = FMin(50.0f * (float(C.SizeX) / 1024.0f), 50.0f);
			HealthbarHeight = FMin(6.0f * (float(C.SizeX) / 1024.0f), 6.0f);

			ViewLocation = OwnerPawn.GetPawnViewLocation();
			ViewDir = vector(OwnerPawn.GetViewRotation());

			foreach WorldInfo.AllPawns(class'KFPawn_Monster', KFPM)
			{
				if (!KFPM.CanShowHealth()
					|| !KFPM.IsAliveAndWell()
					|| (WorldInfo.TimeSeconds - KFPM.Mesh.LastRenderTime) > 0.1f
					|| VSizeSQ(KFPM.Location - OwnerPawn.Location) > DetectionRangeSq)
				{
					continue;
				}

				ThisDot = ViewDir dot Normal(KFPM.Location - OwnerPawn.Location);
				if (ThisDot > 0.0f)
				{
					DrawZedHealthbar(C, KFPM, ViewLocation, HealthbarHeight, HealthbarLength);
				}
			}

		}

		if (IsCallOutActive())
		{
			foreach WorldInfo.AllPawns(class'KFPawn_Monster', KFPM)
			{
				if (KFPM.bCanCloak)
					KFPM.CallOutCloaking();
			}
		}
	}

	// perk, skill, and equipment sections
	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.DrawOnHUD(MyWMPRI.bPerkUpgrade[index], C, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.DrawOnHUD(MyWMPRI.bSkillUpgrade[index], C, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.DrawOnHUD(MyWMPRI.bEquipmentUpgrade[index], C, OwnerPawn);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.DrawOnHUD(C, OwnerPawn);
		}
	}
}

simulated function DrawZedHealthbar(Canvas C, KFPawn_Monster KFPM, vector CameraLocation, float HealthbarHeight, float HealthbarLength)
{
	local vector ScreenPos, TargetLocation;
	local float HealthScale;

	if (KFPM.bCrawler && KFPM.Floor.Z <= -0.7f && KFPM.Physics == PHYS_Spider)
	{
		TargetLocation = KFPM.Location + vect(0,0,-1) * KFPM.GetCollisionHeight() * 1.2f * KFPM.CurrentBodyScale;
	}
	else
	{
		TargetLocation = KFPM.Location + vect(0,0,1) * KFPM.GetCollisionHeight() * 1.2f * KFPM.CurrentBodyScale;
	}

	ScreenPos = C.Project(TargetLocation);
	if (ScreenPos.X < 0 || ScreenPos.X > C.SizeX || ScreenPos.Y < 0 || ScreenPos.Y > C.SizeY)
	{
		return;
	}

	if (class'KFGameEngine'.static.FastTrace_PhysX(TargetLocation, CameraLocation))
	{
		HealthScale = FClamp(float(KFPM.Health) / float(KFPM.HealthMax), 0.0f, 1.0f);

		C.EnableStencilTest(True);
		C.SetDrawColor(0, 0, 0, 255);
		C.SetPos(ScreenPos.X - HealthBarLength * 0.5f, ScreenPos.Y);
		C.DrawTile(WhiteMaterial, HealthbarLength, HealthbarHeight, 0, 0, 32, 32);

		C.SetDrawColor(237, 8, 0, 255);
		C.SetPos(ScreenPos.X - HealthBarLength * 0.5f + 1.0f, ScreenPos.Y + 1.0f);
		C.DrawTile(WhiteMaterial, (HealthBarLength - 2.0f) * HealthScale, HealthbarHeight - 2.0f, 0, 0, 32, 32);
		C.EnableStencilTest(False);
	}
}

// healing darts powerup function
simulated function byte GetHealingDamageBoost()
{
	local byte i, index;
	local byte InHealingDamageBoost;

	InHealingDamageBoost = 0;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}

	return InHealingDamageBoost;
}

simulated function byte GetMaxHealingDamageBoost()
{
	local byte i, index;
	local byte InMaxHealingDamageBoost;

	InMaxHealingDamageBoost = 0;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}

	return InMaxHealingDamageBoost;
}

simulated function byte GetHealingShield()
{
	local byte i, index;
	local byte InHealingShield;

	InHealingShield = 0;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetHealingShield(InHealingShield, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetHealingShield(InHealingShield, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetHealingShield(InHealingShield, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}

	return InHealingShield;
}

simulated function byte GetMaxHealingShield()
{
	local byte i, index;
	local byte InMaxHealingShield;

	InMaxHealingShield = 0;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}

	return InMaxHealingShield;
}

simulated function bool HasNightVision()
{
	local byte i, index;
	local bool bActive;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bActive = MyWMGRI.perkUpgrades[index].static.HasNightVision(MyWMPRI.bPerkUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.HasNightVision(MyWMPRI.bSkillUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.HasNightVision(MyWMPRI.bEquipmentUpgrade[index]);
			if (bActive)
				return True;
		}
	}

	return False;
}

simulated function class<EmitterCameraLensEffectBase> GetPerkLensEffect(class<KFDamageType> DmgType)
{
	local byte i, index;
	local class<EmitterCameraLensEffectBase> CamEffect;

	CamEffect = DmgType.default.CameraLensEffectTemplate;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetPerkLensEffect(CamEffect, DmgType, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetPerkLensEffect(CamEffect, DmgType, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetPerkLensEffect(CamEffect, DmgType, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}

	return CamEffect;
}

function bool IsUnAffectedByZedTime()
{
	local byte i, index;
	local bool bActive;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bActive = MyWMGRI.perkUpgrades[index].static.IsUnAffectedByZedTime(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bActive)
			{
				OwnerPawn.bMovesFastInZedTime = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsUnAffectedByZedTime(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bActive)
			{
				OwnerPawn.bMovesFastInZedTime = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.IsUnAffectedByZedTime(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bActive)
			{
				OwnerPawn.bMovesFastInZedTime = True;
				return True;
			}
		}
	}

	return False;
}

simulated function ApplyBatteryRechargeRate()
{
	local byte i, index;
	local float InRechargeRateFL, InRechargeRateNVG;

	if (OwnerPawn != None)
	{
		InRechargeRateFL = 1.0f;
		InRechargeRateNVG = 1.0f;

		if (MyWMPRI != None && MyWMGRI != None)
		{
			for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_PerkUpgrade[i];
				MyWMGRI.perkUpgrades[index].static.GetBatteryRateScale(InRechargeRateFL, InRechargeRateNVG, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetBatteryRateScale(InRechargeRateFL, InRechargeRateNVG, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.GetBatteryRateScale(InRechargeRateFL, InRechargeRateNVG, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			}
		}

		if (InRechargeRateFL <= 0.05f)
			InRechargeRateFL = 0.05f;

		if (InRechargeRateNVG <= 0.05f)
			InRechargeRateNVG = 0.05f;

		OwnerPawn.BatteryDrainRate = OwnerPawn.default.BatteryDrainRate * InRechargeRateFL;
		OwnerPawn.NVGBatteryDrainRate = OwnerPawn.default.NVGBatteryDrainRate * InRechargeRateNVG;
	}
}

simulated function bool ImmuneToCameraShake()
{
	local byte i, index;
	local bool bActive;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bActive = MyWMGRI.perkUpgrades[index].static.ImmuneToCameraShake(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ImmuneToCameraShake(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.equipmentUpgrades[index].EquipmentUpgrade.static.ImmuneToCameraShake(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bActive)
				return True;
		}
	}

	return False;
}

defaultproperties
{
	bUsedSacrifice=False
	PerkBuildStatID=0
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'
	ShrapnelExplosionTemplate=KFGameExplosion'KFGame.Default__KFPerk_Survivalist:ExploTemplate0'
	WhiteMaterial=Texture2D'EngineResources.WhiteSquareTexture'

	StartingWeaponClassIndex=INDEX_NONE
	PrimaryWeaponDef=class'KFGame.KFWeapDef_Random'
	KnifeWeaponDef=class'KFGame.KFWeapDef_Knife_SharpShooter'
	GrenadeWeaponDef=class'KFGame.KFWeapDef_Grenade_Commando'

	PrimaryWeaponPaths(0)=class'KFGame.KFWeapDef_AR15'
	PrimaryWeaponPaths(1)=class'KFGame.KFWeapDef_MB500'
	PrimaryWeaponPaths(2)=class'KFGame.KFWeapDef_Crovel'
	PrimaryWeaponPaths(3)=class'KFGame.KFWeapDef_HX25'
	PrimaryWeaponPaths(4)=class'KFGame.KFWeapDef_MedicPistol'
	PrimaryWeaponPaths(5)=class'KFGame.KFWeapDef_CaulkBurn'
	PrimaryWeaponPaths(6)=class'KFGame.KFWeapDef_Remington1858Dual'
	PrimaryWeaponPaths(7)=class'KFGame.KFWeapDef_Winchester1894'
	PrimaryWeaponPaths(8)=class'KFGame.KFWeapDef_MP7'
	KnivesWeaponDef(0)=class'KFGame.KFWeapDef_Knife_Berserker'
	KnivesWeaponDef(1)=class'KFGame.KFWeapDef_Knife_Commando'
	KnivesWeaponDef(2)=class'KFGame.KFWeapDef_Knife_Demo'
	KnivesWeaponDef(3)=class'KFGame.KFWeapDef_Knife_Firebug'
	KnivesWeaponDef(4)=class'KFGame.KFWeapDef_Knife_Gunslinger'
	KnivesWeaponDef(5)=class'KFGame.KFWeapDef_Knife_Medic'
	KnivesWeaponDef(6)=class'KFGame.KFWeapDef_Knife_SharpShooter'
	KnivesWeaponDef(7)=class'KFGame.KFWeapDef_Knife_Support'
	KnivesWeaponDef(8)=class'KFGame.KFWeapDef_Knife_Survivalist'
	KnivesWeaponDef(9)=class'KFGame.KFWeapDef_Knife_SWAT'

	Name="Default__WMPerk"
}
