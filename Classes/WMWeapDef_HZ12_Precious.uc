class WMWeapDef_HZ12_Precious extends KFWeapDef_HZ12
	abstract;

const SHORT_ITEM_NAME = "HZ12";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_HZ12";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_HZ12_Precious"
	BuyPrice=1500 //2x
	AmmoPricePerMag=135 //40% more per bullet
	Name="Default__KFWeapDef_HZ12_Precious"
}
