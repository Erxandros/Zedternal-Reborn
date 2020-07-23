Class WMZedBuff_Stalker_Faster extends WMZedBuff;

var float Speed;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedStalker(P) != none)
		SpeedMod += default.Speed;
}

defaultproperties
{
	buffDescription="STALKERS ARE FASTER"
	buffIcon=Texture2D'ZED_Stalker_UI.ZED-VS_Icons_Stalker-Evade'
	Speed=0.300000
}
