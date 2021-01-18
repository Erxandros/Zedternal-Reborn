class WMPerk extends KFPerk;

var WMPlayerReplicationInfo MyWMPRI;
var WMGameReplicationInfo MyWMGRI;

var private const GameExplosion			ShrapnelExplosionTemplate;
var const int 							HeatWaveRadiusSQ;
var KFGameExplosion						NukeExplosionTemplate;
var class<KFExplosionActor>				NukeExplosionActorClass;
var private const 	float 				NukeDamageModifier;
var private const 	float 				NukeRadiusModifier;
var private	const	int 				LingeringNukePoisonDamage;
var private const 	class<KFDamagetype>	LingeringNukeDamageType;
var private bool						bUsedSacrifice;

// Passive bonuses : to accelerate calcul, global permanant passive bonuses are cached into these variables
var float passiveDamageGiven;
var float passiveDamageTaken;
var float passiveHealAmount;
var float passiveHardAttackDamage;
var float passiveStunPower;
var float passiveStumblePower;
var float passiveKnockdownPower;
var float passiveSnarePower;
var float passiveMovementSpeed;
var float passiveSwitchSpeed;
var float passiveMeleeAttackSpeed;
var float passiveReloadRateScale;
var float passiveRecoil;
var float passiveBobDamp;
var float passiveMagazineCapacity;
var float passiveSpareAmmo;
var float passiveRateOfFire;
var float passiveTightChoke;
var float passivePenetration;

// Supplier Info
struct sSuppliedPawnInfo
{
	var KFPawn_Human SuppliedPawn;
	var bool bSuppliedAmmo;
};
var array<sSuppliedPawnInfo> SuppliedPawnList;

var Texture2d WhiteMaterial;
var private const array<class<KFWeaponDefinition> > PrimaryWeaponPaths;
var array< class< KFWeaponDefinition > > KnivesWeaponDef;
var int StartingWeaponClassIndex;

//new variables to remove localisation
struct WM_PassivePerk
{
	var string Title;
	var string Description;
	var string IconPath;
};

var byte KnifeIndexFromClient;

//Timers class to keep track of cached variables and flags
var private WMPerk_Timers WMTimers;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();

	WMTimers = Spawn(class'WMPerk_Timers', self);

	if (WMPlayerController(OwnerPC) != none)
		GetKnifeIndexFromClient();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Owner != none)
	{
		MyWMPRI = WMPlayerReplicationInfo(KFPlayerController(Owner).PlayerReplicationInfo);
		if (MyWMPRI == none)
			MyWMPRI = WMPlayerReplicationInfo(MyPRI);
	}
	MyWMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMTimers == None)
		WMTimers = Spawn(class'WMPerk_Timers', self); //Try again just in case
}

function bool ShouldGetAllTheXP()
{
	return true;
}

function OnWaveStart()
{
	Super.OnWaveStart();
	ResetSupplier();
}

simulated function PlayerDied()
{
	super.PlayerDied();

	if (InteractionTrigger != none)
	{
		InteractionTrigger.DestroyTrigger();
	}
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	OwnerPawn = KFPawn_Human(PlayerPawn);
	bForceNetUpdate = true;

	OwnerPC = KFPlayerController(Owner);
	if (OwnerPC != none)
	{
		MyPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
	}

	PerkSetOwnerHealthAndArmorZedternal(true);

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

	if (WMPH != none)
	{
		if (bModifyHealth)
		{
			WMPH.Health = WMPH.default.Health;
			ModifyHealth(WMPH.Health);
		}

		WMPH.HealthMax = WMPH.default.Health;
		ModifyHealth(WMPH.HealthMax);
		WMPH.Health = Min(WMPH.Health, WMPH.HealthMax);

		if (OwnerPC == none)
			OwnerPC = KFPlayerController(Owner);

		MyPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
		if (MyPRI != none)
			WMPRI = WMPlayerReplicationInfo(MyPRI);

		if (WMPRI != none)
		{
			WMPRI.PlayerHealth = WMPH.Health;
			WMPRI.PlayerHealthPercent = FloatToByte(float(WMPH.Health) / float(WMPH.HealthMax));
		}

		WMPH.ZedternalMaxArmor = WMPH.default.ZedternalMaxArmor;
		ModifyArmorInt(WMPH.ZedternalMaxArmor);
		WMPH.ZedternalArmor = Min(WMPH.ZedternalArmor, WMPH.ZedternalMaxArmor);
		WMPH.AdjustArmorPct();

		if (WMPRI != none)
		{
			WMPRI.PlayerArmor = WMPH.ZedternalArmor;
			WMPRI.PlayerHealthPercent = FloatToByte(float(WMPH.ZedternalArmor) / float(WMPH.ZedternalMaxArmor));
		}
	}
}

function ApplySkillsToPawn()
{
	local KFGameReplicationInfo KFGRI;

	if (CheckOwnerPawn())
	{
		OwnerPawn.UpdateGroundSpeed();
		//OwnerPawn.bMovesFastInZedTime = false;

		MyPRI.bExtraFireRange = IsRangeActive();
		MyPRI.bSplashActive = IsGroundFireActive();
		MyPRI.bNukeActive = false;
		MyPRI.bConcussiveActive = false;
		MyPRI.PerkSupplyLevel = 0;

		ApplyWeightLimits();
		ServerComputePassiveBonuses();
	}

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);

	if (KFGRI == none && KFGRI.bTraderIsOpen)
		return;
	ResetSupplier();
}

