class WMWeapDef_SW500Dual_HRG_Precious extends KFWeapDef_SW500Dual_HRG
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Revolver_DualBuckshot";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Revolver_DualBuckshot_Precious"
	BuyPrice=2200
	AmmoPricePerMag=118
	Name="Default__WMWeapDef_SW500Dual_HRG_Precious"
}
