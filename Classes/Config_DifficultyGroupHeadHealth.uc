class Config_DifficultyGroupHeadHealth extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

struct S_Group_Head_Health
{
	var string GroupName;
	var S_Difficulty_Float HeadHealthModifier;
};

var config array<S_Group_Head_Health> ZedGroup_HeadHealth;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedGroup_HeadHealth.Length = 1;

		default.ZedGroup_HeadHealth[0].GroupName = "ExampleGroup";
		default.ZedGroup_HeadHealth[0].HeadHealthModifier.Normal = 1.0f;
		default.ZedGroup_HeadHealth[0].HeadHealthModifier.Hard = 1.05f;
		default.ZedGroup_HeadHealth[0].HeadHealthModifier.Suicidal = 1.1f;
		default.ZedGroup_HeadHealth[0].HeadHealthModifier.HoE = 1.1f;
		default.ZedGroup_HeadHealth[0].HeadHealthModifier.Custom = 1.1f;
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
		for (i = 0; i < default.ZedGroup_HeadHealth.Length; ++i)
		{
			LocalStruct = default.ZedGroup_HeadHealth[i].HeadHealthModifier;
			for (b = 0; b < NumberOfDiffs; ++b)
			{
				if (GetStructValueFloat(LocalStruct, b) < 0.05f)
				{
					LogBadStructConfigMessage(b, "For group name" @default.ZedGroup_HeadHealth[i].GroupName $", ZedGroup_HeadHealth.HeadHealthModifier",
						string(GetStructValueFloat(LocalStruct, b)),
						"0.05", "5%", "value >= 0.05");
					SetStructValueFloat(LocalStruct, b, 0.05f);
				}
			}
			default.ZedGroup_HeadHealth[i].HeadHealthModifier = LocalStruct;
		}
	}
	else
		SkipCheckConfigMessage("ZedGroup_HeadHealth", "ZedGroup_bEnableGroupList");
}

static function float GetZedGroupHeadHealthModifier(int Difficulty, string GroupName)
{
	local int i;

	for (i = 0; i < default.ZedGroup_HeadHealth.Length; ++i)
	{
		if (default.ZedGroup_HeadHealth[i].GroupName ~= GroupName)
		{
			switch (Difficulty)
			{
				case 0 : return default.ZedGroup_HeadHealth[i].HeadHealthModifier.Normal;
				case 1 : return default.ZedGroup_HeadHealth[i].HeadHealthModifier.Hard;
				case 2 : return default.ZedGroup_HeadHealth[i].HeadHealthModifier.Suicidal;
				case 3 : return default.ZedGroup_HeadHealth[i].HeadHealthModifier.HoE;
				default: return default.ZedGroup_HeadHealth[i].HeadHealthModifier.Custom;
			}
		}
	}

	return INDEX_NONE;
}

defaultproperties
{
	Name="Default__Config_DifficultyGroupHeadHealth"
}
