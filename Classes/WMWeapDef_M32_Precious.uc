class WMWeapDef_M32_Precious extends KFWeapDef_M32
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GrenadeLauncher_M32";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName ~= "ItemName")
		return "[P]" @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_GrenadeLauncher_M32_Precious"
	BuyPrice=4000
	AmmoPricePerMag=141
	Name="Default__WMWeapDef_M32_Precious"
}
