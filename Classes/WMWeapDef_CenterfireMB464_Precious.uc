class WMWeapDef_CenterfireMB464_Precious extends KFWeapDef_CenterfireMB464
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_CenterfireMB464";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_CenterfireMB464_Precious"
	BuyPrice=1300
	AmmoPricePerMag=154
	Name="Default__WMWeapDef_CenterfireMB464_Precious"
}
