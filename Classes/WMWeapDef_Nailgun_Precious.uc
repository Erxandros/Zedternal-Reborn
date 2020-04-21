class WMWeapDef_Nailgun_Precious extends KFWeapDef_Nailgun
	abstract;

const SHORT_ITEM_NAME = "Nailgun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_Nailgun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_Nailgun_Precious"
	BuyPrice=1500 //2x
	AmmoPricePerMag=82 //40% more per nail
	Name="Default__KFWeapDef_Nailgun_Precious"
}
