class WMWeapDef_Pistol_DualG18_Precious extends KFWeapDef_Pistol_DualG18
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualG18";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualG18_Precious"
	BuyPrice=3000
	AmmoPricePerMag=213
	Name="Default__WMWeapDef_Pistol_DualG18_Precious"
}
