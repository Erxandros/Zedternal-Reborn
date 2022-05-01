class WMWeapDef_Zweihander_Precious extends KFWeapDef_Zweihander
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Edged_Zweihander";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Edged_Zweihander_Precious"
	BuyPrice=2600
	Name="Default__WMWeapDef_Zweihander_Precious"
}
