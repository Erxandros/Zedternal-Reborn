class WMWeapDef_AF2011_Precious extends KFWeapDef_AF2011
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_AF2011";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_AF2011_Precious"
	BuyPrice=1500
	AmmoPricePerMag=76
	Name="Default__WMWeapDef_AF2011_Precious"
}
