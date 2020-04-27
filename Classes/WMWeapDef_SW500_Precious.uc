class WMWeapDef_SW500_Precious extends KFWeapDef_SW500
	abstract;

const SHORT_ITEM_NAME = "SW500";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Revolver_SW500";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Revolver_SW500_Precious"
	BuyPrice=1500 //2x
	AmmoPricePerMag=56 //40% more per bullet
	Name="Default__KFWeapDef_SW500_Precious"
}
