class WMWeapDef_M99_Precious extends KFWeapDef_M99
	abstract;

const SHORT_ITEM_NAME = "M99 AMR";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_M99";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_M99_Precious"
	BuyPrice=5000 //2x
	AmmoPricePerMag=107 //40% more per bullet (round up)
	Name="Default__WMWeapDef_M99_Precious"
}
