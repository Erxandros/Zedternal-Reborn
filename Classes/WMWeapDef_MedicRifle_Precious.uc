class WMWeapDef_MedicRifle_Precious extends KFWeapDef_MedicRifle
	abstract;

const SHORT_ITEM_NAME = "HMTech-401";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_Medic";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_Medic_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=84 //40% more per bullet
	Name="Default__KFWeapDef_MedicRifle_Precious"
}
