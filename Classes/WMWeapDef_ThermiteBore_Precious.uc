class WMWeapDef_ThermiteBore_Precious extends KFWeapDef_ThermiteBore
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_ThermiteBore";

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
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_ThermiteBore_Precious"
	BuyPrice=3000
	AmmoPricePerMag=164
	Name="Default__WMWeapDef_ThermiteBore_Precious"
}
