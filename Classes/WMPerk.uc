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

var private int Difficulty;

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

//Events
var private array<S_Damage> ValidDamageGiven;
var private array< class<DamageType> > DamageGivenObjects;

var private array<S_Damage> ValidDamageTaken;
var private array< class<DamageType> > DamageTakenObjects;

var private array<S_Vampire> ValidVampireEffect;
var private array< class<DamageType> > VampireEffectObjects;

//Timers class to keep track of cached variables and flags
var private WMPerk_Timers WMTimers;

var private transient string CachedWeaponPath;
var private transient string CachedDTWeaponPath;

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

	if (Role == ROLE_Authority)
	{
		class'ZedternalReborn.Config_Player'.static.LoadConfigObjects_DamageGiven(ValidDamageGiven, DamageGivenObjects);
		class'ZedternalReborn.Config_Player'.static.LoadConfigObjects_DamageTaken(ValidDamageTaken, DamageTakenObjects);
		class'ZedternalReborn.Config_Player'.static.LoadConfigObjects_Vampire(ValidVampireEffect, VampireEffectObjects);
	}

	CacheCurrentDifficulty();
}

function CacheCurrentDifficulty()
{
	if (Role < ROLE_Authority)
	{
		return;
	}

	if (WMGameInfo_Endless(WorldInfo.Game) != None)
	{
		Difficulty = WMGameInfo_Endless(WorldInfo.Game).GameDifficultyZedternal;
	}
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

simulated function SetCachedVariables()
{
	if (OwnerPC == None)
		OwnerPC = KFPlayerController(Owner);

	if (OwnerPawn == None && OwnerPC != None)
		OwnerPawn = KFPawn_Human(OwnerPC.Pawn);

	if (MyWMPRI == None && OwnerPC != None)
		MyWMPRI = WMPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);

	if (MyWMGRI == None)
		MyWMGRI = WMGameReplicationInfo(WorldInfo.GRI);
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	OwnerPawn = KFPawn_Human(PlayerPawn);
	bForceNetUpdate = True;

	OwnerPC = KFPlayerController(Owner);
	if (OwnerPC != None)
	{
		MyPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
		MyWMPRI = WMPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
	}

	MyWMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	PerkSetOwnerHealthAndArmorZedternal(True);

	// apply all other pawn changes
	ApplySkillsToPawn();
}

simulated function PerkSetOwnerHealthAndArmorZedternal(optional bool bModifyHealth)
{
	local WMPawn_Human WMPH;

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

		if (MyWMPRI != None)
		{
			MyWMPRI.PlayerHealthInt = WMPH.Health;
			MyWMPRI.PlayerHealth = FloatToByte(float(WMPH.Health) / float(WMPH.HealthMax));
			MyWMPRI.PlayerHealthPercent = MyWMPRI.PlayerHealth;
		}

		WMPH.ZedternalMaxArmor = WMPH.default.ZedternalMaxArmor;
		ModifyArmorInt(WMPH.ZedternalMaxArmor);
		WMPH.ZedternalArmor = Min(WMPH.ZedternalArmor, WMPH.ZedternalMaxArmor);
		WMPH.AdjustArmorPct();

		if (MyWMPRI != None)
			MyWMPRI.PlayerArmorInt = WMPH.ZedternalArmor;
	}
}

function ApplySkillsToPawn()
{
	if (CheckOwnerPawn())
	{
		OwnerPawn.UpdateGroundSpeed();
		OwnerPawn.bMovesFastInZedTime = IsUnAffectedByZedTime();

		if (MyWMPRI == None)
			MyWMPRI = WMPlayerReplicationInfo(OwnerPawn.PlayerReplicationInfo);

		MyWMPRI.bExtraFireRange = IsRangeActive();
		MyWMPRI.bSplashActive = IsGroundFireActive();
		MyWMPRI.bNukeActive = False;
		MyWMPRI.bConcussiveActive = False;
		MyWMPRI.PerkSupplyLevel = IsSupplierActive() ? MyWMPRI.PerkSupplyLevel : 0;

		ApplyWeightLimits();
		ApplyBatteryRechargeRate();
		ServerComputePassiveBonuses();
		ClientAndServerComputePassiveBonuses();
	}
	else
	{
		ServerPassiveBonusDefaults();
		ClientAndServerPassiveBonusDefaults();
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

		if (WMGI != None && WMGI.StartingWeapons.Length > 0)
		{
			StartingWeaponsList = WMGI.StartingWeapons;
			for (i = 0; i < class'ZedternalReborn.Config_Player'.static.GetStartingWeaponAmount(Difficulty); ++i)
			{
				if (StartingWeaponsList.Length > 0)
				{
					choice = Rand(StartingWeaponsList.Length);

					if (StartingWeaponsList[choice] != None)
						P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(StartingWeaponsList[choice].default.WeaponClassPath, class'Class')));

					StartingWeaponsList.Remove(choice, 1);
				}
				else
					break;
			}
		}

		// Secondary weapon is spawned through the pawn unless we want an additional one not anymore
		P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetSecondaryWeaponClassPath(), class'Class')));
		P.DefaultInventory.AddItem(class<Weapon>(DynamicLoadObject(GetKnifeWeaponClassPath(), class'Class')));
	}
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

	if (WMPC != None && WMPC.Preferences != None)
		index = WMPC.Preferences.KnifeIndex;
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

