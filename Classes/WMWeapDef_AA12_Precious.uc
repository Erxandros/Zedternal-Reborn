class WMWeapDef_AA12_Precious extends KFWeapDef_AA12
	abstract;

const SHORT_ITEM_NAME = "AA12";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_AA12";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_AA12_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=173 //40% more per bullet
	Name="Default__KFWeapDef_AA12_Precious"
}
