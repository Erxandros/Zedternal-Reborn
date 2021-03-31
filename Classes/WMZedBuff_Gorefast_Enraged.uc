Class WMZedBuff_Gorefast_Enraged extends WMZedBuff;

var float Damage, Speed, SprintChance;

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != none)
		PerZedDamageMod += default.Damage;
}

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != none)
		SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedGorefast(P) != none)
		SprintChanceMod += default.SprintChance;
}

defaultproperties
{
	buffDescription="GOREFASTS ARE ENRAGED"
	buffIcon=Texture2D'ZED_Gorefast_UI.ZED-VS_Icons_Gorefast-BladeSwing'
	Damage = 0.100000
	Speed = 0.150000
	SprintChance = 1.000000
}
