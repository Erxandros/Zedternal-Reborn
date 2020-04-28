class WMWeapDef_MP7_Precious extends KFWeapDef_MP7
	abstract;

const SHORT_ITEM_NAME = "MP7 SMG";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_MP7";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_MP7_Precious"
	BuyPrice=400 //2x
	AmmoPricePerMag=34 //40% more per bullet (round up)
	Name="Default__KFWeapDef_MP7_Precious"
}
