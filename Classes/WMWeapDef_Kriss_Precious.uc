class WMWeapDef_Kriss_Precious extends KFWeapDef_Kriss
	abstract;

const SHORT_ITEM_NAME = "Kriss";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_Kriss";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_Kriss_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=75 //40% more per bullet
	Name="Default__WMWeapDef_Kriss_Precious"
}
