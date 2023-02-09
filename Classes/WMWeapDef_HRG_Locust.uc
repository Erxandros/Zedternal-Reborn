class WMWeapDef_HRG_Locust extends KFWeapDef_HRG_Locust
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Locust";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Locust"
	Name="Default__WMWeapDef_HRG_Locust"
}
