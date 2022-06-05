class WMWeapDef_HRG_CranialPopper_Precious extends KFWeapDef_HRG_CranialPopper
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_CranialPopper";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_CranialPopper_Precious"
	BuyPrice=2200
	AmmoPricePerMag=112
	Name="Default__WMWeapDef_HRG_CranialPopper_Precious"
}
