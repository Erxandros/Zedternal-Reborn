class WMSpecialWave_Chaos extends WMSpecialWave;

var float Bonus, BonusINV;

function PostBeginPlay()
{
	SetTimer(1.f,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;
	
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFM.IntendedBodyScale == 1.f)
		{
			KFM.IntendedBodyScale = 1.f+0.4f*(FRand()-0.5f);
			KFM.IntendedHeadScale = 1.f+0.2f*(FRand()-0.5f);
			KFM.SetHeadScale(KFM.IntendedHeadScale,KFM.CurrentHeadScale);
		}
		KFM.SprintSpeed=KFM.default.SprintSpeed * 1.4f;
		KFM.GroundSpeed=KFM.default.GroundSpeed * 1.4f;
		KFM.bIsSprinting = true;
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += DefaultDamage * default.Bonus;
}
static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage -= DefaultDamage * default.BonusINV;
}
static simulated function ModifyMeleeAttackSpeed( out float InDuration, float DefaultDuration, KFWeapon KFW)
{
	InDuration -= DefaultDuration * default.BonusINV;
}
static simulated function GetReloadRateScale( out float InReloadRateScale, KFWeapon KFW, KFPawn OwnerPawn)
{
	InReloadRateScale -= default.BonusINV;
}
static simulated function ModifySpeed( out float InSpeed, float DefaultSpeed, KFPawn OwnerPawn)
{
	InSpeed += DefaultSpeed * default.Bonus;
}
static function ModifyDoTScaler( out float InDoTScaler, float DefaultDotScaler, optional class<KFDamageType> KFDT, optional bool bNapalmInfected)
{
	InDoTScaler += DefaultDotScaler * default.Bonus;
}
static simulated function ModifyRateOfFire( out float InRate, float DefaultRate, KFWeapon KFW )
{
	InRate -= DefaultRate * default.BonusINV;
}
static function ModifyStunPower( out float InStunPower, float DefaultStunPower, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	InStunPower += DefaultStunPower * default.Bonus;
}
static function ModifyStumblePower( out float InStumblePower, float DefaultStumblePower, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	InStumblePower += DefaultStumblePower * default.Bonus;
}
static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, KFWeapon KFW)
{
	InSwitchTime -= DefaultSwitchTime * default.BonusINV;
}

defaultproperties
{
   Title="Chaos"
   Description="???"
   zedSpawnRateFactor=3.000000
   waveValueFactor=0.800000
   doshFactor=1.250000
   Bonus=0.300000
   BonusINV=0.230769
   Name="Default__WMSpecialWave_Chaos"
}
