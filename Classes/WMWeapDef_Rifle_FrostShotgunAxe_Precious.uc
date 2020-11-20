class WMWeapDef_Rifle_FrostShotgunAxe_Precious extends KFWeapDef_Rifle_FrostShotgunAxe
	abstract;

const SHORT_ITEM_NAME = "Frost Fang";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_FrostShotgunAxe";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_FrostShotgunAxe_Precious"
	BuyPrice=2600 //2x
	AmmoPricePerMag=82 //40% more per bullet (round up)
	Name="Default__WMWeapDef_Rifle_FrostShotgunAxe_Precious"
}
