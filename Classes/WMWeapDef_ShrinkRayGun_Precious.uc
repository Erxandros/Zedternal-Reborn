class WMWeapDef_ShrinkRayGun_Precious extends KFWeapDef_ShrinkRayGun
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_ShrinkRayGun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_ShrinkRayGun_Precious"
	BuyPrice=2400
	AmmoPricePerMag=140
	Name="Default__WMWeapDef_ShrinkRayGun_Precious"
}
