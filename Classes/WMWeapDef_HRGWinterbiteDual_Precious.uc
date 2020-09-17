class WMWeapDef_HRGWinterbiteDual_Precious extends KFWeapDef_HRGWinterbiteDual
	abstract;

const SHORT_ITEM_NAME = "Dual Winters";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualHRGWinterbite";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualHRGWinterbite_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=56 //40% more per bullet (round up)
	Name="Default__WMWeapDef_HRGWinterbiteDual_Precious"
}
