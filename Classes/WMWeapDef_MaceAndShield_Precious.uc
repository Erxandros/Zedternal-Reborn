class WMWeapDef_MaceAndShield_Precious extends KFWeapDef_MaceAndShield
	abstract;

const SHORT_ITEM_NAME = "BoneCrusher";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_MaceAndShield";




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
   WeaponClassPath="ZedternalReborn.WMWeap_Blunt_MaceAndShield_Precious"
   BuyPrice=2000
   Name="Default__KFWeapDef_MaceAndShield_Precious"
}
