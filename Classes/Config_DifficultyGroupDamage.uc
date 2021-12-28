class Config_DifficultyGroupDamage extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

struct S_Group_Damage
{
	var string GroupName;
	var S_Difficulty_Float DamageModifier;
};

var config array<S_Group_Damage> ZedGroup_Damage;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedGroup_Damage.Length = 1;

		default.ZedGroup_Damage[0].GroupName = "ExampleGroup";
		default.ZedGroup_Damage[0].DamageModifier.Normal = 0.75f;
		default.ZedGroup_Damage[0].DamageModifier.Hard = 0.8f;
		default.ZedGroup_Damage[0].DamageModifier.Suicidal = 0.9f;
		default.ZedGroup_Damage[0].DamageModifier.HoE = 1.0f;
		default.ZedGroup_Damage[0].DamageModifier.Custom = 1.0f;
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
		for (i = 0; i < default.ZedGroup_Damage.Length; ++i)
		{
			LocalStruct = default.ZedGroup_Damage[i].DamageModifier;
			for (b = 0; b < NumberOfDiffs; ++b)
			{
				if (GetStructValueFloat(LocalStruct, b) < 0.05f)
				{
					LogBadStructConfigMessage(b, "For group name" @default.ZedGroup_Damage[i].GroupName $", ZedGroup_Damage.DamageModifier",
						string(GetStructValueFloat(LocalStruct, b)),
						"0.05", "5%", "value >= 0.05");
					SetStructValueFloat(LocalStruct, b, 0.05f);
				}
			}
			default.ZedGroup_Damage[i].DamageModifier = LocalStruct;
		}
	}
	else
		SkipCheckConfigMessage("ZedGroup_Damage", "ZedGroup_bEnableGroupList");
}

static function float GetZedGroupDamageModifier(int Difficulty, string GroupName)
{
	local int i;

	for (i = 0; i < default.ZedGroup_Damage.Length; ++i)
	{
		if (default.ZedGroup_Damage[i].GroupName ~= GroupName)
		{
			switch (Difficulty)
			{
				case 0 : return default.ZedGroup_Damage[i].DamageModifier.Normal;
				case 1 : return default.ZedGroup_Damage[i].DamageModifier.Hard;
				case 2 : return default.ZedGroup_Damage[i].DamageModifier.Suicidal;
				case 3 : return default.ZedGroup_Damage[i].DamageModifier.HoE;
				default: return default.ZedGroup_Damage[i].DamageModifier.Custom;
			}
		}
	}

	return INDEX_NONE;
}

defaultproperties
{
	Name="Default__Config_DifficultyGroupDamage"
}
