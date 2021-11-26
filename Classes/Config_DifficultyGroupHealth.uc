class Config_DifficultyGroupHealth extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

struct S_Group_Health
{
	var string GroupName;
	var S_Difficulty_Float HealthModifier;
};

var config array<S_Group_Health> ZedGroup_Health;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedGroup_Health.Length = 1;

		default.ZedGroup_Health[0].GroupName = "ExampleGroup";
		default.ZedGroup_Health[0].HealthModifier.Normal = 1.05f;
		default.ZedGroup_Health[0].HealthModifier.Hard = 1.1f;
		default.ZedGroup_Health[0].HealthModifier.Suicidal = 1.2f;
		default.ZedGroup_Health[0].HealthModifier.HoE = 1.2f;
		default.ZedGroup_Health[0].HealthModifier.Custom = 1.2f;
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

	for (i = 0; i < default.ZedGroup_Health.Length; ++i)
	{
		LocalStruct = default.ZedGroup_Health[i].HealthModifier;
		for (b = 0; b < NumberOfDiffs; ++b)
		{
			if (GetStructValueFloat(LocalStruct, b) < 0.05f)
			{
				LogBadStructConfigMessage(b, "For group name" @default.ZedGroup_Health[i].GroupName $", ZedGroup_Health.HealthModifier",
					string(GetStructValueFloat(LocalStruct, b)),
					"0.05", "5%", "value >= 0.05");
				SetStructValueFloat(LocalStruct, b, 0.05f);
			}
		}
		default.ZedGroup_Health[i].HealthModifier = LocalStruct;
	}
}

static function float GetZedGroupHealthModifier(int Difficulty, string GroupName)
{
	local int i;

	for (i = 0; i < default.ZedGroup_Health.Length; ++i)
	{
		if (default.ZedGroup_Health[i].GroupName ~= GroupName)
		{
			switch (Difficulty)
			{
				case 0 : return default.ZedGroup_Health[i].HealthModifier.Normal;
				case 1 : return default.ZedGroup_Health[i].HealthModifier.Hard;
				case 2 : return default.ZedGroup_Health[i].HealthModifier.Suicidal;
				case 3 : return default.ZedGroup_Health[i].HealthModifier.HoE;
				default: return default.ZedGroup_Health[i].HealthModifier.Custom;
			}
		}
	}

	return INDEX_NONE;
}

defaultproperties
{
	Name="Default__Config_DifficultyGroupHealth"
}
