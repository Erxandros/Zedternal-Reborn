class WMWeapDef_M79_Precious extends KFWeapDef_M79
	abstract;

const SHORT_ITEM_NAME = "M79";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GrenadeLauncher_M79";

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
	WeaponClassPath="ZedternalReborn.WMWeap_GrenadeLauncher_M79_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=37 //40% more per grenade
	Name="Default__KFWeapDef_M79_Precious"
}
