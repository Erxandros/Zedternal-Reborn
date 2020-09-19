class WMWeapDef_HRGScorcher_Precious extends KFWeapDef_HRGScorcher
	abstract;

const SHORT_ITEM_NAME = "Scorcher";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Pistol_HRGScorcher";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Pistol_HRGScorcher_Precious"
	BuyPrice=2000 //2x
	AmmoPricePerMag=34 //40% more per flare (round up)
	Name="Default__WMWeapDef_HRGScorcher_Precious"
}
