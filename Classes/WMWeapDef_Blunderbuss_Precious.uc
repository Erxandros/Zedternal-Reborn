class WMWeapDef_Blunderbuss_Precious extends KFWeapDef_Blunderbuss
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_Blunderbuss";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_Blunderbuss_Precious"
	BuyPrice=3000
	AmmoPricePerMag=91
	Name="Default__WMWeapDef_Blunderbuss_Precious"
}