function AddDefaultInventory(KFPawn P)
{
	local KFInventoryManager KFIM;
	local WMGameInfo_Endless WMGI;
	local array< class<KFWeaponDefinition> > StartingWeaponsList;
	local int i, choice;

	if (P != none && P.InvManager != none)
	{
		KFIM = KFInventoryManager(P.InvManager);
		if (KFIM != none)
		{
			//Grenades added on spawn
			KFIM.GiveInitialGrenadeCount();
		}

		WMGI = WMGameInfo_Endless(MyKFGI);

		if (WMGI != none && WMGI.PerkStartingWeapon.length > 0)
		{
			StartingWeaponsList = WMGI.PerkStartingWeapon;
			for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponNumber; i++)
			{
				if (StartingWeaponsList.Length > 0)
				{
					choice = Rand(StartingWeaponsList.Length);

					if (StartingWeaponsList[choice] != none)
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

	if (WMPC != none)
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

	return false;
}

function OnWaveEnded()
{
	Super.OnWaveEnded();
	bUsedSacrifice = false;
	if (OwnerPC != none)
		OwnerPC.SetPerkEffect(false);
}

static simulated function bool IsWeaponOnSpecificPerk(KFWeapon W, class<KFPerk> Perk)
{
	if (W != none)
	{
		return W.static.GetWeaponPerkClass(Perk) == Perk;
	}

	return false;
}

static function bool IsDamageTypeOnSpecificPerk(class<KFDamageType> KFDT, class<KFPerk> Perk)
{
	if (KFDT != none)
	{
		return KFDT.default.ModifierPerkList.Find(Perk) > INDEX_NONE;
	}

	return false;
}

simulated function bool isValidWeapon(class< KFWeapon > weaponClass, KFWeapon KFW)
{
	if (KFW == none)
		return false;
	else if (KFW.class == weaponClass)
		return true;
	else if (KFWeap_DualBase(KFW) != none && KFWeap_DualBase(KFW).SingleClass == weaponClass)
		return true;

	return false;
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
	local byte i;
	local byte index;

	passiveDamageGiven = 1.0f;
	passiveDamageTaken = 1.0f;
	passiveHealAmount = 1.0f;
	passiveHardAttackDamage = 1.0f;
	passiveStunPower = 1.0f;
	passiveStumblePower = 1.0f;
	passiveKnockdownPower = 1.0f;
	passiveSnarePower = 1.0f;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDamageGivenPassive(passiveDamageGiven, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyDamageTakenPassive(passiveDamageTaken, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyHealAmountPassive(passiveHealAmount, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyHardAttackDamagePassive(passiveHardAttackDamage, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyStunPowerPassive(passiveStunPower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyStumblePowerPassive(passiveStumblePower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyKnockdownPowerPassive(passiveKnockdownPower, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifySnarePowerPassive(passiveSnarePower, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageGivenPassive(passiveDamageGiven, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageTakenPassive(passiveDamageTaken, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealAmountPassive(passiveHealAmount, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHardAttackDamagePassive(passiveHardAttackDamage, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStunPowerPassive(passiveStunPower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStumblePowerPassive(passiveStumblePower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyKnockdownPowerPassive(passiveKnockdownPower, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySnarePowerPassive(passiveSnarePower, MyWMPRI.bSkillUpgrade[index]);
		}
	}
}

simulated function ClientAndServerComputePassiveBonuses()
{
	local byte i;
	local byte index;

	passiveMovementSpeed = 1.0f;
	passiveSwitchSpeed = 1.0f;
	passiveMeleeAttackSpeed = 1.0f;
	passiveReloadRateScale = 1.0f;
	passiveRecoil = 1.0f;
	passiveBobDamp = 1.0f;
	passiveMagazineCapacity = 1.0f;
	passiveSpareAmmo = 1.0f;
	passiveRateOfFire = 1.0f;
	passiveTightChoke = 1.0f;
	passivePenetration = 1.0f;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySpeedPassive(passiveMovementSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponSwitchTimePassive(passiveSwitchSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyMeleeAttackSpeedPassive(passiveMeleeAttackSpeed, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.GetReloadRateScalePassive(passiveReloadRateScale, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyRecoilPassive(passiveRecoil, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponBopDampingPassive(passiveBobDamp, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyMagSizeAndNumberPassive(passiveMagazineCapacity, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifySpareAmmoAmountPassive(passiveSpareAmmo, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyRateOfFirePassive(passiveRateOfFire, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyTightChokePassive(passiveTightChoke, MyWMPRI.bPerkUpgrade[index]);
			MyWMGRI.perkUpgrades[index].static.ModifyPenetrationPassive(passivePenetration, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpeedPassive(passiveMovementSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponSwitchTimePassive(passiveSwitchSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMeleeAttackSpeedPassive(passiveMeleeAttackSpeed, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetReloadRateScalePassive(passiveReloadRateScale, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRecoilPassive(passiveRecoil, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponBopDampingPassive(passiveBobDamp, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMagSizeAndNumberPassive(passiveMagazineCapacity, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpareAmmoAmountPassive(passiveSpareAmmo, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRateOfFirePassive(passiveRateOfFire, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyTightChokePassive(passiveTightChoke, MyWMPRI.bSkillUpgrade[index]);
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyPenetrationPassive(passivePenetration, MyWMPRI.bSkillUpgrade[index]);
		}
	}
}

simulated function ResetSupplier()
{
	if (MyPRI != none && IsSupplierActive())
	{
		if (SuppliedPawnList.Length > 0)
		{
			SuppliedPawnList.Remove(0, SuppliedPawnList.Length);
		}

		MyPRI.PerkSupplyLevel = 1;

		if (InteractionTrigger != none)
		{
			InteractionTrigger.Destroy();
			InteractionTrigger = none;
		}

		if (CheckOwnerPawn())
		{
			InteractionTrigger = Spawn(class'KFUsablePerkTrigger', OwnerPawn,, OwnerPawn.Location, OwnerPawn.Rotation,, true);
			InteractionTrigger.SetBase(OwnerPawn);
			InteractionTrigger.SetInteractionIndex(IMT_ReceiveAmmo);
			OwnerPC.SetPendingInteractionMessage();
		}
	}
	else if (InteractionTrigger != none)
	{
		InteractionTrigger.Destroy();
	}
}

function ModifyDamageGiven(out int InDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx)
{
	local KFWeapon MyKFW;
	local int DefaultDamage;
	local int i;
	local int index;

	DefaultDamage = InDamage;

	if (DamageCauser != none)
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
			MyKFW = none;
	}

	// Server Custom Balance
	if (DamageType != none)
	{
		for (i = 0; i < class'ZedternalReborn.Config_Player'.default.Player_DamageGivenFactor.length; ++i)
		{
			if (ClassIsChildOf(DamageType, class'ZedternalReborn.Config_Player'.default.Player_DamageGivenFactor[i].DamageType))
				InDamage += Round(float(DefaultDamage) * (class'ZedternalReborn.Config_Player'.default.Player_DamageGivenFactor[i].Factor - 1.0f));
		}
	}
	InDamage = Max(0, InDamage);
	DefaultDamage = InDamage;
	InDamage = Round(float(DefaultDamage) * passiveDamageGiven);

	// GetWeapon : MyKFW = none when player deals damage with flamethrower/freezethrower...
	if (DamageType != none && (
		class<KFDT_Fire_FlameThrower>(DamageType) != none ||
		class<KFDT_Fire_CaulkBurn>(DamageType) != none ||
		class<KFDT_Microwave>(DamageType) != none ||
		class<KFDT_Fire_Ground>(DamageType) != none ||
		class<KFDT_Freeze_Ground>(DamageType) != none))
	{
		MyKFW = GetOwnerWeapon();
	}

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageGiven(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyDamageGiven(InDamage, DefaultDamage, DamageCauser, MyKFPM, DamageInstigator, DamageType, HitZoneIdx, MyKFW);
	}
	if (InDamage < 0)
		InDamage = 0;
}

function ModifyHardAttackDamage(out int InDamage)
{
	local KFWeapon MyKFW;
	local int DefaultDamage;
	local int i;
	local int index;

	if (InDamage == 0)
		return;

	DefaultDamage = InDamage;
	InDamage *= passiveHardAttackDamage;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHardAttackDamage(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyHardAttackDamage(InDamage, DefaultDamage, OwnerPawn);
	}
	if (InDamage < 0)
		InDamage = 0;
}

function ModifyDamageTaken(out int InDamage, optional class<DamageType> DamageType, optional Controller InstigatedBy)
{
	local KFWeapon MyKFW;
	local KFInventoryManager KFIM;
	local int DefaultDamage;
	local int i;
	local int index;

	if (InDamage == 0 || class<WMDT_BringTheHeat>(DamageType) != none)
	{
		InDamage = 0;
		return;
	}

	DefaultDamage = InDamage;

	MyKFW = GetOwnerWeapon();
	if (MyKFW == none && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != none && KFIM.PendingWeapon != none)
		{
			MyKFW = KFWeapon(KFIM.PendingWeapon);
		}
	}

	// Server Custom Balance
	if (DamageType != none)
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
	InDamage = Round(float(DefaultDamage) * passiveDamageTaken);

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bPerkUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDamageTaken(InDamage, DefaultDamage, MyWMPRI.bSkillUpgrade[index], OwnerPawn, DamageType, InstigatedBy, MyKFW);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyDamageTaken(InDamage, DefaultDamage, OwnerPawn, DamageType, InstigatedBy, MyKFW);
	}
	if (InDamage<0)
		InDamage = 1;

}

function ModifyHealth(out int InHealth)
{
	local int DefaultHealth;
	local byte i;
	local byte index;

	// Server Custom Balance
	InHealth = class'ZedternalReborn.Config_Player'.default.Player_Health;
	if (InHealth <= 0)
		InHealth = 100;

	DefaultHealth = InHealth;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealth(InHealth, DefaultHealth, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != -1)
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
	local int DefaultArmor;
	local byte i;
	local byte index;

	// Server Custom Balance
	MaxArmor = class'ZedternalReborn.Config_Player'.default.Player_Armor;
	if (MaxArmor <= 0)
		MaxArmor = 100;

	DefaultArmor = MaxArmor;

	if (MyWMPRI != none && MyWMGRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyArmor(MaxArmor, DefaultArmor, MyWMPRI.bSkillUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != -1)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyArmor(MaxArmor, DefaultArmor);
		}
	}
}

simulated function ModifyMeleeAttackSpeed(out float InDuration, KFWeapon KFW)
{
	local float DefaultDuration;
	local int i;
	local int index;

	DefaultDuration = InDuration;
	InDuration *= passiveMeleeAttackSpeed;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, MyWMPRI.bSkillUpgrade[index], KFW);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyMeleeAttackSpeed(InDuration, DefaultDuration, KFW);
	}
	if (InDuration <= 0)
		InDuration = 0.05;
}

simulated function float GetReloadRateScale(KFWeapon KFW)
{
	local float InReloadRateScale;
	local int i;
	local int index;

	InReloadRateScale = passiveReloadRateScale;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetReloadRateScale(InReloadRateScale, MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetReloadRateScale(InReloadRateScale, KFW, OwnerPawn);
	}

	if (InReloadRateScale <= 0.05)
		return 0.05;
	else
		return InReloadRateScale;
}

function bool ModifyHealAmount(out float HealAmount)
{
	local KFWeapon MyKFW;
	local float DefaultHealAmount;
	local int i;
	local int index;

	DefaultHealAmount = HealAmount;

	// Server Custom Balance
	HealAmount *= class'ZedternalReborn.Config_Player'.default.Player_HealAmountFactor;

	HealAmount *= passiveHealAmount;
	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealAmount(HealAmount, DefaultHealAmount, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyHealAmount(HealAmount, DefaultHealAmount);
	}
	return IsHealingSurgeActive();
}

simulated function ModifyHealerRechargeTime(out float RechargeRate)
{
	local float DefaultRechargeRate;
	local byte i;
	local byte index;

	DefaultRechargeRate = RechargeRate;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyHealerRechargeTime(RechargeRate, DefaultRechargeRate);
	}
}

simulated function ModifySpeed(out float Speed)
{
	local float DefaultSpeed;
	local byte i;
	local byte index;

	DefaultSpeed = Speed;
	Speed *= passiveMovementSpeed;

	if (MyPRI != none && OwnerPawn != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpeed(Speed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index], OwnerPawn);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1 && OwnerPawn != none)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySpeed(Speed, DefaultSpeed, OwnerPawn);
	}
}

simulated function ModifyRecoil(out float CurrentRecoilModifier, KFWeapon KFW)
{
	local float DefaultRecoilModifier;
	local int i;
	local int index;

	DefaultRecoilModifier = CurrentRecoilModifier;
	CurrentRecoilModifier *= passiveRecoil;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, MyWMPRI.bSkillUpgrade[index], KFW);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyRecoil(CurrentRecoilModifier, DefaultRecoilModifier, KFW);
	}

	if (CurrentRecoilModifier < DefaultRecoilModifier*0.08)
		CurrentRecoilModifier = DefaultRecoilModifier*0.08;
}

simulated function ModifyWeaponBopDamping(out float BobDamping, KFWeapon PawnWeapon)
{
	local float InBobDamping, DefaultBobDamping;
	local int i;
	local int index;

	DefaultBobDamping = BobDamping;
	InBobDamping = DefaultBobDamping * passiveBobDamp;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bPerkUpgrade[index], PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, PawnWeapon))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.GetWeaponUpgrade(index), PawnWeapon);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, MyWMPRI.bSkillUpgrade[index], PawnWeapon);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyWeaponBopDamping(InBobDamping, DefaultBobDamping, PawnWeapon);
	}

	BobDamping = InBobDamping;
}

simulated function ModifyMagSizeAndNumber(KFWeapon KFW, out int MagazineCapacity, optional array< Class<KFPerk> > WeaponPerkClass, optional bool bSecondary=false, optional name WeaponClassname)
{
	local int DefaultMagazineCapacity;
	local int MagCapacity;
	local int i;
	local int index;

	MagCapacity = MagazineCapacity;
	DefaultMagazineCapacity = MagCapacity;

	if (MyWMPRI != none && KFWeap_Healer_Syringe(KFW) == none)
	{
		MagCapacity = Round(float(MagCapacity) * passiveMagazineCapacity);

		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bPerkUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.GetWeaponUpgrade(index), KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, MyWMPRI.bSkillUpgrade[index], KFW, WeaponPerkClass, bSecondary, WeaponClassname);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1 && KFWeap_Healer_Syringe(KFW) == none)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyMagSizeAndNumber(MagCapacity, DefaultMagazineCapacity, KFW, WeaponPerkClass, bSecondary, WeaponClassname);
	}

	if (KFWeap_Bow_Crossbow(KFW) == none || KFWeap_Bow_CompoundBow(KFW) == none) // crossbow and bow does not work well with more than 1 ammo per clip
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

simulated function ModifySpareAmmoAmount(KFWeapon KFW, out int PrimarySpareAmmo, optional const out STraderItem TraderItem, optional bool bSecondary=false)
{
	local int DefaultSpareAmmo;
	local int i;
	local int index;

	if (KFW != none && PrimarySpareAmmo>0)
	{
		DefaultSpareAmmo = PrimarySpareAmmo;
		PrimarySpareAmmo = Round(float(PrimarySpareAmmo) * passiveSpareAmmo);
		if (MyWMPRI != none)
		{
			for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_perkUpgrade[i];
				MyWMGRI.perkUpgrades[index].static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bPerkUpgrade[index], KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_weaponUpgrade[i];
				if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
					MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.GetWeaponUpgrade(index), KFW, TraderItem, bSecondary);
			}
			for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_skillUpgrade[i];
				MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, MyWMPRI.bSkillUpgrade[index], KFW, TraderItem, bSecondary);
			}
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != -1)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySpareAmmoAmount(PrimarySpareAmmo, DefaultSpareAmmo, KFW, TraderItem, bSecondary);
		}

		if (!bSecondary)
			PrimarySpareAmmo = Clamp(PrimarySpareAmmo, 0, MaxInt); //Prevent integer overflow
		else
			PrimarySpareAmmo = Clamp(PrimarySpareAmmo, 0, 255); //Prevent byte overflow
	}
}

simulated function ModifyMaxSpareAmmoAmount(KFWeapon KFW, out int MaxSpareAmmo, optional const out STraderItem TraderItem, optional bool bSecondary=false)
{
	ModifySpareAmmoAmount(KFW, MaxSpareAmmo, TraderItem, bSecondary);
}

simulated function ModifyMaxSpareGrenadeAmount()
{
	local int SpareGrenade;
	local int DefaultSpareGrenade;
	local byte i;
	local byte index;

	DefaultSpareGrenade = default.MaxGrenadeCount;
	SpareGrenade = DefaultSpareGrenade;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != -1)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySpareGrenadeAmount(SpareGrenade, DefaultSpareGrenade);
		}

		MaxGrenadeCount = SpareGrenade;
	}
}

simulated function ModifyWeldingRate(out float FastenRate, out float UnfastenRate)
{
	local float DefaultFastenRate, DefaultUnfastenRate;
	local byte i;
	local byte index;

	DefaultFastenRate = FastenRate;
	DefaultUnfastenRate = UnfastenRate;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyWeldingRate(FastenRate, DefaultFastenRate, UnfastenRate, DefaultUnfastenRate);
	}
}

function float GetZedTimeExtensionMax(byte Level)
{
	local float DefaultExtension;
	local float Extension;
	local byte i;
	local byte index;

	if (MyWMPRI != none && MyWMGRI != none)
	{
		DefaultExtension = 1.0f;
		Extension = 1.0f;

		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetZedTimeExtension(Extension, DefaultExtension, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetZedTimeExtension(Extension, DefaultExtension);
	}

	return Extension;
}

function ApplyWeightLimits()
{
	local KFInventoryManager KFIM;
	local int DefaultWeightLimit;
	local int InWeightLimit;
	local byte i;
	local byte index;

	if (OwnerPawn != none)
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);

		if (KFIM != none)
		{
			// Server Custom Balance
			InWeightLimit = class'ZedternalReborn.Config_Player'.default.Player_Weight;
			if (InWeightLimit == 0)
				InWeightLimit = KFIM.default.MaxCarryBlocks;

			DefaultWeightLimit = InWeightLimit;

			if (MyWMPRI != none && MyWMGRI != none)
			{
				for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
				{
					index = MyWMPRI.purchase_perkUpgrade[i];
					MyWMGRI.perkUpgrades[index].static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bPerkUpgrade[index]);
				}
				for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
				{
					index = MyWMPRI.purchase_skillUpgrade[i];
					MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ApplyWeightLimits(InWeightLimit, DefaultWeightLimit, MyWMPRI.bSkillUpgrade[index]);
				}
				for (i = 0; i <= 1; ++i)
				{
					if (MyWMGRI.SpecialWaveID[i] != -1)
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
	local float DefaultDoTScaler;
	local byte i;
	local byte index;

	DefaultDoTScaler = DoTScaler;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bPerkUpgrade[index], KFDT, bNapalmInfected);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, MyWMPRI.bSkillUpgrade[index], KFDT, bNapalmInfected);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyDoTScaler(DotScaler, DefaultDoTScaler, KFDT, bNapalmInfected);
	}
}

simulated function ModifyRateOfFire(out float InRate, KFWeapon KFW)
{
	local float DefaultRate;
	local int i;
	local int index;

	DefaultRate = InRate;
	if (KFWeap_FlameBase(KFW) == none)
		InRate *= passiveRateOfFire;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyRateOfFire(InRate, DefaultRate, MyWMPRI.bSkillUpgrade[index], KFW);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyRateOfFire(InRate, DefaultRate, KFW);
	}
	if (InRate <= 0.005)
		InRate = 0.005;
}

simulated function float GetTightChokeModifier()
{
	local float InTight, DefaultTight;
	local int i;
	local int index;
	local KFWeapon KFW;
	local KFInventoryManager KFIM;

	if (WMTimers.TightChokeModifierFlag)
	{
		return WMTimers.SavedTightChokeModifierValue;
	}

	KFW = GetOwnerWeapon();
	if (KFW == none && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != none && KFIM.PendingWeapon != none)
			KFW = KFWeapon(KFIM.PendingWeapon);
	}

	DefaultTight = 1.0f;
	InTight = DefaultTight * passiveTightChoke;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyTightChoke(InTight, DefaultTight, MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyTightChoke(InTight, DefaultTight, KFW, OwnerPawn);
	}
	if (InTight <= 0.005)
		InTight = 0.005;

	WMTimers.SavedTightChokeModifierValue = InTight;
	WMTimers.SetTightChokeModifierTimer();

	return InTight;
}

simulated function float GetPenetrationModifier(byte Level, class<KFDamageType> DamageType, optional bool bForce)
{
	local KFWeapon MyKFW;
	local float DefaultPenetration;
	local float InPenetration;
	local int i;
	local int index;

	if (WMTimers.PenetrationModifierFlag)
	{
		return WMTimers.SavedPenetrationModifierValue;
	}

	InPenetration = 1.0f;
	DefaultPenetration = InPenetration;
	InPenetration *= passivePenetration;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bPerkUpgrade[index], DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.GetWeaponUpgrade(index), DamageType, OwnerPawn, bForce);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyPenetration(InPenetration, DefaultPenetration, MyWMPRI.bSkillUpgrade[index], DamageType, OwnerPawn, bForce);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyPenetration(InPenetration, DefaultPenetration, DamageType, OwnerPawn, bForce);
	}

	WMTimers.SavedPenetrationModifierValue = InPenetration;
	WMTimers.SetPenetrationModifierTimer();

	return InPenetration;
}

function float GetStunPowerModifier(optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	local KFWeapon MyKFW;
	local float DefaultStunPower;
	local float InStunPower;
	local int i;
	local int index;

	if (WMTimers.StunPowerModifierFlag)
	{
		return WMTimers.SavedStunPowerModifierValue;
	}

	InStunPower = 1.0f;
	DefaultStunPower = InStunPower;
	InStunPower *= passiveStunPower;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bPerkUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.GetWeaponUpgrade(index), DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStunPower(InStunPower, DefaultStunPower, MyWMPRI.bSkillUpgrade[index], DamageType, HitZoneIdx);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyStunPower(InStunPower, DefaultStunPower, DamageType, HitZoneIdx);
	}

	WMTimers.SavedStunPowerModifierValue = InStunPower;
	WMTimers.SetStunPowerModifierTimer();

	return InStunPower;
}

function float GetStumblePowerModifier(optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart)
{
	local KFWeapon MyKFW;
	local float DefaultStumblePower;
	local float InStumblePower;
	local int i;
	local int index;

	if (WMTimers.StumblePowerModifierFlag)
	{
		return WMTimers.SavedStumblePowerModifierValue;
	}

	InStumblePower = 1.0f;
	DefaultStumblePower = InStumblePower;
	InStumblePower *= passiveStumblePower;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bPerkUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.GetWeaponUpgrade(index), KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyStumblePower(InStumblePower, DefaultStumblePower, MyWMPRI.bSkillUpgrade[index], KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyStumblePower(InStumblePower, DefaultStumblePower, KFP, DamageType, CooldownModifier, BodyPart, OwnerPawn);
	}

	WMTimers.SavedStumblePowerModifierValue = InStumblePower;
	WMTimers.SetStumblePowerModifierTimer();

	return InStumblePower;
}

function float GetKnockdownPowerModifier(optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=false)
{
	local KFWeapon MyKFW;
	local float DefaultKnockdownPower;
	local float InKnockdownPower;
	local int i;
	local int index;

	if (WMTimers.KnockdownPowerModifierFlag)
	{
		return WMTimers.SavedKnockdownPowerModifierValue;
	}

	InKnockdownPower = 1.0f;
	DefaultKnockdownPower = InKnockdownPower;
	InKnockdownPower *= passiveKnockdownPower;

	MyKFW = GetOwnerWeapon();

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bPerkUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, MyKFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.GetWeaponUpgrade(index), OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, MyWMPRI.bSkillUpgrade[index], OwnerPawn, DamageType, BodyPart, bIsSprinting);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyKnockdownPower(InKnockdownPower, DefaultKnockdownPower, OwnerPawn, DamageType, BodyPart, bIsSprinting);
	}

	WMTimers.SavedKnockdownPowerModifierValue = InKnockdownPower;
	WMTimers.SetKnockdownPowerModifierTimer();

	return InKnockdownPower;
}

