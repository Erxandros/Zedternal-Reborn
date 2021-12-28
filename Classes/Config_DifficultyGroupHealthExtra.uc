class Config_DifficultyGroupHealthExtra extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

struct S_Group_Health_Extra
{
	var string GroupName;
	var S_Difficulty_Float ExtraHealthModifierPerPlayer;
};

var config array<S_Group_Health_Extra> ZedGroup_HealthExtra;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedGroup_HealthExtra.Length = 1;

		default.ZedGroup_HealthExtra[0].GroupName = "ExampleGroup";
		default.ZedGroup_HealthExtra[0].ExtraHealthModifierPerPlayer.Normal = 0.05f;
		default.ZedGroup_HealthExtra[0].ExtraHealthModifierPerPlayer.Hard = 0.05f;
		default.ZedGroup_HealthExtra[0].ExtraHealthModifierPerPlayer.Suicidal = 0.05f;
		default.ZedGroup_HealthExtra[0].ExtraHealthModifierPerPlayer.HoE = 0.05f;
		default.ZedGroup_HealthExtra[0].ExtraHealthModifierPerPlayer.Custom = 0.05f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i;
	local byte b;
	local S_Difficulty_Float LocalStruct;

	if (class'ZedternalReborn.Config_DifficultyGroup'.default.ZedGroup_bEnableGroupList)
	{
		for (i = 0; i < default.ZedGroup_HealthExtra.Length; ++i)
		{
			LocalStruct = default.ZedGroup_HealthExtra[i].ExtraHealthModifierPerPlayer;
			for (b = 0; b < NumberOfDiffs; ++b)
			{
				if (GetStructValueFloat(LocalStruct, b) < 0.0f)
				{
					LogBadStructConfigMessage(b, "For group name" @default.ZedGroup_HealthExtra[i].GroupName $", ZedGroup_HealthExtra.ExtraHealthModifierPerPlayer",
						string(GetStructValueFloat(LocalStruct, b)),
						"0.0", "0%", "value >= 0.0");
					SetStructValueFloat(LocalStruct, b, 0.0f);
				}
			}
			default.ZedGroup_HealthExtra[i].ExtraHealthModifierPerPlayer = LocalStruct;
		}
	}
	else
		SkipCheckConfigMessage("ZedGroup_HealthExtra", "ZedGroup_bEnableGroupList");
}

static function float GetZedGroupExtraHealthModifierPerPlayer(int Difficulty, string GroupName)
{
	local int i;

	for (i = 0; i < default.ZedGroup_HealthExtra.Length; ++i)
	{
		if (default.ZedGroup_HealthExtra[i].GroupName ~= GroupName)
		{
			switch (Difficulty)
			{
				case 0 : return default.ZedGroup_HealthExtra[i].ExtraHealthModifierPerPlayer.Normal;
				case 1 : return default.ZedGroup_HealthExtra[i].ExtraHealthModifierPerPlayer.Hard;
				case 2 : return default.ZedGroup_HealthExtra[i].ExtraHealthModifierPerPlayer.Suicidal;
				case 3 : return default.ZedGroup_HealthExtra[i].ExtraHealthModifierPerPlayer.HoE;
				default: return default.ZedGroup_HealthExtra[i].ExtraHealthModifierPerPlayer.Custom;
			}
		}
	}

	return INDEX_NONE;
}

defaultproperties
{
	Name="Default__Config_DifficultyGroupHealthExtra"
}
