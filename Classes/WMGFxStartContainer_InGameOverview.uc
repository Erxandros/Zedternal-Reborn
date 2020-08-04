class WMGFxStartContainer_InGameOverview extends KFGFxStartContainer_InGameOverview
dependson(KFUnlockManager);

function UpdateGameMode(string Mode)
{
	SetString("gameMode", "ZedternalReborn");
}

function UpdateDifficulty(string Difficulty)
{
	if (Difficulty ~= "ANY")
		SetString("difficultyText", "Custom");
	else
		SetString("difficultyText", Difficulty);
}

function UpdateLength(string Length)
{
	SetString("lengthText", "Endless");
}

defaultproperties
{
	Name="Default__WMGFxStartContainer_InGameOverview"
}
