class WMWeapDef_M32_Precious extends KFWeapDef_M32
	abstract;

const SHORT_ITEM_NAME = "M32";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GrenadeLauncher_M32";

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
	WeaponClassPath="ZedternalReborn.WMWeap_GrenadeLauncher_M32_Precious"
	BuyPrice=4000 //2x
	AmmoPricePerMag=141 //40% more per grenade (round up)
	Name="Default__KFWeapDef_M32_Precious"
}
