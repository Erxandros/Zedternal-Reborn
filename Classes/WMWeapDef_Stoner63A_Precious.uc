class WMWeapDef_Stoner63A_Precious extends KFWeapDef_Stoner63A
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_LMG_Stoner63A";

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
	WeaponClassPath="ZedternalReborn.WMWeap_LMG_Stoner63A_Precious"
	BuyPrice=3000
	AmmoPricePerMag=196
	Name="Default__WMWeapDef_Stoner63A_Precious"
}
