class WMWeapDef_AutoTurret extends KFWeapDef_AutoTurret
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AutoTurret";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AutoTurret"
	Name="Default__WMWeapDef_AutoTurret"
}
