class WMPawn_ZedClot_Alpha_NoRiot extends KFPawn_ZedClot_Alpha;

/** Gets the actual classes used for spawning. Can be overridden to replace this monster with another */
static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}

defaultproperties
{
   Name="Default__WMPawn_ZedClot_Alpha_NoRiot"
}
