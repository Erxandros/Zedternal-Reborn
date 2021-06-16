class WMWeapDef_FAMAS_Precious extends KFWeapDef_FAMAS
	abstract;

const SHORT_ITEM_NAME = "FAMAS";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_FAMAS";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_FAMAS_Precious"
	BuyPrice=2400 //2x
	AmmoPricePerMag=53 //40% more per bullet (round up)
	SecondaryAmmoMagPrice=32 //40% more per bullet (round up)
	SecondaryAmmoMagSize=9 //50% increase
	Name="Default__WMWeapDef_FAMAS_Precious"
}
