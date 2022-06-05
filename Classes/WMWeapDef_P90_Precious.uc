class WMWeapDef_P90_Precious extends KFWeapDef_P90
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_P90";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_P90_Precious"
	BuyPrice=2200
	AmmoPricePerMag=112
	Name="Default__WMWeapDef_P90_Precious"
}
