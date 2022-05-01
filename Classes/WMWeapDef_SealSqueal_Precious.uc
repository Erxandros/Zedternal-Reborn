class WMWeapDef_SealSqueal_Precious extends KFWeapDef_SealSqueal
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_SealSqueal";

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
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_SealSqueal_Precious"
	BuyPrice=2200
	AmmoPricePerMag=168
	Name="Default__WMWeapDef_SealSqueal_Precious"
}
