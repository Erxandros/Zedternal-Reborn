class WMWeapDef_MP7_Precious extends KFWeapDef_MP7
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_MP7";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_MP7_Precious"
	BuyPrice=400
	AmmoPricePerMag=34
	Name="Default__WMWeapDef_MP7_Precious"
}
