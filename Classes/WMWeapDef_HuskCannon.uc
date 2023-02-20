class WMWeapDef_HuskCannon extends KFWeapDef_HuskCannon
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HuskCannon";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_HuskCannon"
	Name="Default__WMWeapDef_HuskCannon"
}
