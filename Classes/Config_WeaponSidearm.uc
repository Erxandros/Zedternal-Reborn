class Config_WeaponSidearm extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config bool Weapon_bEnable9mmSidearm;
var config bool Weapon_bEnable93RSidearm;

struct S_WeaponSidearm
{
	var string PrimaryWeaponDefPath;
	var string SecondaryWeaponDefPath;
	var int Price;

	structdefaultproperties
	{
		Price=0
	}
};
var config array<S_WeaponSidearm> Weapon_SidearmWeaponDef; //Weapons that will be available as a sidearm

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Weapon_bEnable9mmSidearm = True;
		default.Weapon_bEnable93RSidearm = True;

		default.Weapon_SidearmWeaponDef.Length = 2;
		default.Weapon_SidearmWeaponDef[0].PrimaryWeaponDefPath = "ZedternalReborn.WMWeapDef_9mm_Precious";
		default.Weapon_SidearmWeaponDef[0].SecondaryWeaponDefPath = "ZedternalReborn.WMWeapDef_9mmDual_Precious";
		default.Weapon_SidearmWeaponDef[0].Price = 300;
		default.Weapon_SidearmWeaponDef[1].PrimaryWeaponDefPath = "ZedternalReborn.WMWeapDef_HRG_93R_Precious";
		default.Weapon_SidearmWeaponDef[1].SecondaryWeaponDefPath = "ZedternalReborn.WMWeapDef_HRG_93R_Dual_Precious";
		default.Weapon_SidearmWeaponDef[1].Price = 300;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i;

	if (!default.Weapon_bEnable9mmSidearm && !default.Weapon_bEnable93RSidearm)
	{
		`log("ZR Config Error: Weapon_bEnable9mmSidearm and Weapon_bEnable93RSidearm"
			@"are currently both set to false which is not supported."
			@"At least one needs to be true. Setting Weapon_bEnable9mmSidearm to true temporarily.");
		default.Weapon_bEnable9mmSidearm = True;
	}

	for (i = 0; i < default.Weapon_SidearmWeaponDef.Length; ++i)
	{
		if (default.Weapon_SidearmWeaponDef[i].Price < 0)
		{
			LogBadConfigMessage("Weapon_SidearmWeaponDef - Line" @ string(i + 1) @ "- Price",
				string(default.Weapon_SidearmWeaponDef[i].Price),
				"0", "0, free", "value >= 0");
			default.Weapon_SidearmWeaponDef[i].Price = 0;
		}
	}
}

static function LoadConfigObjects(out array<int> SidearmPrice,
	out array< class<KFWeaponDefinition> > WeaponDefObjects,
	out array< class<KFWeapon> > WeaponObjects,
	out array< class<KFWeaponDefinition> > OtherWeaponDefObjects,
	out array< class<KFWeapon> > OtherWeaponObjects)
{
	local int i, Ins;
	local class<KFWeaponDefinition> ObjDef;
	local class<KFWeapon> ObjWep;

	SidearmPrice.Length = 0;
	WeaponDefObjects.Length = 0;
	WeaponObjects.Length = 0;
	OtherWeaponDefObjects.Length = 0;
	OtherWeaponObjects.Length = 0;

	if (default.Weapon_bEnable9mmSidearm)
	{
		WeaponDefObjects.AddItem(class'KFGame.KFWeapDef_9mm');
		WeaponObjects.AddItem(class'KFGameContent.KFWeap_Pistol_9mm');
		OtherWeaponDefObjects.AddItem(class'KFGame.KFWeapDef_9mmDual');
		OtherWeaponObjects.AddItem(class'KFGameContent.KFWeap_Pistol_Dual9mm');
		SidearmPrice.AddItem(0);
	}

	if (default.Weapon_bEnable93RSidearm)
	{
		WeaponDefObjects.AddItem(class'KFGame.KFWeapDef_HRG_93R');
		WeaponObjects.AddItem(class'KFGameContent.KFWeap_HRG_93R');
		OtherWeaponDefObjects.AddItem(class'KFGame.KFWeapDef_HRG_93R_Dual');
		OtherWeaponObjects.AddItem(class'KFGameContent.KFWeap_HRG_93R_Dual');
		SidearmPrice.AddItem(0);
	}

	for (i = 0; i < default.Weapon_SidearmWeaponDef.Length; ++i)
	{
		ObjDef = class<KFWeaponDefinition>(DynamicLoadObject(default.Weapon_SidearmWeaponDef[i].PrimaryWeaponDefPath, class'Class', True));
		if (ObjDef == None)
		{
			LogBadLoadObjectConfigMessage("Weapon_SidearmWeaponDef", i + 1, default.Weapon_SidearmWeaponDef[i].PrimaryWeaponDefPath);
			continue;
		}

		ObjWep = class<KFWeapon>(DynamicLoadObject(ObjDef.default.WeaponClassPath, class'Class', True));
		if (ObjWep == None)
		{
			LogBadLoadWeaponConfigMessage("Weapon_SidearmWeaponDef", i + 1, default.Weapon_SidearmWeaponDef[i].PrimaryWeaponDefPath,
				ObjDef.default.WeaponClassPath);
			continue;
		}

		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(WeaponDefObjects, PathName(ObjDef), Ins))
		{
			WeaponDefObjects.InsertItem(Ins, ObjDef);
			WeaponObjects.InsertItem(Ins, ObjWep);
			SidearmPrice.InsertItem(Ins, default.Weapon_SidearmWeaponDef[i].Price);
		}

		if (Len(default.Weapon_SidearmWeaponDef[i].SecondaryWeaponDefPath) > 0)
		{
			ObjDef = class<KFWeaponDefinition>(DynamicLoadObject(default.Weapon_SidearmWeaponDef[i].SecondaryWeaponDefPath, class'Class', True));
			if (ObjDef == None)
			{
				LogBadLoadObjectConfigMessage("Weapon_SidearmWeaponDef", i + 1, default.Weapon_SidearmWeaponDef[i].SecondaryWeaponDefPath);
				continue;
			}

			ObjWep = class<KFWeapon>(DynamicLoadObject(ObjDef.default.WeaponClassPath, class'Class', True));
			if (ObjWep == None)
			{
				LogBadLoadWeaponConfigMessage("Weapon_SidearmWeaponDef", i + 1, default.Weapon_SidearmWeaponDef[i].SecondaryWeaponDefPath,
					ObjDef.default.WeaponClassPath);
				continue;
			}

			if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(WeaponDefObjects, PathName(ObjDef), Ins))
			{
				OtherWeaponDefObjects.InsertItem(Ins, ObjDef);
				OtherWeaponObjects.InsertItem(Ins, ObjWep);
			}
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponSidearm"
}
