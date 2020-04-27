class WMWeapDef_RailGun_Precious extends KFWeapDef_RailGun
	abstract;

const SHORT_ITEM_NAME = "RailGun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_RailGun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_RailGun_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=56 //40% more per bullet
	Name="Default__KFWeapDef_RailGun_Precious"
}
