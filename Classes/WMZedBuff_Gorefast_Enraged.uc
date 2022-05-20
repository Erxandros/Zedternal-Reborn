class WMZedBuff_Gorefast_Enraged extends WMZedBuff;

var float Damage, Speed, SprintChance;

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != None)
		PerZedDamageMod += default.Damage;
}

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != None)
		SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != None)
		SprintChanceMod += default.SprintChance;
}

defaultproperties
{
	Damage=0.1f
	Speed=0.15f
	SprintChance=1.0f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Gorefast_Enraged"
	BuffIcon=Texture2D'ZED_Gorefast_UI.ZED-VS_Icons_Gorefast-BladeSwing'

	Name="Default__WMZedBuff_Gorefast_Enraged"
}
