class Config_Voting extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Float Voting_SkipTraderVotingPercentage;
var config S_Difficulty_Float Voting_PauseGameVotingPercentage;

var config S_Difficulty_Bool Voting_bEnablePauseButton;
var config S_Difficulty_Bool Voting_bAllowTraderDuringPause;
var config S_Difficulty_Bool Voting_bAllowPickupsDuringPause;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Voting_SkipTraderVotingPercentage.Normal = 1.0f;
		default.Voting_SkipTraderVotingPercentage.Hard = 1.0f;
		default.Voting_SkipTraderVotingPercentage.Suicidal = 1.0f;
		default.Voting_SkipTraderVotingPercentage.HoE = 1.0f;
		default.Voting_SkipTraderVotingPercentage.Custom = 1.0f;

		default.Voting_PauseGameVotingPercentage.Normal = 1.0f;
		default.Voting_PauseGameVotingPercentage.Hard = 1.0f;
		default.Voting_PauseGameVotingPercentage.Suicidal = 1.0f;
		default.Voting_PauseGameVotingPercentage.HoE = 1.0f;
		default.Voting_PauseGameVotingPercentage.Custom = 1.0f;

		default.Voting_bEnablePauseButton.Normal = True;
		default.Voting_bEnablePauseButton.Hard = True;
		default.Voting_bEnablePauseButton.Suicidal = True;
		default.Voting_bEnablePauseButton.HoE = True;
		default.Voting_bEnablePauseButton.Custom = True;

		default.Voting_bAllowTraderDuringPause.Normal = False;
		default.Voting_bAllowTraderDuringPause.Hard = False;
		default.Voting_bAllowTraderDuringPause.Suicidal = False;
		default.Voting_bAllowTraderDuringPause.HoE = False;
		default.Voting_bAllowTraderDuringPause.Custom = False;

		default.Voting_bAllowPickupsDuringPause.Normal = False;
		default.Voting_bAllowPickupsDuringPause.Hard = False;
		default.Voting_bAllowPickupsDuringPause.Suicidal = False;
		default.Voting_bAllowPickupsDuringPause.HoE = False;
		default.Voting_bAllowPickupsDuringPause.Custom = False;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local byte i;

	for (i = 0; i < NumberOfDiffs; ++i)
	{
		if (GetStructValueFloat(default.Voting_SkipTraderVotingPercentage, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Voting_SkipTraderVotingPercentage",
				string(GetStructValueFloat(default.Voting_SkipTraderVotingPercentage, i)),
				"0.0", "0%, minimum voting percentage", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Voting_SkipTraderVotingPercentage, i, 0.0f);
		}

		if (GetStructValueFloat(default.Voting_SkipTraderVotingPercentage, i) > 1.0f)
		{
			LogBadStructConfigMessage(i, "Voting_SkipTraderVotingPercentage",
				string(GetStructValueFloat(default.Voting_SkipTraderVotingPercentage, i)),
				"1.0", "100%, maximum voting percentage", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Voting_SkipTraderVotingPercentage, i, 1.0f);
		}

		if (GetStructValueFloat(default.Voting_PauseGameVotingPercentage, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Voting_PauseGameVotingPercentage",
				string(GetStructValueFloat(default.Voting_PauseGameVotingPercentage, i)),
				"0.0", "0%, minimum voting percentage", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Voting_PauseGameVotingPercentage, i, 0.0f);
		}

		if (GetStructValueFloat(default.Voting_PauseGameVotingPercentage, i) > 1.0f)
		{
			LogBadStructConfigMessage(i, "Voting_PauseGameVotingPercentage",
				string(GetStructValueFloat(default.Voting_PauseGameVotingPercentage, i)),
				"1.0", "100%, maximum voting percentage", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Voting_PauseGameVotingPercentage, i, 1.0f);
		}
	}
}

static function float GetSkipTraderVotingPercentage(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Voting_SkipTraderVotingPercentage.Normal;
		case 1 : return default.Voting_SkipTraderVotingPercentage.Hard;
		case 2 : return default.Voting_SkipTraderVotingPercentage.Suicidal;
		case 3 : return default.Voting_SkipTraderVotingPercentage.HoE;
		default: return default.Voting_SkipTraderVotingPercentage.Custom;
	}
}

static function float GetPauseGameVotingPercentage(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Voting_PauseGameVotingPercentage.Normal;
		case 1 : return default.Voting_PauseGameVotingPercentage.Hard;
		case 2 : return default.Voting_PauseGameVotingPercentage.Suicidal;
		case 3 : return default.Voting_PauseGameVotingPercentage.HoE;
		default: return default.Voting_PauseGameVotingPercentage.Custom;
	}
}

static function bool GetShouldEnablePauseButton(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Voting_bEnablePauseButton.Normal;
		case 1 : return default.Voting_bEnablePauseButton.Hard;
		case 2 : return default.Voting_bEnablePauseButton.Suicidal;
		case 3 : return default.Voting_bEnablePauseButton.HoE;
		default: return default.Voting_bEnablePauseButton.Custom;
	}
}

static function bool GetShouldAllowTraderDuringPause(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Voting_bAllowTraderDuringPause.Normal;
		case 1 : return default.Voting_bAllowTraderDuringPause.Hard;
		case 2 : return default.Voting_bAllowTraderDuringPause.Suicidal;
		case 3 : return default.Voting_bAllowTraderDuringPause.HoE;
		default: return default.Voting_bAllowTraderDuringPause.Custom;
	}
}

static function bool GetShouldAllowPickupsDuringPause(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Voting_bAllowPickupsDuringPause.Normal;
		case 1 : return default.Voting_bAllowPickupsDuringPause.Hard;
		case 2 : return default.Voting_bAllowPickupsDuringPause.Suicidal;
		case 3 : return default.Voting_bAllowPickupsDuringPause.HoE;
		default: return default.Voting_bAllowPickupsDuringPause.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Voting"
}
