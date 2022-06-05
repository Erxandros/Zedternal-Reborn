class WMWeapDef_HK_UMP_Precious extends KFWeapDef_HK_UMP
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_HK_UMP";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_HK_UMP_Precious"
	BuyPrice=2400
	AmmoPricePerMag=101
	Name="Default__WMWeapDef_HK_UMP_Precious"
}
