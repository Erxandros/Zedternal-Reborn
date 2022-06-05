class WMWeapDef_FireAxe_Precious extends KFWeapDef_FireAxe
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Edged_FireAxe";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Edged_FireAxe_Precious"
	BuyPrice=1700
	Name="Default__WMWeapDef_FireAxe_Precious"
}
