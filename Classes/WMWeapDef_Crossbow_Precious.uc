class WMWeapDef_Crossbow_Precious extends KFWeapDef_Crossbow
	abstract;

const SHORT_ITEM_NAME = "Crossbow";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Bow_Crossbow";




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
   WeaponClassPath="Zedternal.WMWeap_Bow_Crossbow_Precious"
   BuyPrice=2000
   AmmoPricePerMag=20
   Name="Default__KFWeapDef_Crossbow_Precious"
}
