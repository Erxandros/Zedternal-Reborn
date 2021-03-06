class WMWeapDef_Mac10_Precious extends KFWeapDef_Mac10
	abstract;

const SHORT_ITEM_NAME = "Mac 10";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_Mac10";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_Mac10_Precious"
	BuyPrice=1800 //2x
	AmmoPricePerMag=68 //40% more per bullet
	Name="Default__WMWeapDef_Mac10_Precious"
}
