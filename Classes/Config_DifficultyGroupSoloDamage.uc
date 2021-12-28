class Config_DifficultyGroupSoloDamage extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

struct S_Group_Solo_Damage
{
	var string GroupName;
	var S_Difficulty_Float SoloDamageModifier;
};

var config array<S_Group_Solo_Damage> ZedGroup_SoloDamage;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedGroup_SoloDamage.Length = 1;

		default.ZedGroup_SoloDamage[0].GroupName = "ExampleGroup";
		default.ZedGroup_SoloDamage[0].SoloDamageModifier.Normal = 0.7f;
		default.ZedGroup_SoloDamage[0].SoloDamageModifier.Hard = 0.8f;
		default.ZedGroup_SoloDamage[0].SoloDamageModifier.Suicidal = 0.9f;
		default.ZedGroup_SoloDamage[0].SoloDamageModifier.HoE = 1.0f;
		default.ZedGroup_SoloDamage[0].SoloDamageModifier.Custom = 1.0f;
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
		for (i = 0; i < default.ZedGroup_SoloDamage.Length; ++i)
		{
			LocalStruct = default.ZedGroup_SoloDamage[i].SoloDamageModifier;
			for (b = 0; b < NumberOfDiffs; ++b)
			{
				if (GetStructValueFloat(LocalStruct, b) < 0.05f)
				{
					LogBadStructConfigMessage(b, "For group name" @default.ZedGroup_SoloDamage[i].GroupName $", ZedGroup_SoloDamage.SoloDamageModifier",
						string(GetStructValueFloat(LocalStruct, b)),
						"0.05", "5%", "value >= 0.05");
					SetStructValueFloat(LocalStruct, b, 0.05f);
				}
			}
			default.ZedGroup_SoloDamage[i].SoloDamageModifier = LocalStruct;
		}
	}
	else
		SkipCheckConfigMessage("ZedGroup_SoloDamage", "ZedGroup_bEnableGroupList");
}

static function float GetZedGroupSoloDamageModifier(int Difficulty, string GroupName)
{
	local int i;

	for (i = 0; i < default.ZedGroup_SoloDamage.Length; ++i)
	{
		if (default.ZedGroup_SoloDamage[i].GroupName ~= GroupName)
		{
			switch (Difficulty)
			{
				case 0 : return default.ZedGroup_SoloDamage[i].SoloDamageModifier.Normal;
				case 1 : return default.ZedGroup_SoloDamage[i].SoloDamageModifier.Hard;
				case 2 : return default.ZedGroup_SoloDamage[i].SoloDamageModifier.Suicidal;
				case 3 : return default.ZedGroup_SoloDamage[i].SoloDamageModifier.HoE;
				default: return default.ZedGroup_SoloDamage[i].SoloDamageModifier.Custom;
			}
		}
	}

	return INDEX_NONE;
}

defaultproperties
{
	Name="Default__Config_DifficultyGroupSoloDamage"
}
