class WMWeapDef_Minigun_Precious extends KFWeapDef_Minigun
	abstract;

const SHORT_ITEM_NAME = "Minigun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Minigun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Minigun_Precious"
	BuyPrice=4000 //2x
	AmmoPricePerMag=189 //40% more per bullet
	Name="Default__WMWeapDef_Minigun_Precious"
}
