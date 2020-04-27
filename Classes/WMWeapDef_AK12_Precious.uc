class WMWeapDef_AK12_Precious extends KFWeapDef_AK12
	abstract;

const SHORT_ITEM_NAME = "AK-12";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_AK12";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_AK12_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=84 //40% more per bullet
	Name="Default__KFWeapDef_AK12_Precious"
}
