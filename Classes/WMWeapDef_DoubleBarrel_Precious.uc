class WMWeapDef_DoubleBarrel_Precious extends KFWeapDef_DoubleBarrel
	abstract;

const SHORT_ITEM_NAME = "Double Barrel";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_DoubleBarrel";




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
   WeaponClassPath="Zedternal.WMWeap_Shotgun_DoubleBarrel_Precious"
   BuyPrice=2000
   AmmoPricePerMag=15
   Name="Default__KFWeapDef_DoubleBarrel_Precious"
}
