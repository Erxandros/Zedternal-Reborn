class WMSpecialWave_BobbleZed extends WMSpecialWave;

var float ZedSpawnHeadScale;
var float DamageFactor, DamageHeadFactor;
var float ZedHeadScaleCombinedPop;

function PostBeginPlay()
{
	ZedHeadScaleCombinedPop = (class'WMSpecialWave_Pop'.default.ZedHeadScale + Default.ZedSpawnHeadScale) / 2;
	SetTimer(0.80f, true, nameof(UpdateZed));
	super.PostBeginPlay();
}

function UpdateZed()
{
	local KFPawn KFM;

	foreach DynamicActors(class'KFPawn', KFM)
	{
		if (KFM.IntendedHeadScale != Default.ZedSpawnHeadScale && KFM.IntendedHeadScale != ZedHeadScaleCombinedPop)
		{
			if (KFM.IntendedHeadScale == class'WMSpecialWave_Pop'.default.ZedHeadScale)
				KFM.IntendedHeadScale = ZedHeadScaleCombinedPop;
			else
				KFM.IntendedHeadScale = Default.ZedSpawnHeadScale;

			KFM.SetHeadScale(KFM.IntendedHeadScale, KFM.CurrentHeadScale);
			if (KFPawn_Monster(KFM) != none)
				KFPawn_Monster(KFM).bDisableHeadless = true;
		}
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD && MyKFPM != none && KFPawn_ZedBloat(MyKFPM) != none)
		InDamage = InDamage * default.DamageHeadFactor;
	else
		InDamage = InDamage * default.DamageFactor;
}

function WaveEnded()
{
	local KFPawn KFM;

	foreach DynamicActors(class'KFPawn', KFM)
	{
		if (KFM.IntendedHeadScale == Default.ZedSpawnHeadScale)
		{
			KFM.IntendedHeadScale = 1.0f;
			KFM.SetHeadScale(KFM.IntendedHeadScale, KFM.CurrentHeadScale);
		}
	}

	super.WaveEnded();
}

defaultproperties
{
	Title="Bobble Zed"
	Description="That must hurt their necks!"

	zedSpawnRateFactor=0.750000
	waveValueFactor=0.700000
	doshFactor=1.400000
	ZedSpawnHeadScale=2.700000
	DamageFactor=0.800000
	DamageHeadFactor=0.550000

	Name="Default__WMSpecialWave_BobbleZed"
}
