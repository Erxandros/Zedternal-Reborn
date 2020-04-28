class WMWeapDef_Healthrower_HRG_Precious extends KFWeapDef_Healthrower_HRG
	abstract;

const SHORT_ITEM_NAME = "Healthrower";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Healthrower";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Healthrower_Precious"
	BuyPrice=2000 //2x
	AmmoPricePerMag=147 //40% more per fuel
	Name="Default__WMWeapDef_Healthrower_HRG_Precious"
}
