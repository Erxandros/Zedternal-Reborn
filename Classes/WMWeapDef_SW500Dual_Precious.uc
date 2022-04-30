class WMWeapDef_SW500Dual_Precious extends KFWeapDef_SW500Dual
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Revolver_DualSW500";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Revolver_DualSW500_Precious"
	BuyPrice=3000
	AmmoPricePerMag=105
	Name="Default__WMWeapDef_SW500Dual_Precious"
}
