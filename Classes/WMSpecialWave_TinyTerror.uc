class WMSpecialWave_TinyTerror extends WMSpecialWave;

var float Damage, ZedScale, DamageTakenFactor, TinyTitansScale;

function PostBeginPlay()
{
	TinyTitansScale = default.ZedScale * class'ZedternalReborn.WMSpecialWave_Titans'.default.ZedScale;
	SetTimer(1.0f, true, nameof(UpdateZed));
	super.PostBeginPlay();
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
		else if (KFM.IntendedBodyScale == class'ZedternalReborn.WMSpecialWave_Titans'.default.ZedScale)
			KFM.IntendedBodyScale = TinyTitansScale;
	}
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none)
		InDamage += InDamage * default.Damage;
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage = InDamage * default.DamageTakenFactor;
}

static simulated function bool ShouldKnockDownOnBump(KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	if (KFPM != none && KFPM.IntendedBodyScale <= default.ZedScale)
		return true;
	else
		return false;
}

defaultproperties
{
	Title="Tiny Terror"
	Description="Look at them, they are so cute!"
	zedSpawnRateFactor=1.500000
	waveValueFactor=1.300000
	doshFactor=0.750000

	Damage=0.700000
	DamageTakenFactor=0.700000
	ZedScale=0.650000

	Name="Default__WMSpecialWave_TinyTerror"
}