simulated function float GetSnareSpeedModifier()
{
	return 0.65f;
}

simulated function float GetSnarePowerModifier(optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	local float DefaultSnarePower;
	local float InSnarePower;
	local byte i;
	local byte index;

	if (WMTimers.SnarePowerModifierFlag)
	{
		return WMTimers.SavedSnarePowerModifierValue;
	}

	InSnarePower = 1.0f;
	DefaultSnarePower = InSnarePower;
	InSnarePower *= passiveSnarePower;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bPerkUpgrade[index], DamageType, HitZoneIdx);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifySnarePower(InSnarePower, DefaultSnarePower, MyWMPRI.bSkillUpgrade[index], DamageType, HitZoneIdx);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifySnarePower(InSnarePower, DefaultSnarePower, DamageType, HitZoneIdx);
	}

	WMTimers.SavedSnarePowerModifierValue = FMax(0.f, InSnarePower - 1.0f);
	WMTimers.SetSnarePowerModifierTimer();

	return FMax(0.f, InSnarePower - 1.0f);
}

simulated function ModifyWeaponSwitchTime(out float ModifiedSwitchTime)
{
	local float DefaultSwitchTime;
	local int i;
	local int index;
	local KFWeapon KFW;
	local KFInventoryManager KFIM;

	KFW = GetOwnerWeapon();
	if (KFW == none && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != none && KFIM.PendingWeapon != none)
			KFW = KFWeapon(KFIM.PendingWeapon);
	}

	DefaultSwitchTime = ModifiedSwitchTime;
	ModifiedSwitchTime *= passiveSwitchSpeed;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bPerkUpgrade[index], KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.GetWeaponUpgrade(index), KFW);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, MyWMPRI.bSkillUpgrade[index], KFW);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyWeaponSwitchTime(ModifiedSwitchTime, DefaultSwitchTime, KFW);
	}
}

