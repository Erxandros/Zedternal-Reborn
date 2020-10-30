Class WMUpgrade extends Info;

var array<int> upgradeCost;
var string upgradeName;
var array<string> upgradeDescription;
var array<Texture2D> upgradeIcon;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// These functions are called by ZedternalReborn.WMPerk (server or client) to get perk stats.
// So all function from upgrades bought by the player will be called
//
// To create a custom perk/skill/weapon upgrade, simply create a .uc file, extended to WMUpgrade_Perk, WMUpgrade_Skill or WMUpgrade_Weapon.
// They, take any of these function and play with the output variable as you wish
static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn);
static function WaveEnd(int upgLevel, KFPlayerController KFPC);

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW);
static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW);

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel);
static function ModifyArmor(out byte MaxArmor, byte DefaultArmor, int upgLevel);
static function ModifyHealAmount(out float InHealAmount, float DefaultHealAmount, int upgLevel);
static simulated function ModifyHealerRechargeTime(out float InRechargeTime, float DefaultRechargeTime, int upgLevel);
static function HealingDamage(int upgLevel, int HealAmount, KFPawn HealedPawn, KFPawn InstigatorPawn, class<DamageType> DamageType);
static function AddVampireHealth(out int InHealth, int DefaultHealth, int upgLevel, KFPlayerController KFPC, class<DamageType> DT);

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, int upgLevel, KFPawn OwnerPawn);
static simulated function ModifyWeldingRate(out float InFastenRate, float DefaultFastenRate, out float InUnfastenRate, float DefaultUnfastenRate, int upgLevel);
static function ApplyWeightLimits(out int InWeightLimit, int DefaultWeightLimit, int upgLevel);
static simulated function GetZedTimeExtension(out float InExtension, float DefaultExtension, int upgLevel);
static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, int upgLevel, KFWeapon KFW);
static simulated function GetZedTimeModifier(out float InModifier, int upgLevel, KFWeapon KFW);

static function ModifyHardAttackDamage(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn);
static simulated function ModifyMeleeAttackSpeed(out float InDuration, float DefaultDuration, int upgLevel, KFWeapon KFW);

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn);
static simulated function ModifyRecoil(out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW);
static simulated function ModifyWeaponBopDamping(out float InBobDamping, float DefaultBobDamping, int upgLevel, KFWeapon KFW);
static simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< Class<KFPerk> > WeaponPerkClass, optional bool bSecondary=False, optional name WeaponClassname);
static simulated function ModifySpareAmmoAmount(out int InSpareAmmo, int DefaultSpareAmmo, int upgLevel, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=False);
static simulated function ModifySpareGrenadeAmount(out int SpareGrenade, int DefaultSpareGrenade, int upgLevel);
static function ModifyDoTScaler(out float InDoTScaler, float DefaultDotScaler, int upgLevel, optional class<KFDamageType> KFDT, optional bool bNapalmInfected);
static simulated function ModifyRateOfFire(out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW);
static simulated function ModifyTightChoke(out float InTight, float DefaultTight, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn);
static simulated function ModifyPenetration(out float InPenetration, float DefaultPenetration, int upgLevel, class<KFDamageType> DamageType, KFPawn OwnerPawn, optional bool bForce);

static function ModifyStunPower(out float InStunPower, float DefaultStunPower, int upgLevel, optional class<DamageType> DamageType, optional byte HitZoneIdx);
static function ModifyStumblePower(out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn);
static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False);
static function ModifySnarePower(out float InSnarePower, float DefaultSnarePower, int upgLevel, optional class<DamageType> DamageType, optional byte BodyPart);

static simulated function GetSelfHealingSurgePct(out float InHealingPct, int upgLevel);
static simulated function GetIronSightSpeedModifier(out float InSpeed, float DefaultSpeed, int upgLevel);
static simulated function GetCrouchSpeedModifier(out float InSpeed, float DefaultSpeed, int upgLevel);
static simulated function ModifyCloakDetectionRange(out float InRange, float DefaultRange, int upgLevel);
static simulated function SuccessfullParry(int upgLevel, KFPawn OwnerPawn);
static simulated function ReceiveLocalizedMessage(int upgLevel, class<LocalMessage> Message, KFPawn OwnerPawn, optional int MessageIndex);
static simulated function DrawOnHUD(int upgLevel, canvas C, KFPawn OwnerPawn);

