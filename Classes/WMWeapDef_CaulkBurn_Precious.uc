class WMWeapDef_CaulkBurn_Precious extends KFWeapDef_CaulkBurn
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Flame_CaulkBurn";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Flame_CaulkBurn_Precious"
	BuyPrice=400
	AmmoPricePerMag=42
	Name="Default__WMWeapDef_CaulkBurn_Precious"
}
