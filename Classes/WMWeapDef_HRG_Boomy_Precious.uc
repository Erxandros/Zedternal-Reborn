class WMWeapDef_HRG_Boomy_Precious extends KFWeapDef_HRG_Boomy
	abstract;

const SHORT_ITEM_NAME = "Tommy Boom";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Boomy";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Boomy_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=63 //40% more per bullet
	Name="Default__WMWeapDef_HRG_Boomy_Precious"
}