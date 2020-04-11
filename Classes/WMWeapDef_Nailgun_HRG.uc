class WMWeapDef_Nailgun_HRG extends KFWeapDef_Nailgun_HRG
	abstract;

const SHORT_ITEM_NAME = "Nailgun_HRG";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Nailgun";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	return Localize(Strings[1], KeyName, Strings[0]);
}

DefaultProperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Nailgun"
}