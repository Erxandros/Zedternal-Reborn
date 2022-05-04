class WMWeapDef_Eviscerator_Precious extends KFWeapDef_Eviscerator
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Eviscerator";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Eviscerator_Precious"
	BuyPrice=3200
	AmmoPricePerMag=210
	SecondaryAmmoMagPrice=14
	Name="Default__WMWeapDef_Eviscerator_Precious"
}