function AddVampireHealth(KFPlayerController KFPC, class<DamageType> DT)
{
	local int DefaultHealth;
	local int InHealth;
	local byte i;
	local byte index;

	InHealth = 0;
	DefaultHealth = InHealth;

	if (KFPC.Pawn != none)
	{
		// Server Custom Balance
		if (DT != none)
		{
			for (i = 0; i < class'ZedternalReborn.Config_Player'.default.Player_VampireEffect.length; ++i)
			{
				if (ClassIsChildOf(DT ,class'ZedternalReborn.Config_Player'.default.Player_VampireEffect[i].DamageType))
					InHealth += class'ZedternalReborn.Config_Player'.default.Player_VampireEffect[i].HealAmount;
			}
		}
		InHealth = Max(0, InHealth);
		DefaultHealth = InHealth;

		if (MyWMPRI != none)
		{
			for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_perkUpgrade[i];
				MyWMGRI.perkUpgrades[index].static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bPerkUpgrade[index], KFPC, DT);
			}
			for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_skillUpgrade[i];
				MyWMGRI.skillUpgrades[index].SkillUpgrade.static.AddVampireHealth(InHealth, DefaultHealth, MyWMPRI.bSkillUpgrade[index], KFPC, DT);
			}
		}
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != -1)
				MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.AddVampireHealth(InHealth, DefaultHealth, KFPC, DT);
		}
		KFPC.Pawn.HealDamage(InHealth, KFPC, class'KFDT_Healing', false, false);
	}
}

