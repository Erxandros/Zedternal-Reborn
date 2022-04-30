class WMWeapDef_Crovel_Precious extends KFWeapDef_Crovel
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Blunt_Crovel";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Blunt_Crovel_Precious"
	BuyPrice=400
	Name="Default__WMWeapDef_Crovel_Precious"
}
