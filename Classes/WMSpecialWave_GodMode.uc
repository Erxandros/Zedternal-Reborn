class WMSpecialWave_GodMode extends WMSpecialWave;

var float Bonus, BonusSpeed, BonusStun, BonusINV;
var int Vampire;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += DefaultDamage * default.Bonus;
}
static simulated function ModifyMeleeAttackSpeed( out float InDuration, float DefaultDuration, KFWeapon KFW)
{
	InDuration -= DefaultDuration  * default.BonusINV * 0.5f;
}
static simulated function GetReloadRateScale( out float InReloadRateScale, KFWeapon KFW, KFPawn OwnerPawn)
{
	InReloadRateScale -= default.BonusINV;
}
static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn)
{
	InSpeed += DefaultSpeed * default.BonusSpeed;
}
static function ModifyDoTScaler( out float InDoTScaler, float DefaultDotScaler, optional class<KFDamageType> KFDT, optional bool bNapalmInfected)
{
	InDoTScaler += DefaultDotScaler * default.Bonus;
}
static simulated function ModifyRateOfFire( out float InRate, float DefaultRate, KFWeapon KFW )
{
	InRate -= DefaultRate * default.BonusINV * 0.5f;
}
static function ModifyStunPower( out float InStunPower, float DefaultStunPower, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	InStunPower += DefaultStunPower * default.BonusStun;
}
static function ModifyStumblePower( out float InStumblePower, float DefaultStumblePower, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	InStumblePower += DefaultStumblePower * default.BonusStun;
}
static function ModifyKnockdownPower( out float InKnockdownPower, float DefaultKnockdownPower, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=false)
{
	InKnockdownPower += DefaultKnockdownPower * default.BonusStun;
}
static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, KFWeapon KFW)
{
	InSwitchTime -= DefaultSwitchTime * default.BonusINV;
}

static function AddVampireHealth( out int InHealth, int DefaultHealth, KFPlayerController KFPC, class<DamageType> DT )
{
	InHealth += default.Vampire;
}

defaultproperties
{
   Title="Super Soldier"
   Description="Release your true power"
   zedSpawnRateFactor=2.250000
   waveValueFactor=1.500000
   doshFactor=0.67000
   Bonus=1.000000
   BonusSpeed=0.200000
   BonusStun=4.000000
   BonusINV=0.350000
   Vampire = 4
   Name="Default__WMSpecialWave_GodMode"
}
