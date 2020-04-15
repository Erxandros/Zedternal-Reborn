Class WMZedBuff_Slasher_Enraged extends WMZedBuff;

var float Damage, Speed;

static function ModifyZedDamageMod( out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot_Slasher(P) != none)
		PerZedDamageMod += default.Damage;
}

static function ModifyZedSpeedMod( out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot_Slasher(P) != none)
		SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod( out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot_Slasher(P) != none)
		SprintChanceMod = 1.f;
}


defaultproperties
{
	buffDescription="SLASHERS ARE ENRAGED"
	buffIcon=Texture2D'ZED_Clot_UI.ZED-VS_Icons_AlphaClot-Enrage'
	Damage = 0.500000
	Speed = 0.200000
}