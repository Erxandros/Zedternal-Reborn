class WMWeapDef_ParasiteImplanter_Precious extends KFWeapDef_ParasiteImplanter
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_ParasiteImplanter";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_ParasiteImplanter_Precious"
	BuyPrice=3000
	AmmoPricePerMag=89
	Name="Default__WMWeapDef_ParasiteImplanter_Precious"
}
