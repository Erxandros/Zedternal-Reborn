class WMWeapDef_P90_Precious extends KFWeapDef_P90
	abstract;

const SHORT_ITEM_NAME = "P90";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_P90";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMCustomWeapon_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_P90_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=84 //40% more per bullet
	Name="Default__KFWeapDef_P90_Precious"
}
