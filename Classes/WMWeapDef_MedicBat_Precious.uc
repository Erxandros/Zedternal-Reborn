class WMWeapDef_MedicBat_Precious extends KFWeapDef_MedicBat
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_MedicBat";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_MedicBat_Precious"
	BuyPrice=2400
	AmmoPricePerMag=210
	Name="Default__WMWeapDef_MedicBat_Precious"
}
