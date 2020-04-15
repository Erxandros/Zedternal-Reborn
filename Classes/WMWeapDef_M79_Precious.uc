class WMWeapDef_M79_Precious extends KFWeapDef_M79
	abstract;

const SHORT_ITEM_NAME = "M79";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GrenadeLauncher_M79";




static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'Zedternal.WMWeaponPrecious_Helper'.static.GetItemNameVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}





defaultproperties
{
   WeaponClassPath="Zedternal.WMWeap_GrenadeLauncher_M79_Precious"
   BuyPrice=2000
   AmmoPricePerMag=30
   Name="Default__KFWeapDef_M79_Precious"
}
