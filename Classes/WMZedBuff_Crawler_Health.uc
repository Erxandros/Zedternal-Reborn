Class WMZedBuff_Crawler_Health extends WMZedBuff;

var float Health, HeadHealth, Size;
var float Speed;

static function ModifyZedHealthMod( out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedCrawler(P) != none)
	{
		HealthMod += default.Health;
		P.IntendedBodyScale += default.Size;
	}
}
static function ModifyZedHeadHealthMod( out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedCrawler(P) != none)
		HeadHealthMod += default.HeadHealth;
}

static function ModifyZedSpeedMod( out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedCrawler(P) != none)
		SpeedMod += default.Speed;
}


defaultproperties
{
	buffDescription="CRAWLERS ARE BIGGER"
	buffIcon=Texture2D'ZED_Crawler_UI.ZED-VS_Icons_Crawler-LightLeap'
	Health=1.750000
	HeadHealth=1.500000
	Size=0.175000
	Speed=0.100000
}