class WMWeapDef_G18_Precious extends KFWeapDef_G18
	abstract;

const SHORT_ITEM_NAME = "Shield & Glock";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_G18";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_G18_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=51 //40% more per bullet (round up)
	Name="Default__KFWeapDef_G18_Precious"
}