function bool CanSpreadNapalm()
{
	local byte i;
	local byte index;
	local bool bCanSpreadNapalm;

	bCanSpreadNapalm = false;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.perkUpgrades[index].static.CanSpreadNapalm(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bCanSpreadNapalm = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanSpreadNapalm(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bCanSpreadNapalm)
				return true;
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
		{
			bCanSpreadNapalm = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.CanSpreadNapalm(OwnerPawn);
			if (bCanSpreadNapalm)
				return true;
		}
	}
	return false;
}

simulated function bool CanKnockDownOnBump(KFPawn_Monster KFPM)
{
	local byte i;
	local byte index;
	local bool bCanKnockDown;

	bCanKnockDown = false;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bCanKnockDown = MyWMGRI.perkUpgrades[index].static.ShouldKnockDownOnBump(MyWMPRI.bPerkUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bCanKnockDown = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldKnockDownOnBump(MyWMPRI.bSkillUpgrade[index], KFPM, OwnerPawn);
			if (bCanKnockDown)
				return true;
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
		{
			bCanKnockDown = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ShouldKnockDownOnBump(KFPM, OwnerPawn);
			if (bCanKnockDown)
				return true;
		}
	}
	return false;
}

simulated function bool ShouldNeverDud()
{
	local byte i;
	local byte index;
	local bool bCouldExplode;
	local KFWeapon KFW;
	local KFInventoryManager KFIM;

	KFW = GetOwnerWeapon();
	if (KFW == none && CheckOwnerPawn())
	{
		KFIM = KFInventoryManager(OwnerPawn.InvManager);
		if (KFIM != none && KFIM.PendingWeapon != none)
			KFW = KFWeapon(KFIM.PendingWeapon);
	}

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bCouldExplode = MyWMGRI.perkUpgrades[index].static.ShouldNeverDud(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bCouldExplode = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldNeverDud(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
			if (bCouldExplode)
				return true;
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
		{
			bCouldExplode = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ShouldNeverDud(KFW, OwnerPawn);
			if (bCouldExplode)
				return true;
		}
	}
	return false;
}

function bool CouldBeZedShrapnel(class<KFDamageType> KFDT)
{
	local byte i;
	local byte index;
	local bool bCouldExplode;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bCouldExplode = MyWMGRI.perkUpgrades[index].static.CouldBeZedShrapnel(MyWMPRI.bPerkUpgrade[index], KFDT);
			if (bCouldExplode)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bCouldExplode = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CouldBeZedShrapnel(MyWMPRI.bSkillUpgrade[index], KFDT);
			if (bCouldExplode)
				return true;
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
		{
			bCouldExplode = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.CouldBeZedShrapnel(KFDT);
			if (bCouldExplode)
				return true;
		}
	}
	return false;
}

function GameExplosion GetExplosionTemplate()
{
	return default.ShrapnelExplosionTemplate;
}

simulated function bool ShouldShrapnel()
{
	local byte i;
	local byte index;
	local bool bShouldExplode;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bShouldExplode = MyWMGRI.perkUpgrades[index].static.ShouldShrapnel(MyWMPRI.bPerkUpgrade[index]);
			if (bShouldExplode)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bShouldExplode = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldShrapnel(MyWMPRI.bSkillUpgrade[index]);
			if (bShouldExplode)
				return true;
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
		{
			bShouldExplode = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ShouldShrapnel();
			if (bShouldExplode)
				return true;
		}
	}
	return false;
}

