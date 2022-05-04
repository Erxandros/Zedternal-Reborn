class WMWeapDef_Pulverizer_Precious extends KFWeapDef_Pulverizer
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_Pulverizer";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_Pulverizer_Precious"
	BuyPrice=2600
	AmmoPricePerMag=238
	Name="Default__WMWeapDef_Pulverizer_Precious"
}
