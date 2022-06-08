class WMPawn_ZedCrawler_Medium extends WMPawn_ZedCrawler_NoElite;

static function string GetLocalizedName()
{
	return class'ZedternalReborn.WMPawn_ZedConstants'.default.MediumString @ super.GetLocalizedName();
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.15f;

	super.PostBeginPlay();
}

defaultproperties
{
	Name="Default__WMPawn_ZedCrawler_Medium"
}
