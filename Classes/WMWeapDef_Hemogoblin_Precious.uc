class WMWeapDef_Hemogoblin_Precious extends KFWeapDef_Hemogoblin
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_Hemogoblin";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_Hemogoblin_Precious"
	BuyPrice=2200
	AmmoPricePerMag=66
	Name="Default__WMWeapDef_Hemogoblin_Precious"
}
