class WMPawn_ZedCrawler_Medium extends KFPawn_ZedCrawler;

static function string GetLocalizedName()
{
	return "Medium Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.15;
	super.PostBeginPlay();
}


defaultproperties
{
   Name="Default__WMPawn_ZedCrawler_Medium"
}
