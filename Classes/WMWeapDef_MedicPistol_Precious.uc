class WMWeapDef_MedicPistol_Precious extends KFWeapDef_MedicPistol
	abstract;

const SHORT_ITEM_NAME = "HMTech-101";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_Medic";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_Medic_Precious"
	BuyPrice=400 //2x
	AmmoPricePerMag=22 //40% more per bullet (round up)
	Name="Default__KFWeapDef_MedicPistol_Precious"
}
