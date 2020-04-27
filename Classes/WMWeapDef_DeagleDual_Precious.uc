class WMWeapDef_DeagleDual_Precious extends KFWeapDef_DeagleDual
	abstract;

const SHORT_ITEM_NAME = "Dual Deagle";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualDeagle";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualDeagle_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=93 //40% more per bullet
	Name="Default__KFWeapDef_DeagleDual_Precious"
}
