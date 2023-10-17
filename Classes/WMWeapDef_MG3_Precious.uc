class WMWeapDef_MG3_Precious extends KFWeapDef_MG3
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_LMG_MG3";

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
	WeaponClassPath="ZedternalReborn.WMWeap_LMG_MG3_Precious"
	BuyPrice=4000
	AmmoPricePerMag=196
	Name="Default__WMWeapDef_MG3_Precious"
}
