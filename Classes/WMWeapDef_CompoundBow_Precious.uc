class WMWeapDef_CompoundBow_Precious extends KFWeapDef_CompoundBow
	abstract;

const SHORT_ITEM_NAME = "Compound Bow";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Bow_CompoundBow";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Bow_CompoundBow_Precious"
	BuyPrice=4000 //2x
	AmmoPricePerMag=45 //40% more per arrow (round up)
	Name="Default__WMWeapDef_CompoundBow_Precious"
}
