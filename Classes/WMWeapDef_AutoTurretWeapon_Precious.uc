class WMWeapDef_AutoTurretWeapon_Precious extends KFWeapDef_AutoTurretWeapon
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AutoTurretWeapon";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName ~= "ItemName")
		return Chr(8471) @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AutoTurretWeapon_Precious"
	Name="Default__WMWeapDef_AutoTurretWeapon_Precious"
}
