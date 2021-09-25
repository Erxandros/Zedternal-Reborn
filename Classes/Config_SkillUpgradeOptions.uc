class Config_SkillUpgradeOptions extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config int SkillUpgrade_Price;
var config int SkillUpgrade_DeluxePrice;

struct S_DeluxeSkills
{
	var array<int> PerkLevels;
};

var config S_DeluxeSkills SkillUpgrade_DeluxeSkillUnlock;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.SkillUpgrade_Price = 300;
		default.SkillUpgrade_DeluxePrice = 750;
		default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[0] = 6;
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

	if (default.SkillUpgrade_Price < 0)
	{
		LogBadConfigMessage("SkillUpgrade_Price",
			string(default.SkillUpgrade_Price),
			"0", "0 dosh, free", "value >= 0");
		default.SkillUpgrade_Price = 0;
	}

	if (default.SkillUpgrade_DeluxePrice < 0)
	{
		LogBadConfigMessage("SkillUpgrade_DeluxePrice",
			string(default.SkillUpgrade_DeluxePrice),
			"0", "0 dosh, free", "value >= 0");
		default.SkillUpgrade_DeluxePrice = 0;
	}

	for (i = 0; i < default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels.Length; ++i)
	{
		if (default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] < 1)
		{
			LogBadConfigMessage("SkillUpgrade_DeluxeSkillUnlock - Position" @ string(i + 1),
				string(default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i]),
				"1", "first perk level", "255 >= value >= 1");
			default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] = 1;
		}

		if (default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] > 255)
		{
			LogBadConfigMessage("SkillUpgrade_DeluxeSkillUnlock - Position" @ string(i + 1),
				string(default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i]),
				"255", "max perk level", "255 >= value >= 1");
			default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] = 255;
		}
	}
}

defaultproperties
{
	Name="Default__Config_SkillUpgradeOptions"
}
