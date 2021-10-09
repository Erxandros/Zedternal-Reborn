class WMZedBuff_Stalker_Faster extends WMZedBuff;

var float Speed;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedStalker(P) != None)
		SpeedMod += default.Speed;
}

defaultproperties
{
	Speed=0.3f

	BuffDescription="STALKERS ARE FASTER"
	BuffIcon=Texture2D'ZED_Stalker_UI.ZED-VS_Icons_Stalker-Evade'

	Name="Default__WMZedBuff_Stalker_Faster"
}
