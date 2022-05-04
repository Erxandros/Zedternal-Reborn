class WMWeapDef_HuskCannon_Precious extends KFWeapDef_HuskCannon
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HuskCannon";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HuskCannon_Precious"
	BuyPrice=3000
	AmmoPricePerMag=350
	Name="Default__WMWeapDef_HuskCannon_Precious"
}
