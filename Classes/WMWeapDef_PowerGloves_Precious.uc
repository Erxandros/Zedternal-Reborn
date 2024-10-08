class WMWeapDef_PowerGloves_Precious extends KFWeapDef_PowerGloves
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_PowerGloves";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_PowerGloves_Precious"
	BuyPrice=3200
	Name="Default__WMWeapDef_PowerGloves_Precious"
}
