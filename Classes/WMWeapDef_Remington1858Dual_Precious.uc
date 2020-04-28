class WMWeapDef_Remington1858Dual_Precious extends KFWeapDef_Remington1858Dual
	abstract;

const SHORT_ITEM_NAME = "Dual 1858";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Revolver_DualRem1858";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Revolver_DualRem1858_Precious"
	BuyPrice=400 //2x
	AmmoPricePerMag=42 //40% more per bullet
	Name="Default__KFWeapDef_Remington1858Dual_Precious"
}
