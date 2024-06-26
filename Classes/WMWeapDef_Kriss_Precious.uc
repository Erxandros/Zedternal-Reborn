class WMWeapDef_Kriss_Precious extends KFWeapDef_Kriss
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_Kriss";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_Kriss_Precious"
	BuyPrice=3000
	AmmoPricePerMag=87
	Name="Default__WMWeapDef_Kriss_Precious"
}