simulated function bool IsRangeActive()
{
	local byte i;
	local byte index;
	local bool bRangeActive;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bRangeActive = MyWMGRI.perkUpgrades[index].static.IsRangeActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyPRI.bExtraFireRange = true;
				return true;
			}
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bRangeActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsRangeActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bRangeActive)
			{
				MyPRI.bExtraFireRange = true;
				return true;
			}
		}
	}

	return false;
}

simulated function bool IsGroundFireActive()
{
	local byte i;
	local byte index;
	local bool bSplashActive;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bSplashActive = MyWMGRI.perkUpgrades[index].static.IsGroundFireActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyPRI.bSplashActive = true;
				return true;
			}
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bSplashActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsGroundFireActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bSplashActive)
			{
				MyPRI.bSplashActive = true;
				return true;
			}
		}
	}

	return false;
}

simulated function bool GetUsingTactialReload(KFWeapon KFW)
{
	local byte i;
	local byte index;
	local bool bTacticalReload;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bTacticalReload = MyWMGRI.perkUpgrades[index].static.GetUsingTactialReload(MyWMPRI.bPerkUpgrade[index], KFW);
			if (bTacticalReload)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bTacticalReload = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetUsingTactialReload(MyWMPRI.bSkillUpgrade[index], KFW);
			if (bTacticalReload)
				return true;
		}
	}

	return false;
}

simulated function InitiateWeapon(KFWeapon KFW)
{
	local int i;
	local int index;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.InitiateWeapon(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.InitiateWeapon(MyWMPRI.GetWeaponUpgrade(index), KFW, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.InitiateWeapon(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.InitiateWeapon(KFW, OwnerPawn);
	}

	ModifyMaxSpareGrenadeAmount();
}

simulated function float GetSelfHealingSurgePct()
{
	local byte i;
	local byte index;
	local float InHealingPct;

	InHealingPct = 0.000000;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetSelfHealingSurgePct(InHealingPct, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetSelfHealingSurgePct(InHealingPct);
	}

	return InHealingPct;
}
simulated function bool IsHealingSurgeActive(){ return true; }

simulated event float GetIronSightSpeedModifier(KFWeapon KFW)
{
	local int i;
	local int index;
	local float InSpeed, DefaultSpeed;

	DefaultSpeed = 1.000000;
	InSpeed = DefaultSpeed;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetIronSightSpeedModifier(InSpeed, DefaultSpeed);
	}

	return InSpeed;
}

simulated event float GetCrouchSpeedModifier(KFWeapon KFW)
{
	local int i;
	local int index;
	local float InSpeed, DefaultSpeed;

	DefaultSpeed = 1.000000;
	InSpeed = DefaultSpeed;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_weaponUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_weaponUpgrade[i];
			if (isValidWeapon(MyWMGRI.weaponUpgradeList[index].KFWeapon, KFW))
				MyWMGRI.weaponUpgradeList[index].KFWeaponUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.GetWeaponUpgrade(index));
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetCrouchSpeedModifier(InSpeed, DefaultSpeed);
	}

	return InSpeed;
}

function simulated SetSuccessfullParry()
{
	local byte i;
	local byte index;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.SuccessfullParry(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.SuccessfullParry(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.SuccessfullParry(OwnerPawn);
	}
}

function bool CanNotBeGrabbed()
{
	local byte i;
	local byte index;
	local bool bNoGrab;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bNoGrab = MyWMGRI.perkUpgrades[index].static.CanNotBeGrabbed(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bNoGrab)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bNoGrab = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanNotBeGrabbed(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bNoGrab)
				return true;
		}
	}
	return false;
}

simulated function bool ShouldRandSirenResist()
{
	local byte i;
	local byte index;
	local bool bResist;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bResist = MyWMGRI.perkUpgrades[index].static.ProjSirenResist(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bResist)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bResist = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ProjSirenResist(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bResist)
				return true;
		}
	}

	return false;
}

simulated function bool GetIsUberAmmoActive(KFWeapon KFW)
{
	local byte i;
	local byte index;
	local bool bUber;

	MyWMPRI = WMPlayerReplicationInfo(MyPRI);
	MyWMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bUber = MyWMGRI.perkUpgrades[index].static.GetIsUberAmmoActive(MyWMPRI.bPerkUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bUber = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetIsUberAmmoActive(MyWMPRI.bSkillUpgrade[index], KFW, OwnerPawn);
			if (bUber)
				return true;
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
		{
			bUber = MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetIsUberAmmoActive(KFW, OwnerPawn);
			if (bUber)
				return true;
		}
	}
	return false;
}

function HealingDamage(int HealAmount, KFPawn KFP, class<DamageType> DamageType)
{
	local byte i;
	local byte index;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.HealingDamage(MyWMPRI.bPerkUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.HealingDamage(MyWMPRI.bSkillUpgrade[index], HealAmount, KFP, OwnerPawn, DamageType);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.HealingDamage(HealAmount, KFP, OwnerPawn, DamageType);
	}
}

simulated function float GetZedTimeModifier(KFWeapon W)
{
	local byte i;
	local byte index;
	local float InModifier;

	InModifier = 0.f;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetZedTimeModifier(InModifier, MyWMPRI.bPerkUpgrade[index], W);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetZedTimeModifier(InModifier, MyWMPRI.bSkillUpgrade[index], W);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.GetZedTimeModifier(InModifier, W);
	}

	return InModifier;
}

simulated function bool CanSeeEnemyHealth()
{
	local byte i;
	local byte index;
	local bool bCanSee;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bCanSee = MyWMGRI.perkUpgrades[index].static.CanSeeEnemyHealth(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCanSee)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bCanSee = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanSeeEnemyHealth(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bCanSee)
				return true;
		}
	}

	return false;
}

simulated function bool IsCallOutActive()
{
	local byte i;
	local byte index;
	local bool bCallOut;

	if (MyWMPRI != none)
	{
		bCanSeeCloakedZeds=false;

		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bCallOut = MyWMGRI.perkUpgrades[index].static.IsCallOutActive(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
			if (bCallOut)
				bCanSeeCloakedZeds=true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bCallOut = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsCallOutActive(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
			if (bCallOut)
				bCanSeeCloakedZeds=true;
		}
	}

	return bCanSeeCloakedZeds;
}

simulated function float GetCloakDetectionRange()
{
	local float DefaultRange;
	local float InRange;
	local byte i;
	local byte index;

	InRange = 2000.f;
	DefaultRange = InRange;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ModifyCloakDetectionRange(InRange, DefaultRange, MyWMPRI.bSkillUpgrade[index]);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ModifyCloakDetectionRange(InRange, DefaultRange);
	}

	return InRange;
}

simulated function ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch)
{
	local byte i;
	local byte index;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.ReceiveLocalizedMessage(MyWMPRI.bPerkUpgrade[index], Message, OwnerPawn, Switch);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ReceiveLocalizedMessage(MyWMPRI.bSkillUpgrade[index], Message, OwnerPawn, Switch);
		}
	}
	for (i = 0; i <= 1; ++i)
	{
		if (MyWMGRI.SpecialWaveID[i] != -1)
			MyWMGRI.specialWaves[MyWMGRI.SpecialWaveID[i]].static.ReceiveLocalizedMessage(Message, OwnerPawn, Switch);
	}

}

