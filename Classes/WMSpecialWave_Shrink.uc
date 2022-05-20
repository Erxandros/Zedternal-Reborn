class WMSpecialWave_Shrink extends WMSpecialWave;

var float DeadDamageSizeScale, StartingDamageSizeScale;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	local float ScalePercent;

	if (MyKFPM != None)
	{
		AdjustPawnScale(MyKFPM);
		ScalePercent = (default.StartingDamageSizeScale - default.DeadDamageSizeScale) * (1 - (float(Max(MyKFPM.Health, 0)) / float(MyKFPM.HealthMax)));
		InDamage += Round(float(InDamage) * ScalePercent);
	}
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	local float ScalePercent;

	if (KFPawn_Monster(InstigatedBy.Pawn) != None)
	{
		ScalePercent = (default.StartingDamageSizeScale - default.DeadDamageSizeScale) * (1 - (float(Max(InstigatedBy.Pawn.Health, 0)) / float(InstigatedBy.Pawn.HealthMax)));
		InDamage -= Round(float(InDamage) * ScalePercent);
	}
}

static function AdjustPawnScale(KFPawn_Monster entity)
{
	local float ScalePercent;

	if (entity != None)
	{
		ScalePercent = default.StartingDamageSizeScale * (float(Max(entity.Health, 0)) / float(entity.HealthMax));
		entity.IntendedBodyScale = (entity.IntendedBodyScale - default.DeadDamageSizeScale) * ScalePercent + default.DeadDamageSizeScale;
	}
}

static simulated function bool ShouldKnockDownOnBump(KFPawn_Monster KFPM, KFPawn OwnerPawn)
{
	if (KFPM != None && KFPM.IntendedBodyScale <= class'ZedternalReborn.WMSpecialWave_TinyTerror'.default.ZedScale)
		return True;
	else
		return False;
}

defaultproperties
{
	DeadDamageSizeScale=0.5f
	StartingDamageSizeScale=1.0f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Shrink"

	Name="Default__WMSpecialWave_Shrink"
}
