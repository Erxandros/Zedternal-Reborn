class WMWeapDef_SW500_HRG_Precious extends KFWeapDef_SW500_HRG
	abstract;

const SHORT_ITEM_NAME = "HRG Buckshot";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Revolver_Buckshot";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Revolver_Buckshot_Precious"
	BuyPrice=1100 //2x
	AmmoPricePerMag=48 //40% more per bullet (round up)
	Name="Default__WMWeapDef_SW500_HRG_Precious"
}
