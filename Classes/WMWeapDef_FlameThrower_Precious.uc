class WMWeapDef_FlameThrower_Precious extends KFWeapDef_FlameThrower
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Flame_Flamethrower";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if(KeyName ~= "ItemName")
		return "[P]" @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Flame_Flamethrower_Precious"
	BuyPrice=2400
	AmmoPricePerMag=175
	Name="Default__WMWeapDef_FlameThrower_Precious"
}
