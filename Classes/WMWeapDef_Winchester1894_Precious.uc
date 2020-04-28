class WMWeapDef_Winchester1894_Precious extends KFWeapDef_Winchester1894
	abstract;

const SHORT_ITEM_NAME = "Winchester";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_Winchester1894";

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

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_Winchester1894_Precious"
	BuyPrice=400 //2x
	AmmoPricePerMag=68 //40% more per bullet (round up)
	Name="Default__WMWeapDef_Winchester1894_Precious"
}
