class WMWeapDef_SCAR_Precious extends KFWeapDef_SCAR
	abstract;

const SHORT_ITEM_NAME = "SCAR";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_SCAR";




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
   WeaponClassPath="Zedternal.WMWeap_AssaultRifle_SCAR_Precious"
   BuyPrice=2000
   AmmoPricePerMag=38
   Name="Default__KFWeapDef_SCAR_Precious"
}
