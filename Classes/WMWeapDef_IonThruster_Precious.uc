class WMWeapDef_IonThruster_Precious extends KFWeapDef_IonThruster
	abstract;

const SHORT_ITEM_NAME = "Ion Thruster";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Edged_IonThruster";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Edged_IonThruster_Precious"
	BuyPrice=4000 //2x
	Name="Default__KFWeapDef_IonThruster_Precious"
}
