class WMWeapDef_SW500Dual_Precious extends KFWeapDef_SW500Dual
	abstract;

const SHORT_ITEM_NAME = "Dual SW500";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Revolver_DualSW500";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Revolver_DualSW500_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=112 //40% more per bullet
	Name="Default__KFWeapDef_SW500Dual_Precious"
}
