class WMWeapDef_Crovel_Precious extends KFWeapDef_Crovel
	abstract;

const SHORT_ITEM_NAME = "Crovel";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_Crovel";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_Crovel_Precious"
	BuyPrice=400 //2x
	Name="Default__WMWeapDef_Crovel_Precious"
}
