class WMWeapDef_Mac10_Precious extends KFWeapDef_Mac10
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_Mac10";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_Mac10_Precious"
	BuyPrice=1800
	AmmoPricePerMag=82
	Name="Default__WMWeapDef_Mac10_Precious"
}
