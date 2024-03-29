class WMWeapDef_MicrowaveRifle_Precious extends KFWeapDef_MicrowaveRifle
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_Microwave";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_Microwave_Precious"
	BuyPrice=4000
	AmmoPricePerMag=185
	Name="Default__WMWeapDef_MicrowaveRifle_Precious"
}
