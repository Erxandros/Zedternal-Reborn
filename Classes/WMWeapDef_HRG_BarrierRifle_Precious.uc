class WMWeapDef_HRG_BarrierRifle_Precious extends KFWeapDef_HRG_BarrierRifle
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_BarrierRifle";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_BarrierRifle_Precious"
	BuyPrice=4000
	AmmoPricePerMag=116
	Name="Default__WMWeapDef_HRG_BarrierRifle_Precious"
}
