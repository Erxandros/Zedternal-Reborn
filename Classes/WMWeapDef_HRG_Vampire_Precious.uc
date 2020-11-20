class WMWeapDef_HRG_Vampire_Precious extends KFWeapDef_HRG_Vampire
	abstract;

const SHORT_ITEM_NAME = "HRG Vampire";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Vampire";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMCustomWeapon_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

DefaultProperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Vampire_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=126 //40% more per round
	Name="Default__WMWeapDef_HRG_Vampire_Precious"
}
