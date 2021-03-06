class WMWeapDef_SCAR_Precious extends KFWeapDef_SCAR
	abstract;

const SHORT_ITEM_NAME = "SCAR";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_SCAR";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_SCAR_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=59 //40% more per bullet
	Name="Default__WMWeapDef_SCAR_Precious"
}
