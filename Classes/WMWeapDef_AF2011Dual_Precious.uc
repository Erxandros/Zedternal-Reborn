class WMWeapDef_AF2011Dual_Precious extends KFWeapDef_AF2011Dual
	abstract;

const SHORT_ITEM_NAME = "Dual AF2011";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualAF2011";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualAF2011_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=114 //40% more per bullet
	Name="Default__WMWeapDef_AF2011Dual_Precious"
}
