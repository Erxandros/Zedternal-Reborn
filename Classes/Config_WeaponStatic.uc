class Config_WeaponStatic extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config array<string> Weapon_StaticWeaponDef; //Weapons that will always be available in the trader

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Weapon_StaticWeaponDef[0] = "KFGame.KFWeapDef_MedicPistol";
		default.Weapon_StaticWeaponDef[1] = "KFGame.KFWeapDef_9mm";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_WeaponStatic"
}
