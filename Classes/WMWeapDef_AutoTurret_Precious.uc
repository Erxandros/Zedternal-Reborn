class WMWeapDef_AutoTurret_Precious extends KFWeapDef_AutoTurret
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AutoTurret";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AutoTurret_Precious"
	BuyPrice=1000
	AmmoPricePerMag=84
	Name="Default__WMWeapDef_AutoTurret_Precious"
}
