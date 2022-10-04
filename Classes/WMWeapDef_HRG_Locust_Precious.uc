class WMWeapDef_HRG_Locust_Precious extends KFWeapDef_HRG_Locust
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Locust";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Locust_Precious"
	BuyPrice=1800
	AmmoPricePerMag=112
	Name="Default__WMWeapDef_HRG_Locust_Precious"
}
