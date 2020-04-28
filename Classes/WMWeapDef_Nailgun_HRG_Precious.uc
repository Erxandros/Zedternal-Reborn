class WMWeapDef_Nailgun_HRG_Precious extends KFWeapDef_Nailgun_HRG
	abstract;

const SHORT_ITEM_NAME = "HRG Nailgun";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Nailgun";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Nailgun_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=95 //40% more per bullet (round up)
	Name="Default__KFWeapDef_Nailgun_HRG_Precious"
}
