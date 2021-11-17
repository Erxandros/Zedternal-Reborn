class Config_WeaponDisable extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config bool Weapon_bDisableAllBaseWeapons;
var config bool Weapon_bUseDisableWeaponList;
var config array<string> Weapon_DisableWeaponDef;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Weapon_bDisableAllBaseWeapons = False;
		default.Weapon_bUseDisableWeaponList = False;
		default.Weapon_DisableWeaponDef[0] = "Class.Weapon_Definition_Example";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function LoadConfigObjects(out array< class<KFWeaponDefinition> > WeaponDefObjects)
{
	local int i, Ins;
	local class<KFWeaponDefinition> Obj;

	WeaponDefObjects.Length = 0;

	if (default.Weapon_bUseDisableWeaponList)
	{
		for (i = 0; i < default.Weapon_DisableWeaponDef.Length; ++i)
		{
			Obj = class<KFWeaponDefinition>(DynamicLoadObject(default.Weapon_DisableWeaponDef[i], class'Class', True));
			if (Obj == None)
			{
				LogBadLoadObjectConfigMessage("Weapon_DisableWeaponDef", i + 1, default.Weapon_DisableWeaponDef[i]);
			}
			else
			{
				if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(WeaponDefObjects, PathName(Obj), Ins))
					WeaponDefObjects.InsertItem(Ins, Obj);
			}
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponDisable"
}
