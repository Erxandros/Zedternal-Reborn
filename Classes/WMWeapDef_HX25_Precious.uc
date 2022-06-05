class WMWeapDef_HX25_Precious extends KFWeapDef_HX25
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_GrenadeLauncher_HX25";

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
	WeaponClassPath="ZedternalReborn.WMWeap_GrenadeLauncher_HX25_Precious"
	BuyPrice=600
	AmmoPricePerMag=26
	Name="Default__WMWeapDef_HX25_Precious"
}
