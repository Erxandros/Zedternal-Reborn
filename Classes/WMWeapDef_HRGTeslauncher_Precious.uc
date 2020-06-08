class WMWeapDef_HRGTeslauncher_Precious extends KFWeapDef_HRGTeslauncher
	abstract;

const SHORT_ITEM_NAME = "Teslauncher";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_HRGTeslauncher";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMCustomWeapon_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_HRGTeslauncher_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=131 //40% more per bullet (round up)
	SecondaryAmmoMagSize=2 //2x
	SecondaryAmmoMagPrice=42 //40% more per grenade
	Name="Default__WMWeapDef_HRGTeslauncher_Precious"
}
