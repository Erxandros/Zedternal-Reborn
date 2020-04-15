class WMWeapDef_HK_UMP_Precious extends KFWeapDef_HK_UMP
	abstract;

const SHORT_ITEM_NAME = "HK-UMP";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_HK_UMP";




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
   WeaponClassPath="Zedternal.WMWeap_SMG_HK_UMP_Precious"
   BuyPrice=2000
   AmmoPricePerMag=76
   Name="Default__KFWeapDef_HK_UMP_Precious"
}
