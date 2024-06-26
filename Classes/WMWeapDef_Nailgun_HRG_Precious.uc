class WMWeapDef_Nailgun_HRG_Precious extends KFWeapDef_Nailgun_HRG
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Nailgun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Nailgun_Precious"
	BuyPrice=2200
	AmmoPricePerMag=126
	Name="Default__WMWeapDef_Nailgun_HRG_Precious"
}
