class WMPawn_ZedCrawler_Mini extends KFPawn_ZedCrawler;

static function string GetLocalizedName()
{
	return "Baby Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.65;

	super.PostBeginPlay();
}


defaultproperties
{
   DoshValue=6
   XPValues(0)=6.000000
   XPValues(1)=8.000000
   XPValues(2)=8.000000
   XPValues(3)=8.000000

   Mass=30.000000
   GroundSpeed=575.000000
   SprintSpeed=675.000000
   Health=45
   Name="Default__WMPawn_ZedCrawler_Mini"
}
