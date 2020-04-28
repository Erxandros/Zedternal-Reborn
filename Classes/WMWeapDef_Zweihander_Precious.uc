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
		return class'ZedternalReborn.WMCustomWeapon_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Edged_Zweihander_Precious"
	BuyPrice=2600
	Name="Default__WMWeapDef_Zweihander_Precious"
}