simulated function bool ShouldSacrifice()
{
	local byte i;
	local byte index;
	local bool bSacrifice;

	if (!bUsedSacrifice)
	{
		if (MyWMPRI != none)
		{
			for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_perkUpgrade[i];
				bSacrifice = MyWMGRI.perkUpgrades[index].static.ShouldSacrifice(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
				if (bSacrifice)
					return true;
			}
			for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_skillUpgrade[i];
				bSacrifice = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.ShouldSacrifice(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
				if (bSacrifice)
					return true;
			}
		}
	}
	return false;
}

function NotifyPerkSacrificeExploded()
{
	bUsedSacrifice = true;
	if (OwnerPawn != none)
		OwnerPawn.HealDamage(50, OwnerPawn.Controller, class'KFGameContent.KFDT_Healing_MedicGrenade');
}

simulated function bool DoorShouldNuke()
{
	local byte i;
	local byte index;
	local bool bTrap;

	if (!bUsedSacrifice)
	{
		if (MyWMPRI != none)
		{
			for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_perkUpgrade[i];
				bTrap = MyWMGRI.perkUpgrades[index].static.DoorShouldNuke(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
				if (bTrap)
					return true;
			}
			for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_skillUpgrade[i];
				bTrap = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.DoorShouldNuke(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
				if (bTrap)
					return true;
			}
		}
	}
	return false;
}

simulated function bool CanExplosiveWeld()
{
	local byte i;
	local byte index;
	local bool bTrap;

	if (!bUsedSacrifice)
	{
		if (MyWMPRI != none)
		{
			for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_perkUpgrade[i];
				bTrap = MyWMGRI.perkUpgrades[index].static.CanExplosiveWeld(MyWMPRI.bPerkUpgrade[index], OwnerPawn);
				if (bTrap)
					return true;
			}
			for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
			{
				index = MyWMPRI.purchase_skillUpgrade[i];
				bTrap = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.CanExplosiveWeld(MyWMPRI.bSkillUpgrade[index], OwnerPawn);
				if (bTrap)
					return true;
			}
		}
	}
	return false;
}

/**
 * @brief General interaction with another pawn, here: give ammo
 *
 * @param KFPH Pawn to interact with
 */
simulated function Interact(KFPawn_Human KFPH)
{
	local KFWeapon KFW;
	local int Idx, MagCount;
	local KFPlayerController KFPC;
	local KFPlayerReplicationInfo UserPRI, OwnerPRI;
	local bool bCanSupplyAmmo;
	local bool bReceivedAmmo;
	local sSuppliedPawnInfo SuppliedPawnInfo;

	// Do nothing if supplier isn't active
	if (!IsSupplierActive())
	{
		return;
	}

	bCanSupplyAmmo = true;
	Idx = SuppliedPawnList.Find('SuppliedPawn', KFPH);
	if (Idx != INDEX_NONE)
	{
		bCanSupplyAmmo = !SuppliedPawnList[Idx].bSuppliedAmmo;
		if (!bCanSupplyAmmo)
			return;
	}

	if (bCanSupplyAmmo)
	{
		foreach KFPH.InvManager.InventoryActors(class'KFWeapon', KFW)
		{
			if (KFW.static.DenyPerkResupply())
			{
				continue;
			}

			// resupply 1 mag for every 5 initial mags
			MagCount = Max(KFW.InitialSpareMags[0] / 1.5, 1); // 3, 1
			;
			bReceivedAmmo = (KFW.AddAmmo(MagCount * KFW.MagazineCapacity[0]) > 0) ? true : bReceivedAmmo;

			if (KFW.CanRefillSecondaryAmmo())
			{
				// resupply 1 mag for every 5 initial mags
				;

				// If our secondary ammo isn't mag-based (like the Eviscerator), restore a portion of max ammo instead
				bReceivedAmmo = (KFW.AddSecondaryAmmo(Max(KFW.AmmoPickupScale[1] * KFW.MagazineCapacity[1], 1)) > 0) ? true : bReceivedAmmo;
			}
		}
	}

	// Add to array (if necessary) and flag as supplied as needed
	if (bReceivedAmmo)
	{
		if (Idx == INDEX_NONE)
		{
			SuppliedPawnInfo.SuppliedPawn = KFPH;
			SuppliedPawnInfo.bSuppliedAmmo = bReceivedAmmo;
			Idx = SuppliedPawnList.Length;
			SuppliedPawnList.AddItem(SuppliedPawnInfo);
		}
		else
		{
			SuppliedPawnList[Idx].bSuppliedAmmo = SuppliedPawnList[Idx].bSuppliedAmmo || bReceivedAmmo;
		}

		if (Role == ROLE_Authority)
		{
			KFPC = KFPlayerController(KFPH.Controller);
			if (bReceivedAmmo)
			{
				OwnerPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_GaveAmmoTo, KFPC.PlayerReplicationInfo);
				KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_ReceivedAmmoFrom, OwnerPC.PlayerReplicationInfo);
			}

			UserPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
			OwnerPRI = KFPlayerReplicationInfo(OwnerPC.PlayerReplicationInfo);
			if (UserPRI != none && OwnerPRI != none)
			{
				UserPRI.MarkSupplierOwnerUsed(OwnerPRI, SuppliedPawnList[Idx].bSuppliedAmmo, false);
			}
		}
	}
	else if (Role == ROLE_Authority)
	{
		KFPC = KFPlayerController(KFPH.Controller);
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_AmmoIsFull, OwnerPC.PlayerReplicationInfo);
	}
}

/**
 * @brief Can other pawns interact with us?
 *
 * @param MyKFPH the other pawn
 * @return true/false
 */
simulated function bool CanInteract(KFPawn_Human MyKFPH)
{
	local int Idx;

	if (IsSupplierActive())
	{
		Idx = SuppliedPawnList.Find('SuppliedPawn', MyKFPH);

		// Pawn hasn't gotten anything from us yet
		if (Idx == INDEX_NONE)
		{
			return true;
		}

		// Pawn hasn't gotten ammo
		return !SuppliedPawnList[Idx].bSuppliedAmmo;
	}
}

simulated function bool IsSupplierActive()
{
	local byte i;
	local byte index;
	local bool bActive;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			bActive = MyWMGRI.perkUpgrades[index].static.IsSupplierActive(MyWMPRI.bPerkUpgrade[index]);
			if (bActive)
				return true;
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			bActive = MyWMGRI.skillUpgrades[index].SkillUpgrade.static.IsSupplierActive(MyWMPRI.bSkillUpgrade[index]);
			if (bActive)
				return true;
		}
	}
	return false;
}

function WaveEnd(KFPlayerController KFPC)
{
	local byte i;
	local byte index;

	if (MyWMGRI != none && MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.WaveEnd(MyWMPRI.bPerkUpgrade[index], KFPC);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.WaveEnd(MyWMPRI.bskillUpgrade[index], KFPC);
		}
	}
}

