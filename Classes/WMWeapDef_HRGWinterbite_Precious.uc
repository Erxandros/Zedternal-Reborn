class WMWeapDef_HRGWinterbite_Precious extends KFWeapDef_HRGWinterbite
	abstract;

const SHORT_ITEM_NAME = "HRG Winterbite";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_HRGWinterbite";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_HRGWinterbite_Precious"
	BuyPrice=650 //2x
	AmmoPricePerMag=26 //40% more per bullet (round up)
	Name="Default__WMWeapDef_HRGWinterbite_Precious"
}
