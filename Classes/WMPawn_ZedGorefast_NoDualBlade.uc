class WMPawn_ZedGorefast_NoDualBlade extends KFPawn_ZedGorefast;

static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

defaultproperties
{
	Name="WMPawn_ZedGorefast_NoDualBlade"
}
