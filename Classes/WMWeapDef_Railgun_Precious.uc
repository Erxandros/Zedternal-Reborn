class WMWeapDef_Railgun_Precious extends KFWeapDef_Railgun
	abstract;

const SHORT_ITEM_NAME = "Railgun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_Railgun";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNameVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_Railgun_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=56 //40% more per bullet
	Name="Default__KFWeapDef_Railgun_Precious"
}
