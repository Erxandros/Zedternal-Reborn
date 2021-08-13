class Config_PerkUpgrade extends Config_Common
	config(ZedternalReborn);

var config int MODEVERSION;

var config array<string> PerkUpgrade_PerkUpgrades;
var config array<string> PerkUpgrade_FixedPerkUpgrades;
var config int PerkUpgrade_NbAvailablePerks;
var config array<int> PerkUpgrade_Price;

struct S_SkillRerollCost
{
	var int BasePrice;
	var float NextRerollMultiplier;
};
var config bool PerkUpgrade_bAllowSkillReroll;
var config S_SkillRerollCost PerkUpgrade_SkillRerollCost;
var config float PerkUpgrade_SkillRerollSellPercentage;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.PerkUpgrade_PerkUpgrades.length = 10;
		default.PerkUpgrade_PerkUpgrades[0] = "ZedternalReborn.WMUpgrade_Perk_Berserker";
		default.PerkUpgrade_PerkUpgrades[1] = "ZedternalReborn.WMUpgrade_Perk_Commando";
		default.PerkUpgrade_PerkUpgrades[2] = "ZedternalReborn.WMUpgrade_Perk_Demolitionist";
		default.PerkUpgrade_PerkUpgrades[3] = "ZedternalReborn.WMUpgrade_Perk_FieldMedic";
		default.PerkUpgrade_PerkUpgrades[4] = "ZedternalReborn.WMUpgrade_Perk_SWAT";
		default.PerkUpgrade_PerkUpgrades[5] = "ZedternalReborn.WMUpgrade_Perk_Gunslinger";
		default.PerkUpgrade_PerkUpgrades[6] = "ZedternalReborn.WMUpgrade_Perk_Sharpshooter";
		default.PerkUpgrade_PerkUpgrades[7] = "ZedternalReborn.WMUpgrade_Perk_Support";
		default.PerkUpgrade_PerkUpgrades[8] = "ZedternalReborn.WMUpgrade_Perk_FireBug";
		default.PerkUpgrade_PerkUpgrades[9] = "ZedternalReborn.WMUpgrade_Perk_Survivalist";

		default.PerkUpgrade_FixedPerkUpgrades.length = 0;

		default.PerkUpgrade_NbAvailablePerks = 10;

		default.PerkUpgrade_Price[0] = 500;
		default.PerkUpgrade_Price[1] = 600;
		default.PerkUpgrade_Price[2] = 750;
		default.PerkUpgrade_Price[3] = 1000;
		default.PerkUpgrade_Price[4] = 1250;
		default.PerkUpgrade_Price[5] = 1500;
	}

	if (default.MODEVERSION < 8)
	{
		default.PerkUpgrade_bAllowSkillReroll = True;
		default.PerkUpgrade_SkillRerollCost.BasePrice = 400;
		default.PerkUpgrade_SkillRerollCost.NextRerollMultiplier = 2.0f;
		default.PerkUpgrade_SkillRerollSellPercentage = 0.5f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.currentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
}
