class WMWeapDef_CompoundBow_Precious extends KFWeapDef_CompoundBow
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Bow_CompoundBow";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Bow_CompoundBow_Precious"
	BuyPrice=4000
	AmmoPricePerMag=23
	Name="Default__WMWeapDef_CompoundBow_Precious"
}
