class WMSpecialWave_GodMode extends WMSpecialWave;

var float Bonus, BonusINV, BonusSpeed, BonusStun;
var int Vampire;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += DefaultDamage * default.Bonus;
}

static simulated function ModifyMeleeAttackSpeed(out float InDuration, float DefaultDuration, KFWeapon KFW)
{
	InDuration -= DefaultDuration * default.BonusINV * 0.5f;
}

static simulated function GetReloadRateScale(out float InReloadRateScale, KFWeapon KFW, KFPawn OwnerPawn)
{
	InReloadRateScale -= default.BonusINV;
}

static simulated function ModifySpeed(out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn)
{
	InSpeed += DefaultSpeed * default.BonusSpeed;
}

static function ModifyDoTScaler(out float InDoTScaler, float DefaultDotScaler, optional class<KFDamageType> KFDT, optional bool bNapalmInfected)
{
	InDoTScaler += DefaultDotScaler * default.Bonus;
}

static simulated function ModifyRateOfFire(out float InRate, float DefaultRate, KFWeapon KFW)
{
	InRate -= DefaultRate * default.BonusINV * 0.5f;
}

static function ModifyStunPower(out float InStunPower, float DefaultStunPower, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	InStunPower += DefaultStunPower * default.BonusStun;
}

static function ModifyStumblePower(out float InStumblePower, float DefaultStumblePower, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	InStumblePower += DefaultStumblePower * default.BonusStun;
}

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	InKnockdownPower += DefaultKnockdownPower * default.BonusStun;
}

static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, KFWeapon KFW)
{
	InSwitchTime -= DefaultSwitchTime * default.BonusINV;
}

static function AddVampireHealth(out int InHealth, int DefaultHealth, KFPlayerController KFPC, class<DamageType> DT)
{
	InHealth += default.Vampire;
}

defaultproperties
{
	Bonus=1.0f
	BonusINV=0.35f
	BonusSpeed=0.2f
	BonusStun=3.0f
	Vampire=4
	ZedSpawnRateFactor=2.25f
	WaveValueFactor=1.5f
	DoshFactor=0.67f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_GodMode"

	Name="Default__WMSpecialWave_GodMode"
}
