class WMWeapDef_ElephantGun_Precious extends KFWeapDef_ElephantGun
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_ElephantGun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_ElephantGun_Precious"
	BuyPrice=3000
	AmmoPricePerMag=70
	Name="Default__WMWeapDef_ElephantGun_Precious"
}
