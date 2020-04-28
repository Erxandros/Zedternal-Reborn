class WMWeapDef_Seeker6_Precious extends KFWeapDef_Seeker6
	abstract;

const SHORT_ITEM_NAME = "Seeker6";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_Seeker6";

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
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_Seeker6_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=84 //40% more per rocket
	Name="Default__WMWeapDef_Seeker6_Precious"
}
