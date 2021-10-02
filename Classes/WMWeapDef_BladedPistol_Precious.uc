class WMWeapDef_BladedPistol_Precious extends KFWeapDef_BladedPistol
	abstract;

const SHORT_ITEM_NAME = "Piranha";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_Bladed";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_Bladed_Precious"
	BuyPrice=1200 //2x
	AmmoPricePerMag=80 //40% more per blade (round up)
	Name="Default__WMWeapDef_BladedPistol_Precious"
}
