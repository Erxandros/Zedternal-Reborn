class WMWeapDef_Thompson_Precious extends KFWeapDef_Thompson
	abstract;

const SHORT_ITEM_NAME = "Tommy Gun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_Thompson";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_Thompson_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=105 //40% more per bullet
	Name="Default__KFWeapDef_Thompson_Precious"
}
