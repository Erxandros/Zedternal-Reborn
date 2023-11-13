class WMWeapDef_9mm_Precious extends KFWeapDef_9mm
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_9mm";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_9mm_Precious"
	AmmoPricePerMag=34
	Name="Default__WMWeapDef_9mm_Precious"
}
