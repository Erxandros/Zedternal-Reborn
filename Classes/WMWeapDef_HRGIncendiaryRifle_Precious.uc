class WMWeapDef_HRGIncendiaryRifle_Precious extends KFWeapDef_HRGIncendiaryRifle
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_HRGIncendiaryRifle";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName ~= "ItemName")
		return Chr(8471) @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_HRGIncendiaryRifle_Precious"
	BuyPrice=2400
	AmmoPricePerMag=84
	SecondaryAmmoMagSize=2
	SecondaryAmmoMagPrice=42
	Name="Default__WMWeapDef_HRGIncendiaryRifle_Precious"
}
