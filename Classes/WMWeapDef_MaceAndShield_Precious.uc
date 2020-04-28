class WMWeapDef_MaceAndShield_Precious extends KFWeapDef_MaceAndShield
	abstract;

const SHORT_ITEM_NAME = "BoneCrusher";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_MaceAndShield";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_MaceAndShield_Precious"
	BuyPrice=3200 //2x
	Name="Default__WMWeapDef_MaceAndShield_Precious"
}
