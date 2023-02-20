class WMWeapDef_GravityImploder extends KFWeapDef_GravityImploder
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GravityImploder";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_GravityImploder"
	Name="Default__WMWeapDef_GravityImploder"
}
