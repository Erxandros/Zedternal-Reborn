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

static function LoadConfigObjects(out array< class<KFWeaponDefinition> > WeaponDefObjects, out array< class<KFWeapon> > WeaponObjects)
{
	local int i, Ins;
	local class<KFWeaponDefinition> ObjDef;
	local class<KFWeapon> ObjWep;

	WeaponDefObjects.Length = 0;
	WeaponObjects.Length = 0;

	for (i = 0; i < default.Weapon_StartingWeaponDef.Length; ++i)
	{
		ObjDef = class<KFWeaponDefinition>(DynamicLoadObject(default.Weapon_StartingWeaponDef[i], class'Class', True));
		if (ObjDef == None)
		{
			LogBadLoadObjectConfigMessage("Weapon_StartingWeaponDef", i + 1, default.Weapon_StartingWeaponDef[i]);
			continue;
		}

		ObjWep = class<KFWeapon>(DynamicLoadObject(ObjDef.default.WeaponClassPath, class'Class', True));
		if (ObjWep == None)
		{
			LogBadLoadWeaponConfigMessage("Weapon_StartingWeaponDef", i + 1, default.Weapon_StartingWeaponDef[i],
				ObjDef.default.WeaponClassPath);
			continue;
		}

		if (class'ZedternalReborn.WMGameInfo_ConfigData'.static.BinarySearch(WeaponDefObjects, PathName(ObjDef), Ins) == INDEX_NONE)
		{
			WeaponDefObjects.InsertItem(Ins, ObjDef);
			WeaponObjects.InsertItem(Ins, ObjWep);
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponStarting"
}
