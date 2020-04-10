class WMWeapDef_Flamethrower_Precious extends KFWeapDef_Flamethrower
	abstract;

const SHORT_ITEM_NAME = "Flamethrower";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Flame_Flamethrower";




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
   WeaponClassPath="ZedternalReborn.WMWeap_Flame_Flamethrower_Precious"
   BuyPrice=2000
   AmmoPricePerMag=100
   Name="Default__KFWeapDef_Flamethrower_Precious"
}
