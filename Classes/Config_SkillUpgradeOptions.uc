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

static function CheckConfigValues()
{
	local int i;

	if (default.SkillUpgrade_Price < 0)
	{
		`log("ZR Warning: SkillUpgrade_Price is set to" @ default.SkillUpgrade_Price
			@"which is not supported. Setting the price to 0 (free) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.");
		default.SkillUpgrade_Price = 0;
	}

	if (default.SkillUpgrade_DeluxePrice < 0)
	{
		`log("ZR Warning: SkillUpgrade_DeluxePrice is set to" @ default.SkillUpgrade_DeluxePrice
			@"which is not supported. Setting the price to 0 (free) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.");
		default.SkillUpgrade_DeluxePrice = 0;
	}

	for (i = 0; i < default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels.Length; ++i)
	{
		if (default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] < 1)
		{
			`log("ZR Warning: SkillUpgrade_DeluxeSkillUnlock.PerkLevels has an entry" @ default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i]
				@"which is not supported. Setting the level to 1 (first perk level) temporarily."
				@"Please change the value in the config to a value between 1 and 255.");
			default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] = 1;
		}

		if (default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] > 255)
		{
			`log("ZR Warning: SkillUpgrade_DeluxeSkillUnlock.PerkLevels has an entry" @ default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i]
				@"which is not supported. Setting the level to 255 (last perk level) temporarily."
				@"Please change the value in the config to a value between 1 and 255.");
			default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] = 255;
		}
	}
}

defaultproperties
{
	Name="Default__Config_SkillUpgradeOptions"
}
