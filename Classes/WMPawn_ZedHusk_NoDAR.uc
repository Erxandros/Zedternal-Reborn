class WMPawn_ZedHusk_NoDAR extends KFPawn_ZedHusk;

/** Gets the actual classes used for spawning. Can be overridden to replace this monster with another */
static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

defaultproperties
{
   Name="Default__WMPawn_ZedHusk_NoDAR"
}
