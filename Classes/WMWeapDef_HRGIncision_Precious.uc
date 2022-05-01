class WMWeapDef_HRGIncision_Precious extends KFWeapDef_HRGIncision
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_HRGIncision";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_HRGIncision_Precious"
	BuyPrice=3000
	AmmoPricePerMag=40
	Name="Default__WMWeapDef_HRGIncision_Precious"
}
