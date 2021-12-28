class Config_DifficultyGroupSpeed extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

struct S_Group_Speed
{
	var string GroupName;
	var S_Difficulty_Float SpeedModifier;
};

var config array<S_Group_Speed> ZedGroup_Speed;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedGroup_Speed.Length = 1;

		default.ZedGroup_Speed[0].GroupName = "ExampleGroup";
		default.ZedGroup_Speed[0].SpeedModifier.Normal = 0.95f;
		default.ZedGroup_Speed[0].SpeedModifier.Hard = 1.0f;
		default.ZedGroup_Speed[0].SpeedModifier.Suicidal = 1.05f;
		default.ZedGroup_Speed[0].SpeedModifier.HoE = 1.1f;
		default.ZedGroup_Speed[0].SpeedModifier.Custom = 1.1f;
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
		for (i = 0; i < default.ZedGroup_Speed.Length; ++i)
		{
			LocalStruct = default.ZedGroup_Speed[i].SpeedModifier;
			for (b = 0; b < NumberOfDiffs; ++b)
			{
				if (GetStructValueFloat(LocalStruct, b) < 0.05f)
				{
					LogBadStructConfigMessage(b, "For group name" @default.ZedGroup_Speed[i].GroupName $", ZedGroup_Speed.SpeedModifier",
						string(GetStructValueFloat(LocalStruct, b)),
						"0.05", "5%", "value >= 0.05");
					SetStructValueFloat(LocalStruct, b, 0.05f);
				}
			}
			default.ZedGroup_Speed[i].SpeedModifier = LocalStruct;
		}
	}
	else
		SkipCheckConfigMessage("ZedGroup_Speed", "ZedGroup_bEnableGroupList");
}

static function float GetZedGroupSpeedModifier(int Difficulty, string GroupName)
{
	local int i;

	for (i = 0; i < default.ZedGroup_Speed.Length; ++i)
	{
		if (default.ZedGroup_Speed[i].GroupName ~= GroupName)
		{
			switch (Difficulty)
			{
				case 0 : return default.ZedGroup_Speed[i].SpeedModifier.Normal;
				case 1 : return default.ZedGroup_Speed[i].SpeedModifier.Hard;
				case 2 : return default.ZedGroup_Speed[i].SpeedModifier.Suicidal;
				case 3 : return default.ZedGroup_Speed[i].SpeedModifier.HoE;
				default: return default.ZedGroup_Speed[i].SpeedModifier.Custom;
			}
		}
	}

	return INDEX_NONE;
}

defaultproperties
{
	Name="Default__Config_DifficultyGroupSpeed"
}
