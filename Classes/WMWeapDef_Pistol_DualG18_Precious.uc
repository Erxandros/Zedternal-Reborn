class WMWeapDef_Pistol_DualG18_Precious extends KFWeapDef_Pistol_DualG18
	abstract;

const SHORT_ITEM_NAME = "Dual G18c";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualG18";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualG18_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=162 //40% more per bullet (round up)
	Name="Default__WMWeapDef_Pistol_DualG18_Precious"
}
