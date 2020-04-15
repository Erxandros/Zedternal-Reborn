class WMWeapDef_Stoner63A_Precious extends KFWeapDef_Stoner63A
	abstract;

const SHORT_ITEM_NAME = "Stoner 63A";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_LMG_Stoner63A";




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
   WeaponClassPath="Zedternal.WMWeap_LMG_Stoner63A_Precious"
   BuyPrice=2000
   AmmoPricePerMag=90
   Name="Default__KFWeapDef_Stoner63A_Precious"
}
