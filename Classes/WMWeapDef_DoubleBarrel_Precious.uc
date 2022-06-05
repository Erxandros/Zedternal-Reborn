class WMWeapDef_DoubleBarrel_Precious extends KFWeapDef_DoubleBarrel
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_DoubleBarrel";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_DoubleBarrel_Precious"
	BuyPrice=1500
	AmmoPricePerMag=37
	Name="Default__WMWeapDef_DoubleBarrel_Precious"
}
