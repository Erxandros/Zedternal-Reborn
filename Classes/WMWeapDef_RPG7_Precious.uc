class WMWeapDef_RPG7_Precious extends KFWeapDef_RPG7
	abstract;

const SHORT_ITEM_NAME = "RPG7";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_RPG7";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_RPG7_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=84 //40% more per rocket
	Name="Default__KFWeapDef_RPG7_Precious"
}
