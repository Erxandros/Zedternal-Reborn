class WMZedBuff_Slasher_Enraged extends WMZedBuff;

var float Damage, Speed, Sprint;

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot_Slasher(P) != None)
		PerZedDamageMod += default.Damage;
}

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot_Slasher(P) != None)
		SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot_Slasher(P) != None)
		SprintChanceMod += default.Sprint;
}

defaultproperties
{
	Damage=0.5f
	Speed=0.2f
	Sprint=1.0f

	BuffDescription="SLASHERS ARE ENRAGED"
	BuffIcon=Texture2D'ZED_Clot_UI.ZED-VS_Icons_AlphaClot-Enrage'

	Name="Default__WMZedBuff_Slasher_Enraged"
}
