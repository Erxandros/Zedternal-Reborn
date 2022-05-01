class WMWeapDef_FAMAS_Precious extends KFWeapDef_FAMAS
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_FAMAS";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_FAMAS_Precious"
	BuyPrice=2400
	AmmoPricePerMag=53
	SecondaryAmmoMagSize=9
	SecondaryAmmoMagPrice=32
	Name="Default__WMWeapDef_FAMAS_Precious"
}
