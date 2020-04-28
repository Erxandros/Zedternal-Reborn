class WMWeapDef_AR15_Precious extends KFWeapDef_AR15
	abstract;

const SHORT_ITEM_NAME = "AR-15 Varmint";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_AR15";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_AR15_Precious"
	BuyPrice=400 //2x
	AmmoPricePerMag=42 //40% more per bullet
	Name="Default__KFWeapDef_AR15_Precious"
}
