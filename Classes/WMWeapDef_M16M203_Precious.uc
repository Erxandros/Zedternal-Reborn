class WMWeapDef_M16M203_Precious extends KFWeapDef_M16M203
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_M16M203";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_M16M203_Precious"
	BuyPrice=2400
	AmmoPricePerMag=63
	SecondaryAmmoMagSize=2
	SecondaryAmmoMagPrice=42
	Name="Default__WMWeapDef_M16M203_Precious"
}
