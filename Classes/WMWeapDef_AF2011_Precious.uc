class WMWeapDef_AF2011_Precious extends KFWeapDef_AF2011
	abstract;

const SHORT_ITEM_NAME = "AF2011";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_AF2011";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNameVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_AF2011_Precious"
	BuyPrice=1500 //2x
	AmmoPricePerMag=57 //40% more per bullet
	Name="Default__KFWeapDef_AF2011_Precious"
}
