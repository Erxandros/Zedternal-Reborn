class WMWeapDef_Pistol_G18C_Precious extends KFWeapDef_Pistol_G18C
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_G18C";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_G18C_Precious"
	BuyPrice=1500
	AmmoPricePerMag=107
	Name="Default__WMWeapDef_Pistol_G18C_Precious"
}
