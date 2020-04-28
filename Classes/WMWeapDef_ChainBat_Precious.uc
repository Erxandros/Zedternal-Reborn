class WMWeapDef_ChainBat_Precious extends KFWeapDef_ChainBat
	abstract;

const SHORT_ITEM_NAME = "Redeemer";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_ChainBat";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_ChainBat_Precious"
	BuyPrice=1700 //2x
	Name="Default__WMWeapDef_ChainBat_Precious"
}
