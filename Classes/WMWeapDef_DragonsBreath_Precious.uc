class WMWeapDef_DragonsBreath_Precious extends KFWeapDef_DragonsBreath
	abstract;

const DEFAULT_WEAPON_PATH = "KFGameContent.KFWeap_Shotgun_DragonsBreath";

static function string GetItemLocalization(string KeyName)
{
	local array<string> Strings;
	local string Localization;

	ParseStringIntoArray(DEFAULT_WEAPON_PATH, Strings, ".", True);
	Localization = Localize(Strings[1], KeyName, Strings[0]);
	if (KeyName ~= "ItemName")
		return "[P]" @ Localization;
	else
		return Localization;
}

defaultproperties
{
	WeaponClassPath="ZedternalReborn.WMWeap_Shotgun_DragonsBreath_Precious"
	BuyPrice=1300
	AmmoPricePerMag=63
	Name="Default__WMWeapDef_DragonsBreath_Precious"
}
