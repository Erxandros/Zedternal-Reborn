class WMWeapDef_HRG_BlastBrawlers_Precious extends KFWeapDef_HRG_BlastBrawlers
	abstract;

const SHORT_ITEM_NAME = "HRG Brawlers";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_HRG_BlastBrawlers";

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
	WeaponClassPath="ZedternalReborn.WMWeap_HRG_BlastBrawlers_Precious"
	BuyPrice=3200 //2x
	AmmoPricePerMag=63 //40% more per bullet
	Name="Default__WMWeapDef_HRG_BlastBrawlers_Precious"
}
