class WMWeapDef_HRG_EMP_ArcGenerator_Precious extends KFWeapDef_HRG_EMP_ArcGenerator
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_EMP_ArcGenerator";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_EMP_ArcGenerator_Precious"
	BuyPrice=3000
	AmmoPricePerMag=231
	Name="Default__WMWeapDef_HRG_EMP_ArcGenerator_Precious"
}
