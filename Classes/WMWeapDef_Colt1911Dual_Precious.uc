class WMWeapDef_Colt1911Dual_Precious extends KFWeapDef_Colt1911Dual
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_DualColt1911";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_DualColt1911_Precious"
	BuyPrice=1300
	AmmoPricePerMag=73
	Name="Default__WMWeapDef_Colt1911Dual_Precious"
}
