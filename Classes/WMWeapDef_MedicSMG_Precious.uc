class WMWeapDef_MedicSMG_Precious extends KFWeapDef_MedicSMG
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_Medic";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_Medic_Precious"
	BuyPrice=1300
	AmmoPricePerMag=45
	Name="Default__WMWeapDef_MedicSMG_Precious"
}
