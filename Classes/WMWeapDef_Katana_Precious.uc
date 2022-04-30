class WMWeapDef_Katana_Precious extends KFWeapDef_Katana
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Edged_Katana";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Edged_Katana_Precious"
	BuyPrice=1700
	Name="Default__WMWeapDef_Katana_Precious"
}
