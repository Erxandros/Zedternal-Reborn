class WMWeapDef_CaulkBurn_Precious extends KFWeapDef_CaulkBurn
	abstract;

const SHORT_ITEM_NAME = "CaulkBurn";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Flame_CaulkBurn";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Flame_CaulkBurn_Precious"
	BuyPrice=400 //2x
	AmmoPricePerMag=42 //40% more per fuel
	Name="Default__KFWeapDef_CaulkBurn_Precious"
}
