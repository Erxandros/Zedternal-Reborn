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

function UpdateServerType(string ServerType)
{
	local WorldInfo WI;

	WI = class'WorldInfo'.static.GetWorldInfo();

	if (WI != none && WI.NetMode != NM_Standalone && !GetPC().WorldInfo.IsConsoleBuild())
	{
		SetString("serverType", "Unranked");
	}
}

defaultproperties
{
	Name="Default__WMGFxStartContainer_InGameOverview"
}
