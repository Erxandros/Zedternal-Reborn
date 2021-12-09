class WMWeapDef_Doshinegun_Precious extends KFWeapDef_Doshinegun
	abstract;

const SHORT_ITEM_NAME = "Doshinegun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_Doshinegun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_Doshinegun_Precious"
	BuyPrice=1200 //2x
	Name="Default__WMWeapDef_Doshinegun_Precious"
}
