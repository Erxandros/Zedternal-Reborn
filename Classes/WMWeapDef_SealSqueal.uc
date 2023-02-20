class WMWeapDef_SealSqueal extends KFWeapDef_SealSqueal
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_SealSqueal";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_SealSqueal"
	Name="Default__WMWeapDef_SealSqueal"
}
