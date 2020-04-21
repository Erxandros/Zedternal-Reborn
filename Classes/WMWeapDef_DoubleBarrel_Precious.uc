class WMWeapDef_DoubleBarrel_Precious extends KFWeapDef_DoubleBarrel
	abstract;

const SHORT_ITEM_NAME = "Double Barrel";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_DoubleBarrel";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_DoubleBarrel_Precious"
	BuyPrice=1500 //2x
	AmmoPricePerMag=28 //40% more per bullet
	Name="Default__KFWeapDef_DoubleBarrel_Precious"
}
