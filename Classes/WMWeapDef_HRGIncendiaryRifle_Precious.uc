class WMWeapDef_HRGIncendiaryRifle_Precious extends KFWeapDef_HRGIncendiaryRifle
	abstract;

const SHORT_ITEM_NAME = "HRG Incendiary";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_AssaultRifle_HRGIncendiaryRifle";

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
	WeaponClassPath="ZedternalReborn.WMWeap_AssaultRifle_HRGIncendiaryRifle_Precious"
	BuyPrice=2400 //2x
	AmmoPricePerMag=63 //40% more per bullet
	SecondaryAmmoMagSize=2 //2x
	SecondaryAmmoMagPrice=42 //40% more per grenade
	Name="Default__KFWeapDef_HRGIncendiaryRifle_Precious"
}
