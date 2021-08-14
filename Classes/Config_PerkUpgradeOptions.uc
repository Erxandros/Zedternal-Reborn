class Config_PerkUpgradeOptions extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config array<int> PerkUpgrade_Price;
var config int PerkUpgrade_AvailablePerks;
var config array<string> PerkUpgrade_StaticPerkUpgrades;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.PerkUpgrade_Price[0] = 500;
		default.PerkUpgrade_Price[1] = 600;
		default.PerkUpgrade_Price[2] = 750;
		default.PerkUpgrade_Price[3] = 1000;
		default.PerkUpgrade_Price[4] = 1250;
		default.PerkUpgrade_Price[5] = 1500;

		default.PerkUpgrade_AvailablePerks = 10;
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
	local object Obj;

	for (i = 0; i < default.PerkUpgrade_Price.Length; ++i)
	{
		if (default.PerkUpgrade_Price[i] < 0)
		{
			`log("ZR Warning: PerkUpgrade_Price for perk level" @ (i + 1) @ "is set to" @ default.PerkUpgrade_Price[i]
				@"which is not supported. Setting the price to 0 (free) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.");
			default.PerkUpgrade_Price[i] = 0;
		}
	}

	if (default.PerkUpgrade_AvailablePerks < 0)
	{
		`log("ZR Warning: PerkUpgrade_AvailablePerks is set to" @ default.PerkUpgrade_AvailablePerks
			@"which is not supported. Setting the number to 0 (no perks) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.");
		default.PerkUpgrade_AvailablePerks = 0;
	}

	for (i = 0; i < default.PerkUpgrade_StaticPerkUpgrades.Length; ++i)
	{
		Obj = class<WMUpgrade_Perk>(DynamicLoadObject(default.PerkUpgrade_StaticPerkUpgrades[i], class'Class', True));
		if (Obj == None)
		{
			`log("ZR Warning: Static Perk upgrade" @ default.PerkUpgrade_StaticPerkUpgrades[i]
				@"does not exist. Skipping static upgrade."
				@"Please double check the name in the config and make sure the correct mod resources are installed.");
			default.PerkUpgrade_StaticPerkUpgrades.Remove(i, 1);
			--i;
		}
	}
}

defaultproperties
{
	Name="Default__Config_PerkUpgradeOptions"
}
