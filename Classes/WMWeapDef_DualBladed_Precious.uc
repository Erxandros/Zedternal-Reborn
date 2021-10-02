class WMWeapDef_DualBladed_Precious extends KFWeapDef_DualBladed
	abstract;

const SHORT_ITEM_NAME = "Dual Piranhas";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualBladed";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualBladed_Precious"
	BuyPrice=2400 //2x
	AmmoPricePerMag=160 //40% more per blade (round up)
	Name="Default__WMWeapDef_DualBladed_Precious"
}
