class WMWeapDef_HRG_Kaboomstick_Precious extends KFWeapDef_HRG_Kaboomstick
	abstract;

const SHORT_ITEM_NAME = "Kaboomstick";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_HRG_Kaboomstick";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_HRG_Kaboomstick_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=32 //40% more per bullet (round up)
	Name="Default__WMWeapDef_HRG_Kaboomstick_Precious"
}
