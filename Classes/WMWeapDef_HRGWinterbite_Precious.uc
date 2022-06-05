class WMWeapDef_HRGWinterbite_Precious extends KFWeapDef_HRGWinterbite
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_HRGWinterbite";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_HRGWinterbite_Precious"
	BuyPrice=650
	AmmoPricePerMag=37
	Name="Default__WMWeapDef_HRGWinterbite_Precious"
}
