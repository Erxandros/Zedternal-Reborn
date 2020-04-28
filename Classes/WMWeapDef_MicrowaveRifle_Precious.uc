class WMWeapDef_MicrowaveRifle_Precious extends KFWeapDef_MicrowaveRifle
	abstract;

const SHORT_ITEM_NAME = "Helios";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_Microwave";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_Microwave_Precious"
	BuyPrice=4000 //2x
	AmmoPricePerMag=139 //40% more per bullet (round up)
	Name="Default__KFWeapDef_MicrowaveRifle_Precious"
}
