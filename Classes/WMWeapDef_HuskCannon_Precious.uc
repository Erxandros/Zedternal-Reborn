class WMWeapDef_HuskCannon_Precious extends KFWeapDef_HuskCannon
	abstract;

const SHORT_ITEM_NAME = "HuskCannon";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HuskCannon";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HuskCannon_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=263 //40% more per fuel
	Name="Default__KFWeapDef_HuskCannon_Precious"
}
