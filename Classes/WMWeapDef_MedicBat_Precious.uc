class WMWeapDef_MedicBat_Precious extends KFWeapDef_MedicBat
	abstract;

const SHORT_ITEM_NAME = "Hemoclobber";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_MedicBat";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_MedicBat_Precious"
	BuyPrice=2400 //2x
	AmmoPricePerMag=158 //40% more per bullet (round up)
	Name="Default__WMWeapDef_MedicBat_Precious"
}
