class WMSpecialWave_Shrink extends WMSpecialWave;

var float StartingDamageSizeScale, DeadDamageSizeScale;
var float StartingDamageScale, DeadDamageScale;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local float ScalePercent;

	if (MyKFPM != none)
	{
		AdjustPawnScale(MyKFPM);
		ScalePercent = (default.StartingDamageSizeScale - default.DeadDamageSizeScale) * (1 - (float(Max(MyKFPM.Health, 0)) / float(MyKFPM.HealthMax)));
		InDamage += Round(float(InDamage) * ScalePercent);
	}
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local float ScalePercent;

	if (KFPawn_Monster(InstigatedBy.Pawn) != none)
	{
		ScalePercent = (default.StartingDamageSizeScale - default.DeadDamageSizeScale) * (1 - (float(Max(InstigatedBy.Pawn.Health, 0)) / float(InstigatedBy.Pawn.HealthMax)));
		InDamage -= Round(float(InDamage) * ScalePercent);
	}
}

static function AdjustPawnScale(KFPawn_Monster entity)
{
	local float ScalePercent;
	local int CurrentHealth;

	CurrentHealth = Max(entity.Health, 0);

	if (entity != none)
	{
		ScalePercent = default.StartingDamageSizeScale - (default.StartingDamageSizeScale - default.DeadDamageSizeScale) * (1 - (float(CurrentHealth) / float(entity.HealthMax)));
		entity.IntendedBodyScale = (entity.IntendedBodyScale - default.DeadDamageSizeScale) * ScalePercent + default.DeadDamageSizeScale;
	}
}

static simulated function bool ShouldKnockDownOnBump(KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	if (KFPM != none && KFPM.IntendedBodyScale <= 0.6f)
		return true;
	else
		return false;
}

defaultproperties
{
	Title="Shrink"
	Description="A small threat is still a threat!"
	zedSpawnRateFactor=1.000000
	waveValueFactor=1.000000

	StartingDamageSizeScale=1.000000
	DeadDamageSizeScale=0.500000
	StartingDamageScale=1.000000
	DeadDamageScale=1.500000

	Name="Default__WMSpecialWave_Shrink"
}
