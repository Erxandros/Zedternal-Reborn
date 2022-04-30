class WMWeapDef_HRGScorcher_Precious extends KFWeapDef_HRGScorcher
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_HRGScorcher";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if(KeyName ~= "ItemName")
		return "[P]" @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_HRGScorcher_Precious"
	BuyPrice=2000
	AmmoPricePerMag=34
	Name="Default__WMWeapDef_HRGScorcher_Precious"
}
