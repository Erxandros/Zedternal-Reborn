class WMWeapDef_ChiappaRhino_Precious extends KFWeapDef_ChiappaRhino
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_ChiappaRhino";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_ChiappaRhino_Precious"
	BuyPrice=1100
	AmmoPricePerMag=36
	Name="Default__WMWeapDef_ChiappaRhino_Precious"
}
