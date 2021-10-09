class WMZedBuff_Crawler_Health extends WMZedBuff;

var float Health, HeadHealth, Size, Speed;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedCrawler(P) != None)
	{
		HealthMod += default.Health;
		P.IntendedBodyScale += default.Size;
	}
}

static function ModifyZedHeadHealthMod(out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedCrawler(P) != None)
		HeadHealthMod += default.HeadHealth;
}

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedCrawler(P) != None)
		SpeedMod += default.Speed;
}

defaultproperties
{
	Health=1.75f
	HeadHealth=1.5f
	Size=0.175f
	Speed=0.1f

	BuffDescription="CRAWLERS ARE BIGGER"
	BuffIcon=Texture2D'ZED_Crawler_UI.ZED-VS_Icons_Crawler-LightLeap'

	Name="Default__WMZedBuff_Crawler_Health"
}
