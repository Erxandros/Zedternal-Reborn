class WMPawn_ZedCrawler_NoElite extends KFPawn_ZedCrawler;

/** Gets the actual classes used for spawning. Can be overridden to replace this monster with another */
static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
   return default.class;
}

defaultproperties
{
   Name="Default__WMPawn_ZedCrawler_NoElite"
}