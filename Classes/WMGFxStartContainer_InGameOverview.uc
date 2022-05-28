class WMGFxStartContainer_InGameOverview extends KFGFxStartContainer_InGameOverview
dependson(KFUnlockManager);

function UpdateGameMode(string Mode)
{
	SetString("gameMode", "ZedternalReborn v" $class'Config_Base'.const.CurrentVersion $"." $class'Config_Base'.const.CurrentHotfix);
}

function UpdateDifficulty(string Difficulty)
{
	if (Difficulty ~= class'KFCommon_LocalizedStrings'.default.NoPreferenceString)
		SetString("difficultyText", class'KFCommon_LocalizedStrings'.default.CustomString);
	else
		SetString("difficultyText", Difficulty);
}

function UpdateLength(string Length)
{
	SetString("lengthText", class'KFCommon_LocalizedStrings'.static.GetGameModeString(3));
}

function UpdateServerType(string ServerType)
{
	local WorldInfo WI;

	WI = class'WorldInfo'.static.GetWorldInfo();

	if (WI != None && WI.NetMode != NM_Standalone && !GetPC().WorldInfo.IsConsoleBuild())
	{
		SetString("serverType", class'KFCommon_LocalizedStrings'.static.GetServerTypeString(3));
	}
}

defaultproperties
{
	Name="Default__WMGFxStartContainer_InGameOverview"
}
