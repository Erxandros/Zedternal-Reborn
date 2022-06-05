class WMWeapDef_RailGun_Precious extends KFWeapDef_RailGun
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_RailGun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_RailGun_Precious"
	BuyPrice=3000
	AmmoPricePerMag=56
	Name="Default__WMWeapDef_RailGun_Precious"
}
