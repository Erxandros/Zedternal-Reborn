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
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_Bullpup_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=63 //40% more per bullet
	Name="Default__KFWeapDef_Bullpup_Precious"
}
