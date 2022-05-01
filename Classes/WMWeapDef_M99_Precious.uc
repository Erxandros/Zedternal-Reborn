class WMWeapDef_M99_Precious extends KFWeapDef_M99
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_M99";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_M99_Precious"
	BuyPrice=5000
	AmmoPricePerMag=107
	Name="Default__WMWeapDef_M99_Precious"
}
