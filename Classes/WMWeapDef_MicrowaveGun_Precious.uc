class WMWeapDef_MicrowaveGun_Precious extends KFWeapDef_MicrowaveGun
	abstract;

const SHORT_ITEM_NAME = "Microwave";
const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Beam_Beamthrower";

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
	WeaponClassPath="ZedternalReborn.WMWeap_Beam_Microwave_Precious"
	BuyPrice=3000 //2x
	AmmoPricePerMag=210 //40% more per fuel
	Name="Default__KFWeapDef_MicrowaveGun_Precious"
}
