class WMWeapDef_AF2011Dual_Precious extends KFWeapDef_AF2011Dual
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualAF2011";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualAF2011_Precious"
	BuyPrice=3000
	AmmoPricePerMag=114
	Name="Default__WMWeapDef_AF2011Dual_Precious"
}