static simulated function GetHealingDamageBoost(out byte InHealingDamageBoost, int upgLevel);
static simulated function GetMaxHealingDamageBoost(out byte InMaxHealingDamageBoost, int upgLevel);
static simulated function GetHealingShield(out byte InHealingShield, int upgLevel);
static simulated function GetMaxHealingShield(out byte InMaxHealingShield, int upgLevel);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Boolean functions
static simulated function bool CanSpreadNapalm(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool ShouldKnockDownOnBump(int upgLevel, KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool ShouldNeverDud(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	return False;
}

static function bool CouldBeZedShrapnel(int upgLevel, class<KFDamageType> KFDT)
{
	return False;
}

static function bool ShouldShrapnel(int upgLevel)
{
	return False;
}

static simulated function bool IsRangeActive(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool IsGroundFireActive(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool GetUsingTactialReload(int upgLevel, KFWeapon KFW)
{
	return False;
}

static function bool CanNotBeGrabbed(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool ProjSirenResist(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool GetIsUberAmmoActive(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool CanSeeEnemyHealth(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool IsCallOutActive(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool ShouldSacrifice(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool DoorShouldNuke(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool CanExplosiveWeld(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool IsSupplierActive(int upgLevel)
{
	return False;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Optimized function (they are called only one time)
// Only use these functions for passive and permanent bonuses (ex : damage bonus with any weapon)
// If you are not sure about this, use regular functions
static function ModifyDamageGivenPassive(out float damageFactor, int upgLevel);
static function ModifyDamageTakenPassive(out float damageFactor, int upgLevel);
static function ModifyHealAmountPassive(out float healAmountFactor, int upgLevel);
static simulated function ModifySpeedPassive(out float speedFactor, int upgLevel);
static simulated function ModifyWeaponSwitchTimePassive(out float switchTimeFactor, int upgLevel);
static function ModifyHardAttackDamagePassive(out float damageFactor, int upgLevel);
static simulated function ModifyMeleeAttackSpeedPassive(out float durationFactor, int upgLevel);
static simulated function GetReloadRateScalePassive(out float reloadRateFactor, int upgLevel);
static simulated function ModifyRecoilPassive(out float recoilFactor, int upgLevel);
static simulated function ModifyWeaponBopDampingPassive(out float bobDampFactor, int upgLevel);
static simulated function ModifyMagSizeAndNumberPassive(out float magazineCapacityFactor, int upgLevel);
static simulated function ModifySpareAmmoAmountPassive(out float spareAmmoFactor, int upgLevel);
static simulated function ModifyRateOfFirePassive(out float rateOfFireFactor, int upgLevel);
static simulated function ModifyTightChokePassive(out float tightChokeFactor, int upgLevel);
static simulated function ModifyPenetrationPassive(out float penetrationFactor, int upgLevel);
static function ModifyStunPowerPassive(out float stunPowerFactor, int upgLevel);
static function ModifyStumblePowerPassive(out float stumblePowerFactor, int upgLevel);
static function ModifyKnockdownPowerPassive(out float knockdownPowerFactor, int upgLevel);
static function ModifySnarePowerPassive(out float snarePowerFactor, int upgLevel);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Other stuff like tools
static simulated function Texture2D GetupgradeIcon(int index)
{
	if (index < 0)
		return default.upgradeIcon[0];
	else if (index < default.upgradeIcon.length)
		return default.upgradeIcon[index];
	else
		return default.upgradeIcon[default.upgradeIcon.length - 1];
}

static simulated function bool IsWeaponOnSpecificPerk(KFWeapon W, class<KFPerk> Perk)
{
	if (W != None)
	{
		return W.static.GetWeaponPerkClass(Perk) == Perk;
	}

	return False;
}

static function bool IsDamageTypeOnSpecificPerk(class<KFDamageType> KFDT, class<KFPerk> Perk)
{
	if (KFDT != None)
	{
		return KFDT.default.ModifierPerkList.Find(Perk) > INDEX_NONE;
	}

	return False;
}

static function bool IsMeleeDamageType(class<DamageType> DT)
{
	return DT != None && (class<KFDT_Bludgeon>(DT) != None || class<KFDT_Slashing>(DT) != None || class<KFDT_Piercing>(DT) != None) &&
		class<KFDT_Piercing_Crossbow>(DT) == None &&
		class<KFDT_Piercing_NadeFragment>(DT) == None &&
		class<KFDT_Piercing_NailFragment>(DT) == None &&
		class<KFDT_Slashing_EvisceratorProj>(DT) == None;
}

defaultproperties
{
	upgradeIcon(0)=Texture2D'CHR_Cosmetics_Item_TEX.3DGlasses.3DGlasses_Color02'

	Name="Default__WMUpgrade"
}
