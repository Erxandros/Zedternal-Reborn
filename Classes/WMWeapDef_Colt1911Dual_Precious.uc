class WMWeapDef_Colt1911Dual_Precious extends KFWeapDef_Colt1911Dual
	abstract;

const SHORT_ITEM_NAME = "Dual Colt1911";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualColt1911";




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
   WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualColt1911_Precious"
   BuyPrice=2000
   AmmoPricePerMag=88
   Name="Default__KFWeapDef_Colt1911Dual_Precious"
}
