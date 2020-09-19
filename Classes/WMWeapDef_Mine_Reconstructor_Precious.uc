class WMWeapDef_Mine_Reconstructor_Precious extends KFWeapDef_Mine_Reconstructor
	abstract;

const SHORT_ITEM_NAME = "Mine Launcher";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Mine_Reconstructor";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Mine_Reconstructor_Precious"
	BuyPrice=2400 //2x
	AmmoPricePerMag=76 //40% more per mine (round up)
	Name="Default__WMWeapDef_Mine_Reconstructor_Precious"
}
