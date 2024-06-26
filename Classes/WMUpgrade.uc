Class WMUpgrade extends Object;

var string UpgradeName;
var array<string> UpgradeDescription;
var array<Texture2D> UpgradeIcon;

//Set this variable to True in the default properties of your upgrade to read the UpgradeName as the localization key and not as raw text.
var bool bShouldLocalize;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// These functions are called by ZedternalReborn.WMPerk (server or client) to get perk stats.
// So all function from upgrades bought by the player will be called
//
// To create a custom perk/skill/weapon/equipment upgrade, simply create a .uc file, and extended from WMUpgrade_Perk, WMUpgrade_Skill, WMUpgrade_Weapon or WMUpgrade_Equipment.
// Then take any of these functions and play with the output variable as you wish.
static simulated function InitiateWeapon(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn);
static function WaveEnd(int upgLevel, KFPlayerController KFPC);

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW);
static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW);

static function ModifyHealth(out int InHealth, int DefaultHealth, int upgLevel);
static function ModifyArmor(out int MaxArmor, int DefaultArmor, int upgLevel);
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
static simulated function ModifySpread(out float InSpreadModifier, float DefaultSpreadModifier, int upgLevel, KFWeapon KFW);
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

static simulated function GetPerkLensEffect(out class<EmitterCameraLensEffectBase> CamEffect, class<KFDamageType> DmgType, int upgLevel);

//InRechargeRateFL for flash light drain rate, InRechargeRateNVG for night vision goggles drain rate
static simulated function GetBatteryRateScale(out float InRechargeRateFL, out float InRechargeRateNVG, int upgLevel, KFPawn OwnerPawn);

static simulated function SupplierModifiers(int upgLevel, out float PrimaryAmmoPercentage, out float SecondaryAmmoPercentage, out float ArmorPercentage, out int GrenadeAmount);

//For sentinel, could be used for other turret based weapons
static simulated function ModifyMaxDeployed(out int InMaxDeployed, int DefaultMaxDeployed, int upgLevel, KFWeapon KFW);

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

static simulated function bool HasNightVision(int upgLevel)
{
	return False;
}

static simulated function bool IsUnAffectedByZedTime(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

static simulated function bool ImmuneToCameraShake(int upgLevel, KFPawn OwnerPawn)
{
	return False;
}

//For sentinel, could be used for other turret based weapons
static simulated function bool CanSeeCloaked(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
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
static simulated function ModifySpreadPassive(out float spreadFactor, int upgLevel);
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Universal extension functions (they are used for advance extension mods and addons)
// Only use these functions if none of the above functions will work with your custom logic
// You will need to call the corresponding function in WMPerk for these to function in upgrades

//Boolean function
static simulated function bool ExtensionFuncBoolean(int upgLevel, string Identifier, KFWeapon MyKFW, KFPawn OwnerPawn,
	optional int InputInt, optional float InputFloat, optional name InputClassName,
	optional Object InputObject1, optional Object InputObject2, optional Object InputObject3)
{
	return False;
}

//Integer function
static simulated function ExtensionFuncInteger(out int InValue, int DefaultValue, int upgLevel, string Identifier,
	KFWeapon MyKFW, KFPawn OwnerPawn, optional int InputInt, optional float InputFloat, optional name InputClassName,
	optional Object InputObject1, optional Object InputObject2, optional Object InputObject3);

//Float function
static simulated function ExtensionFuncFloat(out float InValue, float DefaultValue, int upgLevel, string Identifier,
	KFWeapon MyKFW, KFPawn OwnerPawn, optional int InputInt, optional float InputFloat, optional name InputClassName,
	optional Object InputObject1, optional Object InputObject2, optional Object InputObject3);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Other stuff like tools
static simulated function Texture2D GetUpgradeIcon(int index)
{
	if (index < 0)
		return default.UpgradeIcon[0];
	else if (index < default.UpgradeIcon.length)
		return default.UpgradeIcon[index];
	else
		return default.UpgradeIcon[default.UpgradeIcon.length - 1];
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

static function bool IsWeaponSidearmOrKnife(KFWeapon W)
{
	local KFPerk KFP;

	if (W != None)
		KFP = W.GetPerk();

	if (KFP != None)
	{
		return KFP.GetKnifeWeaponClassPath() ~= PathName(W.Class)
		|| KFP.GetSecondaryWeaponClassPath() ~= PathName(W.Class)
		|| (KFWeap_DualBase(W) != None && KFP.GetSecondaryWeaponClassPath() ~= PathName(KFWeap_DualBase(W).default.SingleClass));
	}

	return False;
}

static function bool IsMeleeDamageType(class<DamageType> DT)
{
	return (ClassIsChildOf(DT, class'KFDT_Bludgeon') || ClassIsChildOf(DT, class'KFDT_Slashing') || ClassIsChildOf(DT, class'KFDT_Piercing'))
		&& !IsGrenadeDT(DT) && (class<KFDamageType>(DT) != None && class<KFDamageType>(DT).default.MeleeHitPower > 0);
}

static function bool IsGrenadeDT(class<DamageType> DT)
{
	return class'ZedternalReborn.WMWeaponConstants'.static.IsGrenadeDT(DT);
}

//Use this function over IsGrenadeDT if you can
static function bool IsGrenadeDTAdvance(class<KFDamageType> DT, optional KFPlayerController DamageInstigator, optional class<KFWeaponDefinition> GreandeDef)
{
	if (GreandeDef != None)
		return class'ZedternalReborn.WMWeaponConstants'.static.IsGrenadeDTAdvance(DT, GreandeDef);
	else if (DamageInstigator != None && DamageInstigator.CurrentPerk != None)
		return class'ZedternalReborn.WMWeaponConstants'.static.IsGrenadeDTAdvance(DT, DamageInstigator.CurrentPerk.GrenadeWeaponDef);
	else
		return class'ZedternalReborn.WMWeaponConstants'.static.IsGrenadeDTAdvance(DT);
}

//Used for skills currently when sold using reroll button
static simulated function DeleteHelperClass(Pawn OwnerPawn);

//Used to revert hard changes from a upgrade
static simulated function RevertUpgradeChanges(Pawn OwnerPawn);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Localization functions
static function string GetUpgradeName()
{
	return GetUpgradeLocalization("UpgradeName");
}

static function string GetUpgradeLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(default.UpgradeName, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
	bShouldLocalize=False
	UpgradeIcon(0)=Texture2D'CHR_Cosmetics_Item_TEX.3DGlasses.3DGlasses_Color02'

	Name="Default__WMUpgrade"
}
