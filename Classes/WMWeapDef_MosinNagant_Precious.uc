class WMWeapDef_MosinNagant_Precious extends KFWeapDef_MosinNagant
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_MosinNagant";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_MosinNagant_Precious"
	BuyPrice=2200
	AmmoPricePerMag=118
	Name="Default__WMWeapDef_MosinNagant_Precious"
}
