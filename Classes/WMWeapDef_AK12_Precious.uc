class WMWeapDef_AK12_Precious extends KFWeapDef_AK12
	abstract;

const SHORT_ITEM_NAME = "AK-12";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_AK12";




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
   WeaponClassPath="Zedternal.WMWeap_AssaultRifle_AK12_Precious"
   BuyPrice=2000
   AmmoPricePerMag=78
   Name="Default__KFWeapDef_AK12_Precious"
}
