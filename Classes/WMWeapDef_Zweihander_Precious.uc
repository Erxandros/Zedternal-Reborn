class WMWeapDef_Zweihander_Precious extends KFWeapDef_Zweihander
	abstract;

const SHORT_ITEM_NAME = "Zweihander";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Edged_Zweihander";




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
   WeaponClassPath="Zedternal.WMWeap_Edged_Zweihander_Precious"
   BuyPrice=2000
   Name="Default__KFWeapDef_Zweihander_Precious"
}
