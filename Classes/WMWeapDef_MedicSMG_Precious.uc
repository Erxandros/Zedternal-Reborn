class WMWeapDef_MedicSMG_Precious extends KFWeapDef_MedicSMG
	abstract;

const SHORT_ITEM_NAME = "HMTech-201";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_SMG_Medic";

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
	WeaponClassPath="ZedternalReborn.WMWeap_SMG_Medic_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=45 //40% more per bullet
	Name="Default__WMWeapDef_MedicSMG_Precious"
}
