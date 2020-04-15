Class WMZedBuff_Crawler_Faster extends WMZedBuff;

var float Speed;

static function ModifyZedSpeedMod( out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedCrawler(P) != none)
		SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod( out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	SprintChanceMod = FMin(SprintChanceMod, SprintChanceMod + 0.35f);
}


defaultproperties
{
	buffDescription="CRAWLERS ARE FASTER"
	buffIcon=Texture2D'ZED_Crawler_UI.ZED-VS_Icons_Crawler-HeavyLeap'
	Speed=0.500000
}