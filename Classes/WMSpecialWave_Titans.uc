class WMSpecialWave_Titans extends WMSpecialWave;

var float ZedScale, ZedHeadScale, ZedSpeedGroundFactor, ZedSpeedRunningFactor, DamageFactor, DamageHeadFactor, DamageTakenFactor;

function PostBeginPlay()
{
	SetTimer(2.f,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;
	
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFM.IntendedHeadScale != default.ZedHeadScale && KFM.IntendedBodyScale > 0.6)
		{
			KFM.IntendedHeadScale = default.ZedHeadScale;
			KFM.SetHeadScale(KFM.IntendedHeadScale,KFM.CurrentHeadScale);
			KFM.IntendedBodyScale = default.ZedScale;
		}
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx==HZI_HEAD)
		InDamage = InDamage * default.DamageHeadFactor;
	else
		InDamage = InDamage * default.DamageFactor;
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage = InDamage * default.DamageTakenFactor;
}

defaultproperties
{
   Title="Titans"
   Description="Slowly but surely!"
   zedSpawnRateFactor=0.400000
   waveValueFactor=0.220000
   doshFactor=4.100000
   
   ZedScale=1.350000
   ZedHeadScale=1.020000
   DamageFactor=0.2500000
   DamageHeadFactor=0.200000
   DamageTakenFactor=1.200000
   
   Name="Default__WMSpecialWave_Titans"
}