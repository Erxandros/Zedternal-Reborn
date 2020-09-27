class WMWeapDef_HRGIncendiaryRifle extends KFWeapDef_HRGIncendiaryRifle
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_HRGIncendiaryRifle";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_HRGIncendiaryRifle"
	Name="Default__WMWeapDef_HRGIncendiaryRifle"
}
