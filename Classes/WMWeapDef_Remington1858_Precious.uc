class WMWeapDef_Remington1858_Precious extends KFWeapDef_Remington1858
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Revolver_Rem1858";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if(KeyName ~= "ItemName")
		return "[P]" @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Revolver_Rem1858_Precious"
	BuyPrice=200
	AmmoPricePerMag=21
	Name="Default__WMWeapDef_Remington1858_Precious"
}
