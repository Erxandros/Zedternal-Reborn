class WMWeapDef_HRG_BlastBrawlers extends KFWeapDef_HRG_BlastBrawlers
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_BlastBrawlers";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	return Localize(Strings[1], KeyName, Strings[0]);
}

DefaultProperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_BlastBrawlers"
	Name="Default__WMWeapDef_HRG_BlastBrawlers"
}
