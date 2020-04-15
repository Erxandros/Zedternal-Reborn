class WMSpecialWave extends info;

var string Title;
var string Description;

struct SMonster
{
	var int MinWave, MaxWave;
	var int MinGr, MaxGr;
	var class<KFPawn_Monster> MClass;
};
var array<SMonster> MonsterToAdd;
var float zedSpawnRateFactor;
var bool bReplaceMonstertoAdd;
var float waveValueFactor;
var float doshFactor;

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT);
function WaveEnded();

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW);
static function ModifyHardAttackDamage( out int InDamage, int DefaultDamage, KFPawn OwnerPawn);
static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW);
static function ModifyHealth( out int InHealth, int DefaultHealth);
static function ModifyArmor( out byte MaxArmor, byte DefaultArmor);
static simulated function ModifyMeleeAttackSpeed( out float InDuration, float DefaultDuration, KFWeapon KFW);
static simulated function GetReloadRateScale( out float InReloadRateScale, KFWeapon KFW, KFPawn OwnerPawn);
static function ModifyHealAmount( out float InHealAmount, float DefaultHealAmount);
static simulated function ModifyHealerRechargeTime( out float InRechargeTime, float DefaultRechargeTime);
static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn);
static simulated function ModifyRecoil( out float InRecoilModifier, float DefaultRecoilModifier, KFWeapon KFW);
static simulated function ModifyWeaponBopDamping( out float InBobDamping, float DefaultBobDamping, KFWeapon KFW);
static simulated function ModifyMagSizeAndNumber( out int InMagazineCapacity, int DefaultMagazineCapacity, KFWeapon KFW, optional array< Class<KFPerk> > WeaponPerkClass, optional bool bSecondary=false, optional name WeaponClassname );
static simulated function ModifySpareAmmoAmount( out int InSpareAmmo, int DefaultSpareAmmo, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=false );
static simulated function ModifySpareGrenadeAmount( out int SpareGrenade, int DefaultSpareGrenade);
static simulated function ModifyWeldingRate( out float InFastenRate, float DefaultFastenRate, out float InUnfastenRate, float DefaultUnfastenRate);
static simulated function GetZedTimeExtension( out float InExtension, float DefaultExtension);
static simulated function GetZedTimeModifier( out float InModifier, KFWeapon KFW);
static function ApplyWeightLimits(out int InWeightLimit, int DefaultWeightLimit);
static function ModifyDoTScaler( out float InDoTScaler, float DefaultDotScaler, optional class<KFDamageType> KFDT, optional bool bNapalmInfected);
static simulated function ModifyRateOfFire( out float InRate, float DefaultRate, KFWeapon KFW );
static simulated function ModifyTightChoke( out float InTight, float DefaultTight, KFWeapon KFW, KFPawn OwnerPawn);
static simulated function ModifyPenetration( out float InPenetration, float DefaultPenetration, class<KFDamageType> DamageType, KFPawn OwnerPawn, optional bool bForce );
static function ModifyStunPower( out float InStunPower, float DefaultStunPower, optional class<DamageType> DamageType, optional byte HitZoneIdx);
static function ModifyStumblePower( out float InStumblePower, float DefaultStumblePower, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn);
static function ModifyKnockdownPower( out float InKnockdownPower, float DefaultKnockdownPower,  KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=false );
static function ModifySnarePower( out float InSnarePower, float DefaultSnarePower, optional class<DamageType> DamageType, optional byte BodyPart);
static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, KFWeapon KFW);
static function AddVampireHealth( out int InHealth, int DefaultHealth, KFPlayerController KFPC, class<DamageType> DT );
static simulated function GetSelfHealingSurgePct(out float InHealingPct);
static simulated function GetIronSightSpeedModifier(out float InSpeed, float DefaultSpeed);
static simulated function GetCrouchSpeedModifier(out float InSpeed, float DefaultSpeed);
static simulated function ModifyCloakDetectionRange(out float InRange, float DefaultRange);
static simulated function SuccessfullParry(KFPawn OwnerPawn);

static function HealingDamage(int HealAmount, KFPawn HealedPawn, KFPawn InstigatorPawn, class<DamageType> DamageType);
static simulated function ReceiveLocalizedMessage(class<LocalMessage> Message, KFPawn OwnerPawn, optional int MessageIndex);
static simulated function DrawOnHUD(canvas C, KFPawn OwnerPawn);


static simulated function bool CanSpreadNapalm(KFPawn OwnerPawn)
{
	return false;
}

static simulated function bool ShouldKnockDownOnBump(KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	return false;
}

static simulated function bool ShouldNeverDud(KFWeapon KFW, KFPawn OwnerPawn)
{
	return false;
}

static function bool CouldBeZedShrapnel(class<KFDamageType> KFDT )
{
	return false;
}
static function bool ShouldShrapnel()
{
	return false;
}

static simulated function bool IsWeaponOnSpecificPerk( KFWeapon W, class<KFPerk> Perk)
{
	if( W != none )
	{
		return W.static.GetWeaponPerkClass(Perk) == Perk;
	}

	return false;
}
static function bool IsDamageTypeOnSpecificPerk( class<KFDamageType> KFDT, class<KFPerk> Perk )
{
	if( KFDT != none )
	{
		return KFDT.default.ModifierPerkList.Find( Perk ) > INDEX_NONE;
	}

	return false;
}

static simulated function bool GetIsUberAmmoActive(KFWeapon KFW, KFPawn OwnerPawn)
{
	return false;
}

static simulated function InitiateWeapon(KFWeapon KFW, KFPawn OwnerPawn);

defaultproperties
{
   zedSpawnRateFactor=1.000000
   waveValueFactor=1.000000
   doshFactor=1.000000
   bReplaceMonstertoAdd=false
   Name="Default__WMSpecialWave"
}
