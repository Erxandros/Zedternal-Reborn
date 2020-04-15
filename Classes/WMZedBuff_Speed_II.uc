Class WMZedBuff_Speed_II extends WMZedBuff;

var float Speed, SprintChance;

static function ModifyZedSpeedMod( out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod( out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	SprintChanceMod += default.SprintChance;
}


defaultproperties
{
	buffDescription="ZEDS MOVE FASTER"
	buffIcon=Texture2D'ZED_Clot_UI.ZED-VS_Icons_AlphaClot-Jump'
	Speed = 0.187500;
	SprintChance = 0.600000;
}