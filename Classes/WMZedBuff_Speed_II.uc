class WMZedBuff_Speed_II extends WMZedBuff;

var float Speed, SprintChance;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	SprintChanceMod += default.SprintChance;
}

defaultproperties
{
	Speed=0.1875f
	SprintChance=0.6f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Speed_II"
	BuffIcon=Texture2D'ZED_Clot_UI.ZED-VS_Icons_AlphaClot-Jump'

	Name="Default__WMZedBuff_Speed_II"
}
