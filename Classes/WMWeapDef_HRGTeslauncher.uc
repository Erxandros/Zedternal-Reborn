class WMWeapDef_HRGTeslauncher extends KFWeapDef_HRGTeslauncher
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_HRGTeslauncher";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_HRGTeslauncher"
	Name="Default__WMWeapDef_HRGTeslauncher"
}
