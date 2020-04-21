class WMWeapDef_FlareGun_Precious extends KFWeapDef_FlareGun
	abstract;

const SHORT_ITEM_NAME = "Spitfire";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_Flare";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNameVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_Flare_Precious"
	BuyPrice=650 //2x
	AmmoPricePerMag=28 //40% more per bullet
	Name="Default__KFWeapDef_FlareGun_Precious"
}
