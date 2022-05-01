class WMWeapDef_MedicRifleGrenadeLauncher_Precious extends KFWeapDef_MedicRifleGrenadeLauncher
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_MedicRifleGrenadeLauncher";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName ~= "ItemName")
		return "[P]" @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious"
	BuyPrice=4000
	AmmoPricePerMag=99
	SecondaryAmmoMagSize=2
	SecondaryAmmoMagPrice=76
	Name="Default__WMWeapDef_MedicRifleGrenadeLauncher_Precious"
}
