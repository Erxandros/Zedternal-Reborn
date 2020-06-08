class WMWeapDef_Pistol_G18C_Precious extends KFWeapDef_Pistol_G18C
	abstract;

const SHORT_ITEM_NAME = "G18c";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_G18C";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_G18C_Precious"
	BuyPrice=1500 //2x
	AmmoPricePerMag=81 //40% more per bullet (round up)
	Name="Default__WMWeapDef_Pistol_G18C_Precious"
}
