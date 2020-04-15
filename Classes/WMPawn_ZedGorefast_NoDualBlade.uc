class WMPawn_ZedGorefast_NoDualBlade extends KFPawn_ZedGorefast;

/** Gets the actual classes used for spawning. Can be overridden to replace this monster with another */
static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

DefaultProperties
{
	Name="WMPawn_ZedGorefast_NoDualBlade"
}
