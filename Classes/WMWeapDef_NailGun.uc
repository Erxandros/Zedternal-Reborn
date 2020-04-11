class WMWeapDef_Nailgun extends KFWeapDef_Nailgun
	abstract;

const SHORT_ITEM_NAME = "Nailgun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_Nailgun";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	return Localize(Strings[1], KeyName, Strings[0]);
}

DefaultProperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_Nailgun"
}
