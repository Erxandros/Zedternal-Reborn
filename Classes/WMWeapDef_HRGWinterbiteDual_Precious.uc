class WMWeapDef_HRGWinterbiteDual_Precious extends KFWeapDef_HRGWinterbiteDual
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualHRGWinterbite";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualHRGWinterbite_Precious"
	BuyPrice=1300
	AmmoPricePerMag=73
	Name="Default__WMWeapDef_HRGWinterbiteDual_Precious"
}