simulated function bool isValidWeapon(class<KFWeapon> WeaponClass, KFWeapon KFW)
{
	local KFPawn KP;

	if (KFW == None)
		return False;
	if (KFW.Class == WeaponClass)
		return True;
	if (KFWeap_DualBase(KFW) != None && KFWeap_DualBase(KFW).SingleClass == WeaponClass)
		return True;

	KP = KFPawn(KFW.Owner);
	if (KP != None && KP.bIsTurret && KFWeapon(KP.Owner) != None && KFWeapon(KP.Owner).Class == WeaponClass)
		return True;

	return False;
}

simulated function string GetGrenadeImagePath()
{
	return GrenadeWeaponDef.static.GetImagePath();
}

simulated function class<KFWeaponDefinition> GetGrenadeWeaponDef()
{
	return GrenadeWeaponDef;
}

function ServerPassiveBonusDefaults()
{
	PassiveDamageGiven = 1.0f;
	PassiveDamageTaken = 1.0f;
	PassiveHealAmount = 1.0f;
	PassiveHardAttackDamage = 1.0f;
	PassiveStunPower = 1.0f;
	PassiveStumblePower = 1.0f;
	PassiveKnockdownPower = 1.0f;
	PassiveSnarePower = 1.0f;
}

function ServerComputePassiveBonuses()
{
	local byte i, index;

	ServerPassiveBonusDefaults();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyDamageGivenPassive(PassiveDamageGiven, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyDamageTakenPassive(PassiveDamageTaken, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyHealAmountPassive(PassiveHealAmount, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyHardAttackDamagePassive(PassiveHardAttackDamage, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyStunPowerPassive(PassiveStunPower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyStumblePowerPassive(PassiveStumblePower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyKnockdownPowerPassive(PassiveKnockdownPower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifySnarePowerPassive(PassiveSnarePower, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyDamageGivenPassive(PassiveDamageGiven, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyDamageTakenPassive(PassiveDamageTaken, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyHealAmountPassive(PassiveHealAmount, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyHardAttackDamagePassive(PassiveHardAttackDamage, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyStunPowerPassive(PassiveStunPower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyStumblePowerPassive(PassiveStumblePower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyKnockdownPowerPassive(PassiveKnockdownPower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifySnarePowerPassive(PassiveSnarePower, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyDamageGivenPassive(PassiveDamageGiven, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyDamageTakenPassive(PassiveDamageTaken, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyHealAmountPassive(PassiveHealAmount, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyHardAttackDamagePassive(PassiveHardAttackDamage, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyStunPowerPassive(PassiveStunPower, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyStumblePowerPassive(PassiveStumblePower, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyKnockdownPowerPassive(PassiveKnockdownPower, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifySnarePowerPassive(PassiveSnarePower, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}
}

simulated function ClientAndServerPassiveBonusDefaults()
{
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
}

simulated function ClientAndServerComputePassiveBonuses()
{
	local byte i, index;

	ClientAndServerPassiveBonusDefaults();

	if (OwnerPC == None || OwnerPawn == None || MyWMPRI == None || MyWMGRI == None)
		SetCachedVariables();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifySpeedPassive(PassiveMovementSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyWeaponSwitchTimePassive(PassiveSwitchSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyMeleeAttackSpeedPassive(PassiveMeleeAttackSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetReloadRateScalePassive(PassiveReloadRateScale, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyRecoilPassive(PassiveRecoil, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyWeaponBopDampingPassive(PassiveBobDamp, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyMagSizeAndNumberPassive(PassiveMagazineCapacity, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifySpareAmmoAmountPassive(PassiveSpareAmmo, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyRateOfFirePassive(PassiveRateOfFire, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyTightChokePassive(PassiveTightChoke, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyPenetrationPassive(PassivePenetration, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifySpeedPassive(PassiveMovementSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyWeaponSwitchTimePassive(PassiveSwitchSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyMeleeAttackSpeedPassive(PassiveMeleeAttackSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetReloadRateScalePassive(PassiveReloadRateScale, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyRecoilPassive(PassiveRecoil, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyWeaponBopDampingPassive(PassiveBobDamp, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyMagSizeAndNumberPassive(PassiveMagazineCapacity, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifySpareAmmoAmountPassive(PassiveSpareAmmo, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyRateOfFirePassive(PassiveRateOfFire, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyTightChokePassive(PassiveTightChoke, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyPenetrationPassive(PassivePenetration, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifySpeedPassive(PassiveMovementSpeed, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyWeaponSwitchTimePassive(PassiveSwitchSpeed, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyMeleeAttackSpeedPassive(PassiveMeleeAttackSpeed, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetReloadRateScalePassive(PassiveReloadRateScale, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyRecoilPassive(PassiveRecoil, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyWeaponBopDampingPassive(PassiveBobDamp, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyMagSizeAndNumberPassive(PassiveMagazineCapacity, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifySpareAmmoAmountPassive(PassiveSpareAmmo, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyRateOfFirePassive(PassiveRateOfFire, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyTightChokePassive(PassiveTightChoke, MyWMPRI.bEquipmentUpgrade[index]);
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyPenetrationPassive(PassivePenetration, MyWMPRI.bEquipmentUpgrade[index]);
		}
	}
}

simulated function ResetSupplier()
{
	local float PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage;
	local int GrenadeAmount;
	local byte count;

	if (MyWMPRI != None && IsSupplierActive())
	{
		if (SuppliedPawnList.Length > 0)
			SuppliedPawnList.Remove(0, SuppliedPawnList.Length);

		SupplierModifiers(PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
		count = 0;
		if (PrimaryAmmoPercentage > 0.0f || SecondaryAmmoPercentage > 0.0f)
			++count;
		if (ArmorPercentage > 0.0f)
			++count;
		if (GrenadeAmount > 0)
			++count;

		MyWMPRI.PerkSupplyLevel = count;

		if (InteractionTrigger != None)
		{
			InteractionTrigger.Destroy();
			InteractionTrigger = None;
		}

		if (CheckOwnerPawn() && MyWMPRI.PerkSupplyLevel > 0)
		{
			InteractionTrigger = Spawn(class'KFUsablePerkTrigger', OwnerPawn, , OwnerPawn.Location, OwnerPawn.Rotation, , True);
			InteractionTrigger.SetBase(OwnerPawn);
			InteractionTrigger.SetInteractionIndex(IMT_ReceiveAmmo);
			OwnerPC.SetPendingInteractionMessage();
		}
	}
	else if (InteractionTrigger != None)
	{
		InteractionTrigger.Destroy();
	}
}

function GetWeaponFromDamageType(out KFWeapon MyKFW, class<KFDamageType> DamageType)
{
	local KFWeapon TempKFW;
	local class<KFWeapon> DTWeapon;
	local string DTWeaponPath, TempKFWPath;

	TempKFW = GetOwnerWeapon();
	if (TempKFW != None && DamageType.default.WeaponDef != None)
	{
		DTWeaponPath = DamageType.default.WeaponDef.default.WeaponClassPath;
		TempKFWPath = PathName(TempKFW.Class);

		if (DTWeaponPath ~= TempKFWPath)
		{
			CachedWeaponPath = TempKFWPath;
			CachedDTWeaponPath = DTWeaponPath;
			MyKFW = TempKFW;
		}
		else if (DTWeaponPath ~= CachedDTWeaponPath && TempKFWPath ~= CachedWeaponPath)
		{
			MyKFW = TempKFW;
		}
		else
		{
			DTWeapon = class<KFWeapon>(DynamicLoadObject(DTWeaponPath, class'Class', True));
			if (DTWeapon != None && ClassIsChildOf(TempKFW.Class, DTWeapon))
			{
				CachedWeaponPath = TempKFWPath;
				CachedDTWeaponPath = DTWeaponPath;
				MyKFW = TempKFW;
			}
		}
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
			MyKFW = KFWeapon(DamageCauser);
		else if (DamageCauser.IsA('Projectile'))
			MyKFW = KFWeapon(DamageCauser.Owner);
		else if (DamageCauser.IsA('KFSprayActor'))
			MyKFW = GetOwnerWeapon();
		else
			MyKFW = None;
	}

	if (MyKFW == None && DamageType != None && !class'ZedternalReborn.WMWeaponConstants'.static.IsGrenadeDTAdvance(DamageType, GrenadeWeaponDef))
		GetWeaponFromDamageType(MyKFW, DamageType);

	// Server Custom Balance
	if (DamageType != None)
	{
		for (i = 0; i < ValidDamageGiven.Length; ++i)
		{
			if (ClassIsChildOf(DamageType, DamageGivenObjects[i]))
				InDamage += Round(float(DefaultDamage) * (ValidDamageGiven[i].Multiplier - 1.0f));
		}
	}
	InDamage = Max(0, InDamage);
	DefaultDamage = InDamage;
	InDamage = Round(float(DefaultDamage) * PassiveDamageGiven);

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyDamageGiven(InDamage, DefaultDamage, DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bEquipmentUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyHardAttackDamage(InDamage, DefaultDamage, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
		for (i = 0; i < ValidDamageTaken.Length; ++i)
		{
			if (ClassIsChildOf(DamageType, DamageTakenObjects[i]))
				InDamage += Round(float(DefaultDamage) * (ValidDamageTaken[i].Multiplier - 1.0f));
		}

		if (MyKFW.IsMeleeWeapon())
		{
			InDamage += Round(float(DefaultDamage) * (class'ZedternalReborn.Config_Player'.static.GetDamageTakenMultiplierWhileHoldingMelee(Difficulty) - 1.0f));
		}
	}

	InDamage = Max(1, InDamage);
	DefaultDamage = InDamage;
	InDamage = Round(float(DefaultDamage) * PassiveDamageTaken);

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyDamageTaken(InDamage, DefaultDamage, OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
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
	InHealth = class'ZedternalReborn.Config_Player'.static.GetStartingMaxHealth(Difficulty);

	DefaultHealth = InHealth;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyHealth(InHealth, DefaultHealth);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bSkillUpgrade[index]);
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
	MaxArmor = class'ZedternalReborn.Config_Player'.static.GetStartingMaxArmor(Difficulty);

	DefaultArmor = MaxArmor;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyArmor(MaxArmor, DefaultArmor);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bSkillUpgrade[index]);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bSkillUpgrade[index], KFW);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.GetReloadRateScale(InReloadRateScale, KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
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
	HealAmount *= class'ZedternalReborn.Config_Player'.static.GetHealAmountMultiplier(Difficulty);

	HealAmount *= PassiveHealAmount;
	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyHealAmount(HealAmount, DefaultHealAmount);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bSkillUpgrade[index]);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bSkillUpgrade[index]);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifySpeed(Speed, DefaultSpeed, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bSkillUpgrade[index], KFW);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, PawnWeapon))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.GetWeaponUpgrade(index), PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bPerkUpgrade[index], PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bEquipmentUpgrade[index], PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bSkillUpgrade[index], PawnWeapon);
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

		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.GetWeaponUpgrade(index), KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bPerkUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bEquipmentUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bSkillUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
	}

	// crossbow and bow does not work well with more than 1 ammo per clip
	if (KFWeap_Bow_Crossbow(KFW) == None && KFWeap_Bow_CompoundBow(KFW) == None && KFWeap_HRG_Crossboom(KFW) == None)
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
			for (i = 0; i <= 1; ++i)
			{
				if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
					MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_WeaponUpgrade[i];
				if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
					MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.GetWeaponUpgrade(index), KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_PerkUpgrade[i];
				MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bPerkUpgrade[index], KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bEquipmentUpgrade[index], KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bSkillUpgrade[index], KFW, TraderItem, bSecondary);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bSkillUpgrade[index]);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bSkillUpgrade[index]);
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

		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.GetZedTimeExtension(Extension, DefaultExtension);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bSkillUpgrade[index]);
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

	if (CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);

		if (KFIM != None)
		{
			// Server Custom Balance
			InWeightLimit = class'ZedternalReborn.Config_Player'.static.GetStartingCarryWeight(Difficulty);

			DefaultWeightLimit = InWeightLimit;

			if (MyWMPRI != None && MyWMGRI != None)
			{
				for (i = 0; i <= 1; ++i)
				{
					if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
						MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit);
				}
				for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
				{
					index = MyWMPRI.Purchase_PerkUpgrade[i];
					MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bPerkUpgrade[index]);
				}
				for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
				{
					index = MyWMPRI.Purchase_EquipmentUpgrade[i];
					MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bEquipmentUpgrade[index]);
				}
				for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
				{
					index = MyWMPRI.Purchase_SkillUpgrade[i];
					MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bSkillUpgrade[index]);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, KFDT, bNapalmInfected);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bPerkUpgrade[index], KFDT, bNapalmInfected);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bEquipmentUpgrade[index], KFDT, bNapalmInfected);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bSkillUpgrade[index], KFDT, bNapalmInfected);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyRateOfFire(InRate, DefaultRate, KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bSkillUpgrade[index], KFW);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyTightChoke(InTight, DefaultTight, KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyPenetration(InPenetration, DefaultPenetration, DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.GetWeaponUpgrade(index), DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bPerkUpgrade[index], DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bEquipmentUpgrade[index], DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bSkillUpgrade[index], DamageType, OwnerPawn, bForce);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyStunPower(InStunPower, DefaultStunPower, DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.GetWeaponUpgrade(index), DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bPerkUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bEquipmentUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bSkillUpgrade[index], DamageType, HitZoneIdx);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.GetWeaponUpgrade(index), KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bPerkUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bEquipmentUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bSkillUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bPerkUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bSkillUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifySnarePower(InSnarePower, DefaultSnarePower, DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bPerkUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bEquipmentUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bSkillUpgrade[index], DamageType, HitZoneIdx);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bEquipmentUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bSkillUpgrade[index], KFW);
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
			for (i = 0; i < ValidVampireEffect.Length; ++i)
			{
				if (ClassIsChildOf(DT, VampireEffectObjects[i]))
					InHealth += ValidVampireEffect[i].HealAmount;
			}
		}
		InHealth = Max(0, InHealth);
		DefaultHealth = InHealth;

		if (MyWMPRI != None && MyWMGRI != None)
		{
			for (i = 0; i <= 1; ++i)
			{
				if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
					MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.AddVampireHealth(InHealth, DefaultHealth, KFPC, DT);
			}
			for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_PerkUpgrade[i];
				MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bPerkUpgrade[index], KFPC, DT);
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bEquipmentUpgrade[index], KFPC, DT);
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bSkillUpgrade[index], KFPC, DT);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCanSpreadNapalm = MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.CanSpreadNapalm(OwnerPawn);
				if (bCanSpreadNapalm)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.CanSpreadNapalm(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.CanSpreadNapalm(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.CanSpreadNapalm(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return True;
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCanKnockDown = MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ShouldKnockDownOnBump(KFPM, OwnerPawn);
				if (bCanKnockDown)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCanKnockDown = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ShouldKnockDownOnBump(MyWMPRI.bPerkUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCanKnockDown = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ShouldKnockDownOnBump(MyWMPRI.bEquipmentUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCanKnockDown = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ShouldKnockDownOnBump(MyWMPRI.bSkillUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return True;
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCouldExplode = MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ShouldNeverDud(KFW, OwnerPawn);
				if (bCouldExplode)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCouldExplode = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ShouldNeverDud(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCouldExplode = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ShouldNeverDud(MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCouldExplode = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ShouldNeverDud(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return True;
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bCouldExplode = MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.CouldBeZedShrapnel(KFDT);
				if (bCouldExplode)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bCouldExplode = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.CouldBeZedShrapnel(MyWMPRI.bPerkUpgrade[index], KFDT);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCouldExplode = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.CouldBeZedShrapnel(MyWMPRI.bEquipmentUpgrade[index], KFDT);
			if (bCouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCouldExplode = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.CouldBeZedShrapnel(MyWMPRI.bSkillUpgrade[index], KFDT);
			if (bCouldExplode)
				return True;
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bShouldExplode = MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ShouldShrapnel();
				if (bShouldExplode)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bShouldExplode = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ShouldShrapnel(MyWMPRI.bPerkUpgrade[index]);
			if (bShouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bShouldExplode = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ShouldShrapnel(MyWMPRI.bEquipmentUpgrade[index]);
			if (bShouldExplode)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bShouldExplode = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ShouldShrapnel(MyWMPRI.bSkillUpgrade[index]);
			if (bShouldExplode)
				return True;
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
			bRangeActive = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.IsRangeActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyWMPRI.bExtraFireRange = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bRangeActive = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.IsRangeActive(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyWMPRI.bExtraFireRange = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bRangeActive = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.IsRangeActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyWMPRI.bExtraFireRange = True;
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
			bSplashActive = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.IsGroundFireActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyWMPRI.bSplashActive = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bSplashActive = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.IsGroundFireActive(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyWMPRI.bSplashActive = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bSplashActive = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.IsGroundFireActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyWMPRI.bSplashActive = True;
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
			bTacticalReload = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetUsingTactialReload(MyWMPRI.bPerkUpgrade[index], KFW);
			if (bTacticalReload)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bTacticalReload = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetUsingTactialReload(MyWMPRI.bEquipmentUpgrade[index], KFW);
			if (bTacticalReload)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bTacticalReload = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetUsingTactialReload(MyWMPRI.bSkillUpgrade[index], KFW);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.InitiateWeapon(KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.InitiateWeapon(MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.InitiateWeapon(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.InitiateWeapon(MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.InitiateWeapon(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.GetSelfHealingSurgePct(InHealingPct);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bSkillUpgrade[index]);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index]);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, KFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index]);
		}
	}

	return InSpeed;
}

function simulated SetSuccessfullParry()
{
	local byte i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.SuccessfullParry(OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.SuccessfullParry(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.SuccessfullParry(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.SuccessfullParry(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
			bNoGrab = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.CanNotBeGrabbed(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bNoGrab)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bNoGrab = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.CanNotBeGrabbed(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bNoGrab)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bNoGrab = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.CanNotBeGrabbed(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
			bResist = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ProjSirenResist(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bResist)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bResist = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ProjSirenResist(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bResist)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bResist = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ProjSirenResist(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bUber = MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.GetIsUberAmmoActive(KFW, OwnerPawn);
				if (bUber)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bUber = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetIsUberAmmoActive(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bUber = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetIsUberAmmoActive(MyWMPRI.bEquipmentUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bUber = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetIsUberAmmoActive(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return True;
		}
	}

	return False;
}

function HealingDamage(int HealAmount, KFPawn KFP, class<DamageType> DamageType)
{
	local byte i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.HealingDamage(HealAmount, KFP, OwnerPawn, DamageType);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.HealingDamage(MyWMPRI.bPerkUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.HealingDamage(MyWMPRI.bEquipmentUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.HealingDamage(MyWMPRI.bSkillUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.GetZedTimeModifier(InModifier, W);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetZedTimeModifier(InModifier, MyWMPRI.bPerkUpgrade[index], W);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetZedTimeModifier(InModifier, MyWMPRI.bEquipmentUpgrade[index], W);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetZedTimeModifier(InModifier, MyWMPRI.bSkillUpgrade[index], W);
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
			bCanSee = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.CanSeeEnemyHealth(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCanSee)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCanSee = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.CanSeeEnemyHealth(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bCanSee)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCanSee = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.CanSeeEnemyHealth(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
			bCallOut = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.IsCallOutActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCallOut)
			{
				bCanSeeCloakedZeds = True;
				return bCanSeeCloakedZeds;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bCallOut = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.IsCallOutActive(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bCallOut)
			{
				bCanSeeCloakedZeds = True;
				return bCanSeeCloakedZeds;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bCallOut = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.IsCallOutActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ModifyCloakDetectionRange(InRange, DefaultRange);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bSkillUpgrade[index]);
		}
	}

	return InRange;
}

simulated function ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch)
{
	local byte i, index;

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ReceiveLocalizedMessage(Message, OwnerPawn, Switch);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ReceiveLocalizedMessage(MyWMPRI.bPerkUpgrade[index], Message, OwnerPawn, Switch);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ReceiveLocalizedMessage(MyWMPRI.bEquipmentUpgrade[index], Message, OwnerPawn, Switch);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ReceiveLocalizedMessage(MyWMPRI.bSkillUpgrade[index], Message, OwnerPawn, Switch);
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
				bSacrifice = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ShouldSacrifice(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
				if (bSacrifice)
					return True;
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				bSacrifice = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ShouldSacrifice(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
				if (bSacrifice)
					return True;
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				bSacrifice = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ShouldSacrifice(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
	if (CheckOwnerPawn())
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
			bTrap = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.DoorShouldNuke(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bTrap = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.DoorShouldNuke(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bTrap = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.DoorShouldNuke(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
			bTrap = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.CanExplosiveWeld(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bTrap = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.CanExplosiveWeld(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bTrap = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.CanExplosiveWeld(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bTrap)
				return True;
		}
	}

	return False;
}

simulated function bool DenyPerkResupply(const out KFWeapon KFW)
{
	if (KFW.default.InventoryGroup >= IG_Equipment)
	{
		if (ClassIsChildOf(KFW.Class, class'KFWeap_Thrown_C4'))
			return False;

		if (ClassIsChildOf(KFW.Class, class'KFWeap_AutoTurret'))
			return False;

		return True;
	}

	return False;
}

simulated function Interact(KFPawn_Human KFPH)
{
	local int Idx;
	local bool bCanSupplyAmmo, bCanSupplyArmor, bCanSupplyGrenades;
	local bool bSupplyAmmoEnabled, bSupplyArmorEnabled, bSupplyGrenadesEnabled;
	local bool bReceivedAmmo, bReceivedArmor, bReceivedGrenades;
	local float PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage;
	local int GrenadeAmount;
	local KFWeapon KFW;
	local WMPawn_Human WMPH;
	local KFPlayerController KFPC;
	local KFInventoryManager KFIM;
	local WMPlayerReplicationInfo UserPRI, OwnerPRI;
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
	bSupplyAmmoEnabled = PrimaryAmmoPercentage > 0.0f || SecondaryAmmoPercentage > 0.0f;
	bSupplyArmorEnabled = ArmorPercentage > 0.0f;
	bSupplyGrenadesEnabled = GrenadeAmount > 0;

	if (bCanSupplyAmmo && bSupplyAmmoEnabled)
	{
		foreach WMPH.InvManager.InventoryActors(class'KFWeapon', KFW)
		{
			if (DenyPerkResupply(KFW))
				continue;

			bReceivedAmmo = (KFW.AddAmmo(FCeil(float(KFW.GetMaxAmmoAmount(0)) * PrimaryAmmoPercentage)) > 0) ? True : bReceivedAmmo;

			if (KFW.CanRefillSecondaryAmmo())
				bReceivedAmmo = (KFW.AddSecondaryAmmo(FCeil(float(KFW.GetMaxAmmoAmount(1)) * SecondaryAmmoPercentage)) > 0) ? True : bReceivedAmmo;
		}
	}

	if (bCanSupplyArmor && bSupplyArmorEnabled && WMPH.ZedternalArmor != WMPH.GetMaxArmor())
	{
		WMPH.AddArmor(WMPH.ZedternalMaxArmor * ArmorPercentage);
		bReceivedArmor = True;
	}

	if (bCanSupplyGrenades && bSupplyGrenadesEnabled)
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

				UserPRI = WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
				OwnerPRI = WMPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
				if (UserPRI != None && OwnerPRI != None)
				{
					if (OwnerPRI.PerkSupplyLevel == 3)
					{
						UserPRI.MarkSupplierOwnerUsedZedternal(OwnerPRI, SuppliedPawnList[Idx].bSuppliedAmmo, SuppliedPawnList[Idx].bSuppliedArmor, SuppliedPawnList[Idx].bSuppliedGrenades);
					}
					else if (OwnerPRI.PerkSupplyLevel == 2)
					{
						if (!bSupplyAmmoEnabled)
							UserPRI.MarkSupplierOwnerUsedZedternal(OwnerPRI, SuppliedPawnList[Idx].bSuppliedArmor, SuppliedPawnList[Idx].bSuppliedGrenades);
						else if (!bSupplyArmorEnabled)
							UserPRI.MarkSupplierOwnerUsedZedternal(OwnerPRI, SuppliedPawnList[Idx].bSuppliedAmmo, SuppliedPawnList[Idx].bSuppliedGrenades);
						else if (!bSupplyGrenadesEnabled)
							UserPRI.MarkSupplierOwnerUsedZedternal(OwnerPRI, SuppliedPawnList[Idx].bSuppliedAmmo, SuppliedPawnList[Idx].bSuppliedArmor);
					}
					else if (OwnerPRI.PerkSupplyLevel == 1)
					{
						if (bSupplyAmmoEnabled)
							UserPRI.MarkSupplierOwnerUsedZedternal(OwnerPRI, SuppliedPawnList[Idx].bSuppliedAmmo);
						else if (bSupplyArmorEnabled)
							UserPRI.MarkSupplierOwnerUsedZedternal(OwnerPRI, SuppliedPawnList[Idx].bSuppliedArmor);
						else if (bSupplyGrenadesEnabled)
							UserPRI.MarkSupplierOwnerUsedZedternal(OwnerPRI, SuppliedPawnList[Idx].bSuppliedGrenades);
					}
				}
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

	return False;
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
			bActive = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.IsSupplierActive(MyWMPRI.bPerkUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.IsSupplierActive(MyWMPRI.bEquipmentUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.IsSupplierActive(MyWMPRI.bSkillUpgrade[index]);
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
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.SupplierModifiers(MyWMPRI.bPerkUpgrade[index], PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.SupplierModifiers(MyWMPRI.bEquipmentUpgrade[index], PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.SupplierModifiers(MyWMPRI.bSkillUpgrade[index], PrimaryAmmoPercentage, SecondaryAmmoPercentage, ArmorPercentage, GrenadeAmount);
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
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.WaveEnd(MyWMPRI.bPerkUpgrade[index], KFPC);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.WaveEnd(MyWMPRI.bEquipmentUpgrade[index], KFPC);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.WaveEnd(MyWMPRI.bSkillUpgrade[index], KFPC);
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

	if (CheckOwnerPawn())
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
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.DrawOnHUD(C, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.DrawOnHUD(MyWMPRI.bPerkUpgrade[index], C, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.DrawOnHUD(MyWMPRI.bEquipmentUpgrade[index], C, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.DrawOnHUD(MyWMPRI.bSkillUpgrade[index], C, OwnerPawn);
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
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bSkillUpgrade[index]);
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
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bSkillUpgrade[index]);
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
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetHealingShield(InHealingShield, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetHealingShield(InHealingShield, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetHealingShield(InHealingShield, MyWMPRI.bSkillUpgrade[index]);
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
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bSkillUpgrade[index]);
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
			bActive = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.HasNightVision(MyWMPRI.bPerkUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.HasNightVision(MyWMPRI.bEquipmentUpgrade[index]);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.HasNightVision(MyWMPRI.bSkillUpgrade[index]);
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
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetPerkLensEffect(CamEffect, DmgType, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetPerkLensEffect(CamEffect, DmgType, MyWMPRI.bEquipmentUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetPerkLensEffect(CamEffect, DmgType, MyWMPRI.bSkillUpgrade[index]);
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
			bActive = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.IsUnAffectedByZedTime(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bActive)
			{
				OwnerPawn.bMovesFastInZedTime = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.IsUnAffectedByZedTime(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bActive)
			{
				OwnerPawn.bMovesFastInZedTime = True;
				return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.IsUnAffectedByZedTime(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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

	if (CheckOwnerPawn())
	{
		InRechargeRateFL = 1.0f;
		InRechargeRateNVG = 1.0f;

		if (MyWMPRI != None && MyWMGRI != None)
		{
			for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_PerkUpgrade[i];
				MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.GetBatteryRateScale(InRechargeRateFL, InRechargeRateNVG, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			}
			for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_EquipmentUpgrade[i];
				MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.GetBatteryRateScale(InRechargeRateFL, InRechargeRateNVG, MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			}
			for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
			{
				index = MyWMPRI.Purchase_SkillUpgrade[i];
				MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.GetBatteryRateScale(InRechargeRateFL, InRechargeRateNVG, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
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
			bActive = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ImmuneToCameraShake(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ImmuneToCameraShake(MyWMPRI.bEquipmentUpgrade[index], OwnerPawn);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ImmuneToCameraShake(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bActive)
				return True;
		}
	}

	return False;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Universal extension functions (they are used for advance extension mods and addons)
// The Identifier variable should be used to prevent collisions with other mods which use the extension functions
// Put a unique name and then verify the name in your custom upgrades/special waves to prevent incorrect triggering
// The object inputs can be used for anything, you will just need to cast the object to the correct type

simulated function bool ExtensionFuncBoolean(string Identifier, optional int InputInt = INDEX_NONE, optional float InputFloat = INDEX_NONE, optional name InputClassName, optional Object InputObject1, optional Object InputObject2, optional Object InputObject3)
{
	local int i, index;
	local bool bActive;
	local KFWeapon MyKFW;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
			{
				bActive = MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ExtensionFuncBoolean(Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
				if (bActive)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
			{
				bActive = MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ExtensionFuncBoolean(MyWMPRI.GetWeaponUpgrade(index), Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
				if (bActive)
					return True;
			}
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			bActive = MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ExtensionFuncBoolean(MyWMPRI.bPerkUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			bActive = MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ExtensionFuncBoolean(MyWMPRI.bEquipmentUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
			if (bActive)
				return True;
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			bActive = MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ExtensionFuncBoolean(MyWMPRI.bSkillUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
			if (bActive)
				return True;
		}
	}

	return False;
}

simulated function int ExtensionFuncInteger(int DefaultValueIn, string Identifier, optional int InputInt = INDEX_NONE, optional float InputFloat = INDEX_NONE, optional name InputClassName, optional Object InputObject1, optional Object InputObject2, optional Object InputObject3)
{
	local int i, index;
	local int DefaultValue, InValue;
	local KFWeapon MyKFW;

	DefaultValue = DefaultValueIn;
	InValue = DefaultValue;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ExtensionFuncInteger(InValue, DefaultValue, Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ExtensionFuncInteger(InValue, DefaultValue, MyWMPRI.GetWeaponUpgrade(index), Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ExtensionFuncInteger(InValue, DefaultValue, MyWMPRI.bPerkUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ExtensionFuncInteger(InValue, DefaultValue, MyWMPRI.bEquipmentUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ExtensionFuncInteger(InValue, DefaultValue, MyWMPRI.bSkillUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
	}

	return InValue;
}

simulated function float ExtensionFuncFloat(float DefaultValueIn, string Identifier, optional int InputInt = INDEX_NONE, optional float InputFloat = INDEX_NONE, optional name InputClassName, optional Object InputObject1, optional Object InputObject2, optional Object InputObject3)
{
	local int i, index;
	local float DefaultValue, InValue;
	local KFWeapon MyKFW;

	DefaultValue = DefaultValueIn;
	InValue = DefaultValue;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != None && MyWMGRI != None)
	{
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != INDEX_NONE)
				MyWMGRI.SpecialWavesList[MyWMGRI.SpecialWaveID[i]].SpecialWave.static.ExtensionFuncFloat(InValue, DefaultValue, Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_WeaponUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_WeaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.WeaponUpgradeSlotsList[index].KFWeapon, MyKFW))
				MyWMGRI.WeaponUpgradeSlotsList[index].WeaponUpgrade.static.ExtensionFuncFloat(InValue, DefaultValue, MyWMPRI.GetWeaponUpgrade(index), Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_PerkUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_PerkUpgrade[i];
			MyWMGRI.PerkUpgradesList[index].PerkUpgrade.static.ExtensionFuncFloat(InValue, DefaultValue, MyWMPRI.bPerkUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_EquipmentUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_EquipmentUpgrade[i];
			MyWMGRI.EquipmentUpgradesList[index].EquipmentUpgrade.static.ExtensionFuncFloat(InValue, DefaultValue, MyWMPRI.bEquipmentUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
		for (i = 0; i < MyWMPRI.Purchase_SkillUpgrade.length; ++i)
		{
			index = MyWMPRI.Purchase_SkillUpgrade[i];
			MyWMGRI.SkillUpgradesList[index].SkillUpgrade.static.ExtensionFuncFloat(InValue, DefaultValue, MyWMPRI.bSkillUpgrade[index], Identifier, MyKFW, OwnerPawn, InputInt, InputFloat, InputClassName, InputObject1, InputObject2, InputObject3);
		}
	}

	return InValue;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
	bUsedSacrifice=False
	PerkBuildStatID=0
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'
	InteractIcon=Texture2D'UI_World_TEX.Support_Supplier_HUD'
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
