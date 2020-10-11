class WMPawn_ZedCrawler_Mini extends WMPawn_ZedCrawler_NoElite;

static function string GetLocalizedName()
{
	return "Baby Crawler";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.65f;

	super.PostBeginPlay();
}

defaultproperties
{
	DoshValue=6
	Health=45
	Mass=30.0f
	GroundSpeed=575.0f
	SprintSpeed=675.0f

	XPValues(0)=6
	XPValues(1)=8
	XPValues(2)=8
	XPValues(3)=8

	Name="Default__WMPawn_ZedCrawler_Mini"
}
