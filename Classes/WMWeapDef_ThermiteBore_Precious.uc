class WMWeapDef_ThermiteBore_Precious extends KFWeapDef_ThermiteBore
	abstract;

const SHORT_ITEM_NAME = "Thermite Bore";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_ThermiteBore";

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
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_ThermiteBore_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=164 //40% more per rocket (round up)
	Name="Default__WMWeapDef_ThermiteBore_Precious"
}
