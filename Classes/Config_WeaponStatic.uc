class Config_WeaponStatic extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config array<string> Weapon_StaticWeaponDef; //Weapons that will always be available in the trader

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Weapon_StaticWeaponDef[0] = "KFGame.KFWeapDef_MedicPistol";
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

	for (i = 0; i < default.Weapon_StaticWeaponDef.Length; ++i)
	{
		ObjDef = class<KFWeaponDefinition>(DynamicLoadObject(default.Weapon_StaticWeaponDef[i], class'Class', True));
		if (ObjDef == None)
		{
			LogBadLoadObjectConfigMessage("Weapon_StaticWeaponDef", i + 1, default.Weapon_StaticWeaponDef[i]);
			continue;
		}

		ObjWep = class<KFWeapon>(DynamicLoadObject(ObjDef.default.WeaponClassPath, class'Class', True));
		if (ObjWep == None)
		{
			LogBadLoadWeaponConfigMessage("Weapon_StaticWeaponDef", i + 1, default.Weapon_StaticWeaponDef[i],
				ObjDef.default.WeaponClassPath);
			continue;
		}

		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(WeaponDefObjects, PathName(ObjDef), Ins))
		{
			WeaponDefObjects.InsertItem(Ins, ObjDef);
			WeaponObjects.InsertItem(Ins, ObjWep);
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponStatic"
}
