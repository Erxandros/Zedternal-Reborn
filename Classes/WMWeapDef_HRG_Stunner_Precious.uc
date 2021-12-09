class WMWeapDef_HRG_Stunner_Precious extends KFWeapDef_HRG_Stunner
	abstract;

const SHORT_ITEM_NAME = "HRG Stunner";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_Stunner";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_Stunner_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=77 //40% more per round (round up)
	Name="Default__WMWeapDef_HRG_Stunner_Precious"
}
