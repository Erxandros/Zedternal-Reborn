class WMWeapDef_MosinNagant_Precious extends KFWeapDef_MosinNagant
	abstract;

const SHORT_ITEM_NAME = "Mosin Nagant";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_MosinNagant";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_MosinNagant_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=95 //40% more per bullet (round up)
	Name="Default__KFWeapDef_MosinNagant_Precious"
}
