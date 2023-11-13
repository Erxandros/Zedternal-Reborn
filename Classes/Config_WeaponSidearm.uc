class Config_WeaponSidearm extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config bool Weapon_bEnable9mmSidearm;
var config bool Weapon_bEnable93RSidearm;

struct S_WeaponSidearm
{
	var string WeaponPath;
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
		default.Weapon_SidearmWeaponDef[0].WeaponPath = "ZedternalReborn.WMWeapDef_9mm_Precious";
		default.Weapon_SidearmWeaponDef[0].Price = 300;
		default.Weapon_SidearmWeaponDef[1].WeaponPath = "ZedternalReborn.WMWeapDef_HRG_93R_Precious";
		default.Weapon_SidearmWeaponDef[1].Price = 300;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function LoadConfigObjects(out array<int> SidearmPrice, out array< class<KFWeaponDefinition> > WeaponDefObjects, out array< class<KFWeapon> > WeaponObjects)
{
	local int i, Ins;
	local class<KFWeaponDefinition> ObjDef;
	local class<KFWeapon> ObjWep;

	SidearmPrice.Length = 0;
	WeaponDefObjects.Length = 0;
	WeaponObjects.Length = 0;

	if (default.Weapon_bEnable9mmSidearm)
	{
		WeaponDefObjects.AddItem(class'KFGame.KFWeapDef_9mm');
		WeaponObjects.AddItem(class'KFGameContent.KFWeap_Pistol_9mm');
		SidearmPrice.AddItem(0);
	}

	if (default.Weapon_bEnable93RSidearm)
	{
		WeaponDefObjects.AddItem(class'KFGame.KFWeapDef_HRG_93R');
		WeaponObjects.AddItem(class'KFGameContent.KFWeap_HRG_93R');
		SidearmPrice.AddItem(0);
	}

	for (i = 0; i < default.Weapon_SidearmWeaponDef.Length; ++i)
	{
		ObjDef = class<KFWeaponDefinition>(DynamicLoadObject(default.Weapon_SidearmWeaponDef[i].WeaponPath, class'Class', True));
		if (ObjDef == None)
		{
			LogBadLoadObjectConfigMessage("Weapon_SidearmWeaponDef", i + 1, default.Weapon_SidearmWeaponDef[i].WeaponPath);
			continue;
		}

		ObjWep = class<KFWeapon>(DynamicLoadObject(ObjDef.default.WeaponClassPath, class'Class', True));
		if (ObjWep == None)
		{
			LogBadLoadWeaponConfigMessage("Weapon_SidearmWeaponDef", i + 1, default.Weapon_SidearmWeaponDef[i].WeaponPath,
				ObjDef.default.WeaponClassPath);
			continue;
		}

		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(WeaponDefObjects, PathName(ObjDef), Ins))
		{
			WeaponDefObjects.InsertItem(Ins, ObjDef);
			WeaponObjects.InsertItem(Ins, ObjWep);
			SidearmPrice.InsertItem(Ins, default.Weapon_SidearmWeaponDef[i].Price);
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponSidearm"
}
