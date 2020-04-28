class WMWeapDef_SW500Dual_HRG_Precious extends KFWeapDef_SW500Dual_HRG
	abstract;

const SHORT_ITEM_NAME = "Dual Buckshot";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Revolver_DualBuckshot";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Revolver_DualBuckshot_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=96 //40% more per bullet
	Name="Default__KFWeapDef_SW500Dual_HRG_Precious"
}
