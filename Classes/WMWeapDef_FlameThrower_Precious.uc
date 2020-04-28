class WMWeapDef_FlameThrower_Precious extends KFWeapDef_FlameThrower
	abstract;

const SHORT_ITEM_NAME = "Flamethrower";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Flame_Flamethrower";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Flame_Flamethrower_Precious"
	BuyPrice=2400 //2x
	AmmoPricePerMag=175 //40% more per fuel
	Name="Default__WMWeapDef_FlameThrower_Precious"
}
