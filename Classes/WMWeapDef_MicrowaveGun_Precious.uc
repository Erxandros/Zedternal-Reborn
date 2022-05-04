class WMWeapDef_MicrowaveGun_Precious extends KFWeapDef_MicrowaveGun
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Beam_Microwave";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Beam_Microwave_Precious"
	BuyPrice=3000
	AmmoPricePerMag=280
	Name="Default__WMWeapDef_MicrowaveGun_Precious"
}
