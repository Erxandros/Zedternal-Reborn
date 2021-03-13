class WMWeapDef_GravityImploder_Precious extends KFWeapDef_GravityImploder
	abstract;

const SHORT_ITEM_NAME = "Grav-Imploder";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GravityImploder";

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
	WeaponClassPath="ZedternalReborn.WMWeap_GravityImploder_Precious"
	BuyPrice=4000 //2x
	AmmoPricePerMag=147 //40% more per round
	Name="Default__WMWeapDef_GravityImploder_Precious"
}
