class WMWeapDef_LazerCutter_Precious extends KFWeapDef_LazerCutter
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_LazerCutter";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_LazerCutter_Precious"
	BuyPrice=4000
	AmmoPricePerMag=177
	Name="Default__WMWeapDef_LazerCutter_Precious"
}
