class Config_TraderVoice extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config bool TraderVoice_bUsePatriarchTrader;
var config bool TraderVoice_bUseHansTrader;
var config bool TraderVoice_bUseDefaultTrader;
var config bool TraderVoice_bUseObjectiveTrader;
var config bool TraderVoice_bUseLockheartTrader;
var config bool TraderVoice_bUseSantaTrader;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.TraderVoice_bUsePatriarchTrader = True;
		default.TraderVoice_bUseHansTrader = True;
		default.TraderVoice_bUseDefaultTrader = False;
		default.TraderVoice_bUseObjectiveTrader = False;
		default.TraderVoice_bUseLockheartTrader = False;
		default.TraderVoice_bUseSantaTrader = False;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	if (!default.TraderVoice_bUsePatriarchTrader
		&& !default.TraderVoice_bUseHansTrader
		&& !default.TraderVoice_bUseDefaultTrader
		&& !default.TraderVoice_bUseObjectiveTrader
		&& !default.TraderVoice_bUseLockheartTrader
		&& !default.TraderVoice_bUseSantaTrader)
	{
		`log("ZR Config: No trader voice selected, defaulting to Patriarch trader voice."
			@"Please select one more more trader voices from Config_TraderVoice");
	}
}

defaultproperties
{
	Name="Default__Config_TraderVoice"
}
