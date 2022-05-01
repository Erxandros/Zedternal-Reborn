class WMWeapDef_FreezeThrower_Precious extends KFWeapDef_FreezeThrower
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Ice_FreezeThrower";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Ice_FreezeThrower_Precious"
	BuyPrice=2200
	AmmoPricePerMag=95
	Name="Default__WMWeapDef_FreezeThrower_Precious"
}