simulated function DrawSpecialPerkHUD(Canvas C)
{
	local KFPawn_Monster KFPM;
	local vector ViewLocation, ViewDir;
	local int i;
	local int index;
	local float DetectionRangeSq, ThisDot;
	local float HealthBarLength, HealthbarHeight;

	if (OwnerPawn != none)
	{
		DetectionRangeSq = Square(GetCloakDetectionRange());

		if (CanSeeEnemyHealth())
		{
			HealthbarLength = FMin(50.f * (float(C.SizeX) / 1024.f), 50.f);
			HealthbarHeight = FMin(6.f * (float(C.SizeX) / 1024.f), 6.f);

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
				if (ThisDot > 0.f)
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

	// perk and skill sections
	if (MyWMGRI != none && MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.DrawOnHUD(MyWMPRI.bPerkUpgrade[index], C, OwnerPawn);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.DrawOnHUD(MyWMPRI.bSkillUpgrade[index], C, OwnerPawn);
		}

		// special wave
		for (i = 0; i <= 1; ++i)
		{
			if (MyWMGRI.SpecialWaveID[i] != -1)
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
		TargetLocation = KFPM.Location + vect(0,0,-1) * KFPM.GetCollisionHeight() * 1.2 * KFPM.CurrentBodyScale;
	}
	else
	{
		TargetLocation = KFPM.Location + vect(0,0,1) * KFPM.GetCollisionHeight() * 1.2 * KFPM.CurrentBodyScale;
	}

	ScreenPos = C.Project(TargetLocation);
	if (ScreenPos.X < 0 || ScreenPos.X > C.SizeX || ScreenPos.Y < 0 || ScreenPos.Y > C.SizeY)
	{
		return;
	}

	if (class'KFGameEngine'.static.FastTrace_PhysX(TargetLocation, CameraLocation))
	{
		HealthScale = FClamp(float(KFPM.Health) / float(KFPM.HealthMax), 0.f, 1.0f);

		C.EnableStencilTest(true);
		C.SetDrawColor(0, 0, 0, 255);
		C.SetPos(ScreenPos.X - HealthBarLength * 0.5, ScreenPos.Y);
		C.DrawTile(WhiteMaterial, HealthbarLength, HealthbarHeight, 0, 0, 32, 32);

		C.SetDrawColor(237, 8, 0, 255);
		C.SetPos(ScreenPos.X - HealthBarLength * 0.5 + 1.0, ScreenPos.Y + 1.0);
		C.DrawTile(WhiteMaterial, (HealthBarLength - 2.0) * HealthScale, HealthbarHeight - 2.0, 0, 0, 32, 32);
		C.EnableStencilTest(false);
	}
}

// healing darts powerup function
simulated function byte GetHealingDamageBoost()
{
	local byte i;
	local byte index;
	local byte InHealingDamageBoost;

	InHealingDamageBoost = 0;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetHealingDamageBoost(InHealingDamageBoost, MyWMPRI.bSkillUpgrade[index]);
		}
	}

	return InHealingDamageBoost;
}

simulated function byte GetMaxHealingDamageBoost()
{
	local byte i;
	local byte index;
	local byte InMaxHealingDamageBoost;

	InMaxHealingDamageBoost = 0;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetMaxHealingDamageBoost(InMaxHealingDamageBoost, MyWMPRI.bSkillUpgrade[index]);
		}
	}

	return InMaxHealingDamageBoost;
}

simulated function byte GetHealingShield()
{
	local byte i;
	local byte index;
	local byte InHealingShield;

	InHealingShield = 0;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetHealingShield(InHealingShield, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetHealingShield(InHealingShield, MyWMPRI.bSkillUpgrade[index]);
		}
	}

	return InHealingShield;
}

simulated function byte GetMaxHealingShield()
{
	local byte i;
	local byte index;
	local byte InMaxHealingShield;

	InMaxHealingShield = 0;

	if (MyWMPRI != none)
	{
		for (i = 0; i < MyWMPRI.purchase_perkUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_perkUpgrade[i];
			MyWMGRI.perkUpgrades[index].static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bPerkUpgrade[index]);
		}
		for (i = 0; i < MyWMPRI.purchase_skillUpgrade.length; ++i)
		{
			index = MyWMPRI.purchase_skillUpgrade[i];
			MyWMGRI.skillUpgrades[index].SkillUpgrade.static.GetMaxHealingShield(InMaxHealingShield, MyWMPRI.bSkillUpgrade[index]);
		}
	}

	return InMaxHealingShield;
}

defaultproperties
{
	PerkBuildStatID=0
	bCanSeeCloakedZeds=false
	HeatWaveRadiusSQ=90000
	bUsedSacrifice=false
	passiveDamageGiven=1.000000
	passiveDamageTaken=1.000000
	passiveHealAmount=1.000000
	passiveHardAttackDamage=1.000000
	passiveStunPower=1.000000
	passiveStumblePower=1.000000
	passiveKnockdownPower=1.000000
	passiveSnarePower=1.000000
	passiveMovementSpeed=1.000000
	passiveSwitchSpeed=1.000000
	passiveMeleeAttackSpeed=1.000000
	passiveReloadRateScale=1.000000
	passiveRecoil=1.000000
	passiveBobDamp=1.000000
	passiveMagazineCapacity=1.000000
	passiveSpareAmmo=1.000000
	passiveRateOfFire=1.000000
	passiveTightChoke=1.000000
	passivePenetration=1.000000
	WhiteMaterial=Texture2D'EngineResources.WhiteSquareTexture'
	ShrapnelExplosionTemplate=KFGameExplosion'KFGame.Default__KFPerk_Survivalist:ExploTemplate0'
	NukeExplosionTemplate=KFGameExplosion'KFGame.Default__KFPerk_Demolitionist:ExploTemplate1'
	NukeExplosionActorClass=Class'KFGame.KFExplosion_Nuke'
	NukeDamageModifier=1.500000
	NukeRadiusModifier=1.350000
	LingeringNukePoisonDamage=20
	LingeringNukeDamageType=Class'KFGame.KFDT_DemoNuke_Toxic_Lingering'
	PerkIcon=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'
	StartingWeaponClassIndex=-1
	PrimaryWeaponDef=Class'KFGame.KFWeapDef_Random'
	PrimaryWeaponPaths(0)=Class'KFGame.KFWeapDef_AR15'
	PrimaryWeaponPaths(1)=Class'KFGame.KFWeapDef_MB500'
	PrimaryWeaponPaths(2)=Class'KFGame.KFWeapDef_Crovel'
	PrimaryWeaponPaths(3)=Class'KFGame.KFWeapDef_HX25'
	PrimaryWeaponPaths(4)=Class'KFGame.KFWeapDef_MedicPistol'
	PrimaryWeaponPaths(5)=Class'KFGame.KFWeapDef_CaulkBurn'
	PrimaryWeaponPaths(6)=Class'KFGame.KFWeapDef_Remington1858Dual'
	PrimaryWeaponPaths(7)=Class'KFGame.KFWeapDef_Winchester1894'
	PrimaryWeaponPaths(8)=Class'KFGame.KFWeapDef_MP7'
	KnivesWeaponDef(0)=Class'KFGame.KFweapDef_Knife_Berserker'
	KnivesWeaponDef(1)=Class'KFGame.KFWeapDef_Knife_Commando'
	KnivesWeaponDef(2)=Class'KFGame.KFWeapDef_Knife_Demo'
	KnivesWeaponDef(3)=Class'KFGame.KFWeapDef_Knife_Firebug'
	KnivesWeaponDef(4)=Class'KFGame.KFWeapDef_Knife_Gunslinger'
	KnivesWeaponDef(5)=Class'KFGame.KFWeapDef_Knife_Medic'
	KnivesWeaponDef(6)=Class'KFGame.KFWeapDef_Knife_SharpShooter'
	KnivesWeaponDef(7)=Class'KFGame.KFWeapDef_Knife_Support'
	KnivesWeaponDef(8)=Class'KFGame.KFWeapDef_Knife_SWAT'
	KnifeWeaponDef=Class'KFGame.KFWeapDef_Knife_SharpShooter'
	GrenadeWeaponDef=Class'KFGame.KFWeapDef_Grenade_Commando'
}
