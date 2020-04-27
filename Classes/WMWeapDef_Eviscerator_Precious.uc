class WMWeapDef_Eviscerator_Precious extends KFWeapDef_Eviscerator
	abstract;

const SHORT_ITEM_NAME = "Eviscerator";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Eviscerator";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Eviscerator_Precious"
	BuyPrice=3200 //2x
	AmmoPricePerMag=168 //40% more per blade
	SecondaryAmmoMagSize=15 //50% increase
	SecondaryAmmoMagPrice=21 //40% more per fuel
	Name="Default__KFWeapDef_Eviscerator_Precious"
}
