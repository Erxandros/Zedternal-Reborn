class WMWeapDef_HX25_Precious extends KFWeapDef_HX25
	abstract;

const SHORT_ITEM_NAME = "HX25";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GrenadeLauncher_HX25";

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
	WeaponClassPath="ZedternalReborn.WMWeap_GrenadeLauncher_HX25_Precious"
	BuyPrice=600 //2x
	AmmoPricePerMag=26 //40% more per grenade (round up)
	Name="Default__KFWeapDef_HX25_Precious"
}
