class WMWeapDef_Winchester1894_Precious extends KFWeapDef_Winchester1894
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_Winchester1894";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_Winchester1894_Precious"
	BuyPrice=400
	AmmoPricePerMag=90
	Name="Default__WMWeapDef_Winchester1894_Precious"
}
