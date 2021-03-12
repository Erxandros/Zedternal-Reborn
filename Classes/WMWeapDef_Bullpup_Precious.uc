class WMWeapDef_Bullpup_Precious extends KFWeapDef_Bullpup
	abstract;

const SHORT_ITEM_NAME = "Bullpup";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_Bullpup";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_Bullpup_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=68 //40% more per bullet (round up)
	Name="Default__WMWeapDef_Bullpup_Precious"
}
