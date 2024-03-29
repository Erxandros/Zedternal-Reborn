class WMWeapDef_HRG_Warthog extends KFWeapDef_HRG_Warthog
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Warthog";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Warthog"
	Name="Default__WMWeapDef_HRG_Warthog"
}
