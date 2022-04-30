class WMWeapDef_SW500_HRG_Precious extends KFWeapDef_SW500_HRG
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Revolver_Buckshot";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Revolver_Buckshot_Precious"
	BuyPrice=1100
	AmmoPricePerMag=48
	Name="Default__WMWeapDef_SW500_HRG_Precious"
}
