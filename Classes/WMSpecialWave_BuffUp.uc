class WMSpecialWave_BuffUp extends WMSpecialWave;

var float DamageSizeScale, ScaleMax, ScaleMin, ScaleDelta, Delay;

function PostBeginPlay()
{
	SetTimer(Delay,true,nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (KFM.IntendedBodyScale >= 1.f)
			KFM.IntendedBodyScale = default.ScaleMin;
		else if( KFM.IntendedBodyScale < default.ScaleMax)
			KFM.IntendedBodyScale += default.ScaleDelta;
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local float ScalePercent;

	if (MyKFPM != none)
	{
		ScalePercent = MyKFPM.IntendedBodyScale * default.DamageSizeScale;
		InDamage += Round(float(InDamage) * ScalePercent);
	}
}

defaultproperties
{
	Title="Buff Up"
	Description="They grow fast!"
	zedSpawnRateFactor=1.000000
	waveValueFactor=1.000000
	DamageSizeScale=1.000000
	ScaleMax=1.500000
	ScaleMin=0.800000
	ScaleDelta=0.040000

	Delay=6.000000

	Name="Default__WMSpecialWave_BuffUp"
}
