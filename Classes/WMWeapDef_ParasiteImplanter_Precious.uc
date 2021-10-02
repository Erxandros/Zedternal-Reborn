class WMWeapDef_ParasiteImplanter_Precious extends KFWeapDef_ParasiteImplanter
	abstract;

const SHORT_ITEM_NAME = "Corrupter";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_ParasiteImplanter";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_ParasiteImplanter_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=89 //40% more per bullet (round up)
	Name="Default__WMWeapDef_ParasiteImplanter_Precious"
}
