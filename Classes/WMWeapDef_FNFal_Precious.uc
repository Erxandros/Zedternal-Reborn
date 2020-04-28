class WMWeapDef_FNFal_Precious extends KFWeapDef_FNFal
	abstract;

const SHORT_ITEM_NAME = "FN FAL";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_FNFal";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_FNFal_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=99 //40% more per bullet (round up)
	Name="Default__KFWeapDef_FNFal_Precious"
}
