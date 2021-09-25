class Config_SkillReroll extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config bool SkillReroll_bEnable;
var config int SkillReroll_BasePrice;
var config float SkillReroll_NextRerollPriceMultiplier;
var config float SkillReroll_SkillRerollSellPercentage;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.SkillReroll_bEnable = True;
		default.SkillReroll_BasePrice = 400;
		default.SkillReroll_NextRerollPriceMultiplier = 2.0f;
		default.SkillReroll_SkillRerollSellPercentage = 0.5f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	if (default.SkillReroll_BasePrice < 0)
	{
		LogBadConfigMessage("SkillReroll_BasePrice",
			string(default.SkillReroll_BasePrice),
			"0", "0 dosh, free", "value >= 0");
		default.SkillReroll_BasePrice = 0;
	}

	if (default.SkillReroll_NextRerollPriceMultiplier < 1.0f)
	{
		LogBadConfigMessage("SkillReroll_NextRerollPriceMultiplier",
			string(default.SkillReroll_NextRerollPriceMultiplier),
			"1.0", "1x, no increase", "value >= 1.0");
		default.SkillReroll_NextRerollPriceMultiplier = 1.0f;
	}

	if (default.SkillReroll_SkillRerollSellPercentage < 0.0f)
	{
		LogBadConfigMessage("SkillReroll_SkillRerollSellPercentage",
			string(default.SkillReroll_SkillRerollSellPercentage),
			"0.0", "0%, no dosh returned when skills sold", "1.0 >= value >= 0.0");
		default.SkillReroll_SkillRerollSellPercentage = 0.0f;
	}

	if (default.SkillReroll_SkillRerollSellPercentage > 1.0f)
	{
		LogBadConfigMessage("SkillReroll_SkillRerollSellPercentage",
			string(default.SkillReroll_SkillRerollSellPercentage),
			"1.0", "100%, all dosh returned when skills sold", "1.0 >= value >= 0.0");
		default.SkillReroll_SkillRerollSellPercentage = 1.0f;
	}
}

defaultproperties
{
	Name="Default__Config_SkillReroll"
}
