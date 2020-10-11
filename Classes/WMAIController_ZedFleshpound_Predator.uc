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
	bAllowScriptTeamCheck=True
	TeleportCooldown=4.0f
	EvadeGrenadeChance=1.0f

	Name="Default__WMAIController_ZedFleshpound_Predator"
}
