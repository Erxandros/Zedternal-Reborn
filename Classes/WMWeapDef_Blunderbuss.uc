class WMWeapDef_Blunderbuss extends KFWeapDef_Blunderbuss
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_Blunderbuss";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_Blunderbuss"
	Name="Default__WMWeapDef_Blunderbuss"
}
