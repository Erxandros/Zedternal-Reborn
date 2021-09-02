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
		`log("ZR Config: SkillReroll_BasePrice is set to" @ default.SkillReroll_BasePrice
			@"which is not supported. Setting the price to 0 (free) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.");
		default.SkillReroll_BasePrice = 0;
	}

	if (default.SkillReroll_NextRerollPriceMultiplier < 1.0f)
	{
		`log("ZR Config: SkillReroll_NextRerollPriceMultiplier is set to" @ default.SkillReroll_NextRerollPriceMultiplier
			@"which is not supported. Setting the price multiplier to 1.0 (no increase) temporarily."
			@"Please change the value in the config to a value greater than or equal to 1.0.");
		default.SkillReroll_NextRerollPriceMultiplier = 1.0f;
	}

	if (default.SkillReroll_SkillRerollSellPercentage < 0.0f)
	{
		`log("ZR Config: SkillReroll_SkillRerollSellPercentage is set to" @ default.SkillReroll_SkillRerollSellPercentage
			@"which is not supported. Setting the sell percentage to 0.0 (0%) temporarily."
			@"Please change the value in the config to a value between 0.0 and 1.0.");
		default.SkillReroll_SkillRerollSellPercentage = 0.0f;
	}

	if (default.SkillReroll_SkillRerollSellPercentage > 1.0f)
	{
		`log("ZR Config: SkillReroll_SkillRerollSellPercentage is set to" @ default.SkillReroll_SkillRerollSellPercentage
			@"which is not supported. Setting the sell percentage to 1.0 (100%) temporarily."
			@"Please change the value in the config to a value between 0.0 and 1.0.");
		default.SkillReroll_SkillRerollSellPercentage = 1.0f;
	}
}

defaultproperties
{
	Name="Default__Config_SkillReroll"
}
