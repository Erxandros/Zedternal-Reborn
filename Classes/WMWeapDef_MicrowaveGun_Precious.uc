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
		return class'Zedternal.WMWeaponPrecious_Helper'.static.GetItemNameVariant(Localization, SHORT_ITEM_NAME);
	else
		return Localization;
}





defaultproperties
{
   WeaponClassPath="Zedternal.WMWeap_Beam_Microwave_Precious"
   BuyPrice=2000
   AmmoPricePerMag=125
   Name="Default__KFWeapDef_MicrowaveGun_Precious"
}
