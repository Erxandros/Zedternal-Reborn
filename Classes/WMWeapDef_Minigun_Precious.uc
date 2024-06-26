class WMWeapDef_Minigun_Precious extends KFWeapDef_Minigun
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Minigun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Minigun_Precious"
	BuyPrice=4000
	AmmoPricePerMag=336
	Name="Default__WMWeapDef_Minigun_Precious"
}
