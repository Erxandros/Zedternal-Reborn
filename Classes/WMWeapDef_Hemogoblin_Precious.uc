class WMWeapDef_Hemogoblin_Precious extends KFWeapDef_Hemogoblin
	abstract;

const SHORT_ITEM_NAME = "Hemogoblin";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_Hemogoblin";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_Hemogoblin_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=66 //40% more per bullet
	Name="Default__KFWeapDef_Hemogoblin_Precious"
}
