class WMWeapDef_ChiappaRhinoDual_Precious extends KFWeapDef_ChiappaRhinoDual
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_ChiappaRhinoDual";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_ChiappaRhinoDual_Precious"
	BuyPrice=2200
	AmmoPricePerMag=96
	Name="Default__WMWeapDef_ChiappaRhinoDual_Precious"
}
