class Config_WeaponStarting extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config array<string> Weapon_StartingWeaponDef;	//Players spawn with one or more of these weapons

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Weapon_StartingWeaponDef[0]="KFGame.KFWeapDef_AR15";
		default.Weapon_StartingWeaponDef[1]="KFGame.KFWeapDef_MB500";
		default.Weapon_StartingWeaponDef[2]="KFGame.KFWeapDef_Crovel";
		default.Weapon_StartingWeaponDef[3]="KFGame.KFWeapDef_HX25";
		default.Weapon_StartingWeaponDef[4]="KFGame.KFWeapDef_CaulkBurn";
		default.Weapon_StartingWeaponDef[5]="KFGame.KFWeapDef_Remington1858Dual";
		default.Weapon_StartingWeaponDef[6]="KFGame.KFWeapDef_Winchester1894";
		default.Weapon_StartingWeaponDef[7]="KFGame.KFWeapDef_MP7";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_WeaponStarting"
}
