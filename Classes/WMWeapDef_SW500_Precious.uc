class WMWeapDef_SW500_Precious extends KFWeapDef_SW500
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Revolver_SW500";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Revolver_SW500_Precious"
	BuyPrice=1500
	AmmoPricePerMag=70
	Name="Default__WMWeapDef_SW500_Precious"
}
