class Config_WeaponCustom extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config bool Weapon_bUseCustomWeaponList; //Should we add custom weapons to the trader
var config array<string> Weapon_CustomWeaponDef; //List of custom weapons definitions

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Weapon_bUseCustomWeaponList = False;
		default.Weapon_CustomWeaponDef[0] = "Class.Weapon_Definition_Example";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_WeaponCustom"
}
