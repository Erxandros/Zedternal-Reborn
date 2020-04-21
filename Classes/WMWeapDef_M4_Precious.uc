class WMWeapDef_M4_Precious extends KFWeapDef_M4
	abstract;

const SHORT_ITEM_NAME = "M4";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_M4";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_M4_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=80 //40% more per bullet
	Name="Default__KFWeapDef_M4_Precious"
}
