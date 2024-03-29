class WMWeapDef_Healthrower_HRG_Precious extends KFWeapDef_Healthrower_HRG
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Healthrower";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Healthrower_Precious"
	BuyPrice=2000
	AmmoPricePerMag=196
	Name="Default__WMWeapDef_Healthrower_HRG_Precious"
}
