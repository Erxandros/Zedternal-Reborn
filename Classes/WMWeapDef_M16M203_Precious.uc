class WMWeapDef_M16M203_Precious extends KFWeapDef_M16M203
	abstract;

const SHORT_ITEM_NAME = "M16-M203";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HighExplosive_M16M203";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HighExplosive_M16M203_Precious"
	BuyPrice=2400 //2x
	AmmoPricePerMag=63 //40% more per bullet
	SecondaryAmmoMagSize=2 //2x
	SecondaryAmmoMagPrice=42 //40% more per grenade
	Name="Default__KFWeapDef_M16M203_Precious"
}
