class WMWeapDef_HRGTeslauncher_Precious extends KFWeapDef_HRGTeslauncher
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_HRGTeslauncher";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_HRGTeslauncher_Precious"
	BuyPrice=3000
	AmmoPricePerMag=131
	SecondaryAmmoMagSize=2
	SecondaryAmmoMagPrice=42
	Name="Default__WMWeapDef_HRGTeslauncher_Precious"
}
