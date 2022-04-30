class WMWeapDef_C4_Precious extends KFWeapDef_C4
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Thrown_C4";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Thrown_C4_Precious"
	BuyPrice=600
	AmmoPricePerMag=70
	Name="Default__WMWeapDef_C4_Precious"
}
