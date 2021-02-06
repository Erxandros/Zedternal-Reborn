class WMSpecialWave_BobbleZed extends WMSpecialWave;

var float DamageFactor, DamageHeadFactor, ZedHeadScaleCombinedPop, ZedSpawnHeadScale;

function PostBeginPlay()
{
	super.PostBeginPlay();
	ZedHeadScaleCombinedPop = (class'ZedternalReborn.WMSpecialWave_Pop'.default.ZedHeadScale + Default.ZedSpawnHeadScale) / 2;
	SetTimer(0.80f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn KFM;

	foreach DynamicActors(class'KFPawn', KFM)
	{
		if (KFM.IntendedHeadScale != Default.ZedSpawnHeadScale && KFM.IntendedHeadScale != ZedHeadScaleCombinedPop)
		{
			if (KFM.IntendedHeadScale == class'ZedternalReborn.WMSpecialWave_Pop'.default.ZedHeadScale)
				KFM.IntendedHeadScale = ZedHeadScaleCombinedPop;
			else
				KFM.IntendedHeadScale = Default.ZedSpawnHeadScale;

			KFM.SetHeadScale(KFM.IntendedHeadScale, KFM.CurrentHeadScale);
			if (KFPawn_Monster(KFM) != None)
				KFPawn_Monster(KFM).bDisableHeadless = True;
		}
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD && MyKFPM != None && KFPawn_ZedBloat(MyKFPM) != None)
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
	DamageFactor=0.8f
	DamageHeadFactor=0.55f
	ZedSpawnHeadScale=2.7f
	zedSpawnRateFactor=0.75f
	waveValueFactor=0.7f
	doshFactor=1.4f

	Title="Bobble Zed"
	Description="That must hurt their necks!"

	Name="Default__WMSpecialWave_BobbleZed"
}
