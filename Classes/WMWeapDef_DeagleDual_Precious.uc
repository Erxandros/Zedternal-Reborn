class WMWeapDef_DeagleDual_Precious extends KFWeapDef_DeagleDual
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualDeagle";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualDeagle_Precious"
	BuyPrice=2200
	AmmoPricePerMag=118
	Name="Default__WMWeapDef_DeagleDual_Precious"
}
