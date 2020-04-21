class WMWeapDef_DragonsBreath_Precious extends KFWeapDef_DragonsBreath
	abstract;

const SHORT_ITEM_NAME = "DragonsBreath";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_DragonsBreath";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;
	
	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", true);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName == "ItemName")
		return class'ZedternalReborn.WMWeaponPrecious_Helper'.static.GetItemNameVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_DragonsBreath_Precious"
	BuyPrice=1300 //2x
	AmmoPricePerMag=63 //40% more per bullet
	Name="Default__KFWeapDef_DragonsBreath_Precious"
}
