class WMPawn_ZedStalker_NoDAR extends KFPawn_ZedStalker;

static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

defaultproperties
{
	Name="Default__WMPawn_ZedStalker_NoDAR"
}
