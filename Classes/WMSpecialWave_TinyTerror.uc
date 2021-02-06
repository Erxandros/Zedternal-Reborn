class WMSpecialWave_TinyTerror extends WMSpecialWave;

var float Damage, DamageTakenFactor, TinyTitansScale, ZedScale;

function PostBeginPlay()
{
	super.PostBeginPlay();
	TinyTitansScale = default.ZedScale * class'ZedternalReborn.WMSpecialWave_Titans'.default.ZedScale;
	SetTimer(1.0f, True, NameOf(UpdateZed));
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

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None)
		InDamage += InDamage * default.Damage;
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage = InDamage * default.DamageTakenFactor;
}

static simulated function bool ShouldKnockDownOnBump(KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	if (KFPM != None && KFPM.IntendedBodyScale <= default.ZedScale)
		return True;
	else
		return False;
}

defaultproperties
{
	Damage=0.7f
	DamageTakenFactor=0.7f
	ZedScale=0.65f
	zedSpawnRateFactor=1.5f
	waveValueFactor=1.3f
	doshFactor=0.75f

	Title="Tiny Terror"
	Description="Look at them, they are so cute!"

	Name="Default__WMSpecialWave_TinyTerror"
}
