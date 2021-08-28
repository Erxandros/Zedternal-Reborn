class Config_WeaponGrenade extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config array<string> Weapon_GrenadeDef; //Grenades avaiable in the upgrade menu

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Weapon_GrenadeDef[0] = "KFGame.KFWeapDef_Grenade_Berserker";
		default.Weapon_GrenadeDef[1] = "KFGame.KFWeapDef_Grenade_Commando";
		default.Weapon_GrenadeDef[2] = "KFGame.KFWeapDef_Grenade_Demo";
		default.Weapon_GrenadeDef[3] = "KFGame.KFWeapDef_Grenade_Firebug";
		default.Weapon_GrenadeDef[4] = "KFGame.KFWeapDef_Grenade_Medic";
		default.Weapon_GrenadeDef[5] = "KFGame.KFWeapDef_Grenade_Gunslinger";
		default.Weapon_GrenadeDef[6] = "KFGame.KFWeapDef_Grenade_Sharpshooter";
		default.Weapon_GrenadeDef[7] = "KFGame.KFWeapDef_Grenade_Support";
		default.Weapon_GrenadeDef[8] = "KFGame.KFWeapDef_Grenade_SWAT";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_WeaponGrenade"
}
