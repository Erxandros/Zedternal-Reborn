class WMWeapDef_HRG_SonicGun_Precious extends KFWeapDef_HRG_SonicGun
	abstract;

const SHORT_ITEM_NAME = "Beluga Beat";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_SonicGun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_SonicGun_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=137 //40% more per bullet (round up)
	Name="Default__WMWeapDef_HRG_SonicGun_Precious"
}
