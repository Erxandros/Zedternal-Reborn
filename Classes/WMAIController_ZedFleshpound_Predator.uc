class WMAIController_ZedFleshpound_Predator extends KFAIController_ZedFleshpound;

function InitPlayerReplicationInfo()
{
}

simulated event byte ScriptGetTeamNum()
{
	return 0;
}

defaultproperties
{
	TeleportCooldown=4.000000
	HiddenRelocateTeleportThreshold=7.000000
	EvadeGrenadeChance=1.000000
	bAllowScriptTeamCheck=true

	Name="Default__WMAIController_ZedFleshpound_Predator"
}
