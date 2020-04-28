class WMWeapDef_Crossbow_Precious extends KFWeapDef_Crossbow
	abstract;

const SHORT_ITEM_NAME = "Crossbow";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Bow_Crossbow";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Bow_Crossbow_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=31 //40% more per arrow
	Name="Default__WMWeapDef_Crossbow_Precious"
}
