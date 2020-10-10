class WMPawn_ZedHusk_NoDAR extends KFPawn_ZedHusk;

static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

defaultproperties
{
	Name="Default__WMPawn_ZedHusk_NoDAR"
}
