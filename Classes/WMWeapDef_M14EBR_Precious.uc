class WMWeapDef_M14EBR_Precious extends KFWeapDef_M14EBR
	abstract;

const SHORT_ITEM_NAME = "M14EBR";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_M14EBR";




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
   WeaponClassPath="ZedternalReborn.WMWeap_Rifle_M14EBR_Precious"
   BuyPrice=2000
   AmmoPricePerMag=105
   Name="Default__KFWeapDef_M14EBR_Precious"
}
