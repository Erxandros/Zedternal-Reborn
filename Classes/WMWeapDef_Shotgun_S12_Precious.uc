class WMWeapDef_Shotgun_S12_Precious extends KFWeapDef_Shotgun_S12
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_S12";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_S12_Precious"
	BuyPrice=3000
	AmmoPricePerMag=112
	SecondaryAmmoMagSize=2
	SecondaryAmmoMagPrice=84
	Name="Default__WMWeapDef_Shotgun_S12_Precious"
}
