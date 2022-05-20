class WMSpecialWave_Titans extends WMSpecialWave;

var float DamageFactor, DamageHeadFactor, DamageTakenFactor, TinyTitansScale, ZedHeadScale, ZedScale;

function PostBeginPlay()
{
	super.PostBeginPlay();
	TinyTitansScale = default.ZedScale * class'ZedternalReborn.WMSpecialWave_TinyTerror'.default.ZedScale;
	SetTimer(1.5f, True, NameOf(UpdateZed));
}

function UpdateZed()
{
	local KFPawn_Monster KFM;

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		if (!CheckZedBodyChange(KFM))
		{
			SetBodyChangeFlag(KFM);
			KFM.IntendedBodyScale = default.ZedScale;
		}
		else if (KFM.IntendedBodyScale == class'ZedternalReborn.WMSpecialWave_TinyTerror'.default.ZedScale)
			KFM.IntendedBodyScale = TinyTitansScale;

		if (KFM.IntendedHeadScale == 1.0f)
		{
			KFM.IntendedHeadScale = default.ZedHeadScale;
			KFM.SetHeadScale(KFM.IntendedHeadScale, KFM.CurrentHeadScale);
		}
	}
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage = InDamage * default.DamageHeadFactor;
	else
		InDamage = InDamage * default.DamageFactor;
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage = InDamage * default.DamageTakenFactor;
}

defaultproperties
{
	DamageFactor=0.25f
	DamageHeadFactor=0.2f
	DamageTakenFactor=1.2f
	ZedHeadScale=1.02f
	ZedScale=1.35f
	ZedSpawnRateFactor=0.4f
	WaveValueFactor=0.22f
	DoshFactor=4.1f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Titans"

	Name="Default__WMSpecialWave_Titans"
}
