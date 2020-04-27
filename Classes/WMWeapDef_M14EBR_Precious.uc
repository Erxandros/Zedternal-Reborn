class WMWeapDef_M14EBR_Precious extends KFWeapDef_M14EBR
	abstract;

const SHORT_ITEM_NAME = "M14EBR";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_M14EBR";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_M14EBR_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=112 //40% more per bullet
	Name="Default__KFWeapDef_M14EBR_Precious"
}
