class WMWeapDef_MP5RAS_Precious extends KFWeapDef_MP5RAS
	abstract;

const SHORT_ITEM_NAME = "MP5RAS";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_MP5RAS";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_MP5RAS_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=59 //40% more per bullet
	Name="Default__KFWeapDef_MP5RAS_Precious"
}
