class WMWeapDef_LazerCutter_Precious extends KFWeapDef_LazerCutter
	abstract;

const SHORT_ITEM_NAME = "Killerwatt";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_LazerCutter";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_LazerCutter_Precious"
	BuyPrice=4000 //2x
	AmmoPricePerMag=177 //40% more per bullet (round up)
	Name="Default__WMWeapDef_LazerCutter_Precious"
}
