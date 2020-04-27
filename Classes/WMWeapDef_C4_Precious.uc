class WMWeapDef_C4_Precious extends KFWeapDef_C4
	abstract;

const SHORT_ITEM_NAME = "C4";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Thrown_C4";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Thrown_C4_Precious"
	BuyPrice=600 //2x
	AmmoPricePerMag=140 //40% more per bomb
	Name="Default__KFWeapDef_C4_Precious"
}
