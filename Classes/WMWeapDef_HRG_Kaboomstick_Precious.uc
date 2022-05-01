class WMWeapDef_HRG_Kaboomstick_Precious extends KFWeapDef_HRG_Kaboomstick
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_HRG_Kaboomstick";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_HRG_Kaboomstick_Precious"
	BuyPrice=2200
	AmmoPricePerMag=32
	Name="Default__WMWeapDef_HRG_Kaboomstick_Precious"
}
