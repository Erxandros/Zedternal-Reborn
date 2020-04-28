class WMWeapDef_MedicRifleGrenadeLauncher_Precious extends KFWeapDef_MedicRifleGrenadeLauncher
	abstract;

const SHORT_ITEM_NAME = "HMTech-501";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_MedicRifleGrenadeLauncher";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious"
	BuyPrice=4000 //2x
	AmmoPricePerMag=99 //40% more per bullet (round up)
	SecondaryAmmoMagSize=2 //2x
	SecondaryAmmoMagPrice=76 //40% more per grenade (round up)
	Name="Default__WMWeapDef_MedicRifleGrenadeLauncher_Precious"
}
