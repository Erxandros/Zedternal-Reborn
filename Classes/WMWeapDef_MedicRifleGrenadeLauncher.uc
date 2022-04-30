class WMWeapDef_MedicRifleGrenadeLauncher extends KFWeapDef_MedicRifleGrenadeLauncher
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_MedicRifleGrenadeLauncher";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_MedicRifleGrenadeLauncher"
	Name="Default__WMWeapDef_MedicRifleGrenadeLauncher"
}
