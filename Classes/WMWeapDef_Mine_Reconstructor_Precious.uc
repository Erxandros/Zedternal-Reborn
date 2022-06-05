class WMWeapDef_Mine_Reconstructor_Precious extends KFWeapDef_Mine_Reconstructor
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Mine_Reconstructor";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Mine_Reconstructor_Precious"
	BuyPrice=2400
	AmmoPricePerMag=101
	Name="Default__WMWeapDef_Mine_Reconstructor_Precious"
}
