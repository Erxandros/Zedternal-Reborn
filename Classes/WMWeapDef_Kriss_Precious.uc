class WMWeapDef_Kriss_Precious extends KFWeapDef_Kriss
	abstract;

const SHORT_ITEM_NAME = "Kriss";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_Kriss";




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
   WeaponClassPath="Zedternal.WMWeap_SMG_Kriss_Precious"
   BuyPrice=2000
   AmmoPricePerMag=40
   Name="Default__KFWeapDef_Kriss_Precious"
}
