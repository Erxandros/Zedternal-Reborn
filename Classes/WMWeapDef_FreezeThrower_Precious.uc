class WMWeapDef_FreezeThrower_Precious extends KFWeapDef_FreezeThrower
	abstract;

const SHORT_ITEM_NAME = "FreezeThrower";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Ice_FreezeThrower";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Ice_FreezeThrower_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=95 //40% more per fuel
	Name="Default__KFWeapDef_FreezeThrower_Precious"
}
