class WMAIController_ZedGorefast_Omega extends KFAIController_ZedGorefast;

function bool ShouldSprint()
{
	bForceFrustration = True;
	return super.ShouldSprint();
}

defaultproperties
{
	EvadeGrenadeChance=1.0f

	Name="Default__WMAIController_ZedGorefast_Omega"
}
