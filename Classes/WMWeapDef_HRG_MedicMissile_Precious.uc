class WMWeapDef_HRG_MedicMissile_Precious extends KFWeapDef_HRG_MedicMissile
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_MedicMissile";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_MedicMissile_Precious"
	BuyPrice=3200
	AmmoPricePerMag=70
	Name="Default__WMWeapDef_HRG_MedicMissile_Precious"
}
