class WMWeapDef_Colt1911_Precious extends KFWeapDef_Colt1911
	abstract;

const SHORT_ITEM_NAME = "Colt1911";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_Colt1911";




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
   WeaponClassPath="Zedternal.WMWeap_Pistol_Colt1911_Precious"
   BuyPrice=1000
   AmmoPricePerMag=44
   Name="Default__KFWeapDef_Colt1911_Precious"
}
