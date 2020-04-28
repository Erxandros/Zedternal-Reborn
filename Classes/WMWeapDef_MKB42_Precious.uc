class WMWeapDef_MKB42_Precious extends KFWeapDef_MKB42
	abstract;

const SHORT_ITEM_NAME = "MKb.42(H)";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_MKB42";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_MKB42_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=105 //40% more per bullet
	Name="Default__KFWeapDef_MKB42_Precious"
}
