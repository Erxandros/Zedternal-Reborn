class WMWeapDef_RPG7_Precious extends KFWeapDef_RPG7
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_RPG7";

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
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_RPG7_Precious"
	BuyPrice=3000
	AmmoPricePerMag=84
	Name="Default__WMWeapDef_RPG7_Precious"
}
