class WMWeapDef_CenterfireMB464_Precious extends KFWeapDef_CenterfireMB464
	abstract;

const SHORT_ITEM_NAME = "Centerfire";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Rifle_CenterfireMB464";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNamePreciousVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Rifle_CenterfireMB464_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=116 //40% more per bullet
	Name="Default__KFWeapDef_CenterfireMB464_Precious"
}
