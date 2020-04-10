class WMWeapDef_Katana_Precious extends KFWeapDef_Katana
	abstract;

const SHORT_ITEM_NAME = "Katana";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Edged_Katana";




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
   WeaponClassPath="ZedternalReborn.WMWeap_Edged_Katana_Precious"
   BuyPrice=2000
   Name="Default__KFWeapDef_Katana_Precious"
}
