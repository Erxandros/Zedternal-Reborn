class WMZedBuff_Crawler_Faster extends WMZedBuff;

var float Speed, Sprint;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedCrawler(P) != None)
		SpeedMod += default.Speed;
}

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedCrawler(P) != None)
		SprintChanceMod += default.Sprint;
}

defaultproperties
{
	Speed=0.5f
	Sprint=0.35f

	BuffDescription="CRAWLERS ARE FASTER"
	BuffIcon=Texture2D'ZED_Crawler_UI.ZED-VS_Icons_Crawler-HeavyLeap'

	Name="Default__WMZedBuff_Crawler_Faster"
}
