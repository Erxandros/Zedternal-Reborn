class WMWeapDef_ChiappaRhino_Precious extends KFWeapDef_ChiappaRhino
	abstract;

const SHORT_ITEM_NAME = "Rhino";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_ChiappaRhino";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_ChiappaRhino_Precious"
	BuyPrice=1100 //2x
	AmmoPricePerMag=36 //40% more per bullet (round up)
	Name="Default__WMWeapDef_ChiappaRhino_Precious"
}
