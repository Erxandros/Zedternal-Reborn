class WMWeapDef_MB500_Precious extends KFWeapDef_MB500
	abstract;

const SHORT_ITEM_NAME = "SG 500";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_MB500";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_MB500_Precious"
	BuyPrice=400 //2x
	AmmoPricePerMag=63 //40% more per bullet
	Name="Default__WMWeapDef_MB500_Precious"
}
