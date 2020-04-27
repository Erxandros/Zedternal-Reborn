class WMWeapDef_MedicShotgun_Precious extends KFWeapDef_MedicShotgun
	abstract;

const SHORT_ITEM_NAME = "HMTech-301";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_Medic";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_Medic_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=84 //40% more per bullet
	Name="Default__KFWeapDef_MedicShotgun_Precious"
}
