class WMWeapDef_SealSqueal_Precious extends KFWeapDef_SealSqueal
	abstract;

const SHORT_ITEM_NAME = "Seal Squeal";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_RocketLauncher_SealSqueal";

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
	WeaponClassPath="ZedternalReborn.WMWeap_RocketLauncher_SealSqueal_Precious"
	BuyPrice=2200 //2x
	AmmoPricePerMag=168 //40% more per rocket
	Name="Default__KFWeapDef_SealSqueal_Precious"
}
