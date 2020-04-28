class WMWeapDef_ElephantGun_Precious extends KFWeapDef_ElephantGun
	abstract;

const SHORT_ITEM_NAME = "Doomstick";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_ElephantGun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_ElephantGun_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=53 //40% more per bullet (round up)
	Name="Default__WMWeapDef_ElephantGun_Precious"
}
