class WMWeapDef_Deagle_Precious extends KFWeapDef_Deagle
	abstract;

const SHORT_ITEM_NAME = "Deagle";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_Deagle";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNameVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_Deagle_Precious"
	BuyPrice=1100 //2x
	AmmoPricePerMag=47 //40% more per bullet
	Name="Default__KFWeapDef_Deagle_Precious"
}
