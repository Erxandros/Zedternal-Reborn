class WMWeapDef_Rifle_FrostShotgunAxe_Precious extends KFWeapDef_Rifle_FrostShotgunAxe
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_FrostShotgunAxe";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_FrostShotgunAxe_Precious"
	BuyPrice=2600
	AmmoPricePerMag=82
	Name="Default__WMWeapDef_Rifle_FrostShotgunAxe_Precious"
}
