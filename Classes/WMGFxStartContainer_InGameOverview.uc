class WMGFxStartContainer_InGameOverview extends KFGFxStartContainer_InGameOverview
dependson(KFUnlockManager);


function UpdateGameMode( string Mode )
{
	SetString("gameMode", "ZedternalReborn");
}


// The party leader has modified a game option
function UpdateLength( string Length )
{
	SetString("lengthText", "Endless");
}

defaultproperties
{
   Name="Default__WMGFxStartContainer_InGameOverview"
}
