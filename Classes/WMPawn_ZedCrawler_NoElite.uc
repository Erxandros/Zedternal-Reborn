class WMPawn_ZedCrawler_NoElite extends KFPawn_ZedCrawler;

static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

defaultproperties
{
	Name="Default__WMPawn_ZedCrawler_NoElite"
}
