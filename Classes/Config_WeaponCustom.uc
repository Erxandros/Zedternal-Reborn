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

static function LoadConfigObjects(out array< class<KFWeaponDefinition> > WeaponDefObjects, out array< class<KFWeapon> > WeaponObjects)
{
	local int i, Ins;
	local class<KFWeaponDefinition> ObjDef;
	local class<KFWeapon> ObjWep;

	WeaponDefObjects.Length = 0;
	WeaponObjects.Length = 0;

	for (i = 0; i < default.Weapon_CustomWeaponDef.Length; ++i)
	{
		ObjDef = class<KFWeaponDefinition>(DynamicLoadObject(default.Weapon_CustomWeaponDef[i], class'Class', True));
		if (ObjDef == None)
		{
			LogBadLoadObjectConfigMessage("Weapon_CustomWeaponDef", i + 1, default.Weapon_CustomWeaponDef[i]);
			continue;
		}

		ObjWep = class<KFWeapon>(DynamicLoadObject(ObjDef.default.WeaponClassPath, class'Class', True));
		if (ObjWep == None)
		{
			LogBadLoadWeaponConfigMessage("Weapon_CustomWeaponDef", i + 1, default.Weapon_CustomWeaponDef[i],
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
	Name="Default__Config_WeaponCustom"
}
