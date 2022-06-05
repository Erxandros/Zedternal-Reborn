class WMWeapDef_Crossbow_Precious extends KFWeapDef_Crossbow
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Bow_Crossbow";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Bow_Crossbow_Precious"
	BuyPrice=1300
	AmmoPricePerMag=16
	Name="Default__WMWeapDef_Crossbow_Precious"
}
