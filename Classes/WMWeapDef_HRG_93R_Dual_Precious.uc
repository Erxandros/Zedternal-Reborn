class WMWeapDef_HRG_93R_Dual_Precious extends KFWeapDef_HRG_93R_Dual
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_93R_Dual";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_93R_Dual_Precious"
	BuyPrice=600
	AmmoPricePerMag=56
	Name="Default__WMWeapDef_HRG_93R_Dual_Precious"
}
