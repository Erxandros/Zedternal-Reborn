class Config_WeaponUpgrade extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

struct S_WeaponUpgrade
{
	var string WeaponPath;
	var int PriceUnit;
	var float PriceMultiplier;
	var int MaxLevel;
	var bool bIsStatic;

	structdefaultproperties
	{
		PriceUnit=50
		PriceMultiplier=0.15f
		MaxLevel=3
		bIsStatic=False
	}
};

var config array<S_WeaponUpgrade> WeaponUpgrade_Upgrade;

static function UpdateConfig()
{
	local int i;
	local S_WeaponUpgrade NewItem;

	if (default.MODEVERSION < 1)
	{
		default.WeaponUpgrade_Upgrade.Length = 23;
		default.WeaponUpgrade_Upgrade[0].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Damage";
		default.WeaponUpgrade_Upgrade[0].bIsStatic = True;
		default.WeaponUpgrade_Upgrade[1].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Damage_Clot";
		default.WeaponUpgrade_Upgrade[2].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Damage_GroundFire";
		default.WeaponUpgrade_Upgrade[3].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Damage_Headshot";
		default.WeaponUpgrade_Upgrade[4].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_DamageTaken";
		default.WeaponUpgrade_Upgrade[5].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_HardMeleeAttack";
		default.WeaponUpgrade_Upgrade[6].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Heal";
		default.WeaponUpgrade_Upgrade[7].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_KnockdownPower";
		default.WeaponUpgrade_Upgrade[8].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_MagSize";
		default.WeaponUpgrade_Upgrade[9].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_MagSize_Small";
		default.WeaponUpgrade_Upgrade[10].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_MeleeAttackSpeed";
		default.WeaponUpgrade_Upgrade[11].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Penetration";
		default.WeaponUpgrade_Upgrade[12].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_RateOfFire";
		default.WeaponUpgrade_Upgrade[13].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Recoil";
		default.WeaponUpgrade_Upgrade[14].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_ReloadSpeed";
		default.WeaponUpgrade_Upgrade[15].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo";
		default.WeaponUpgrade_Upgrade[16].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo_C4";
		default.WeaponUpgrade_Upgrade[17].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_StumblePower";
		default.WeaponUpgrade_Upgrade[18].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_StunPower";
		default.WeaponUpgrade_Upgrade[19].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_SwitchSpeed";
		default.WeaponUpgrade_Upgrade[20].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_TightChoke";
		default.WeaponUpgrade_Upgrade[21].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_AmmunitionConsumption";
		default.WeaponUpgrade_Upgrade[22].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_Damage_Fleshpound";
	}

	if (default.MODEVERSION < 12)
	{
		for (i = 0; i < default.WeaponUpgrade_Upgrade.Length; ++i)
		{
			default.WeaponUpgrade_Upgrade[i].PriceUnit = 50;
			default.WeaponUpgrade_Upgrade[i].PriceMultiplier = 0.15f;
			default.WeaponUpgrade_Upgrade[i].MaxLevel = 3;
		}
	}

	if (default.MODEVERSION < 14)
	{
		i = default.WeaponUpgrade_Upgrade.Find('WeaponPath', "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo_C4");
		if (i != INDEX_NONE)
			default.WeaponUpgrade_Upgrade[i].WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo_Small";
	}

	if (default.MODEVERSION < 15)
	{
		NewItem.WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_TurretAmmo";
		NewItem.PriceMultiplier = 0.6f;
		default.WeaponUpgrade_Upgrade.AddItem(NewItem);

		NewItem.WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_TurretLimit";
		NewItem.PriceMultiplier = 2.0f;
		NewItem.bIsStatic = True;
		default.WeaponUpgrade_Upgrade.AddItem(NewItem);

		NewItem.WeaponPath = "ZedternalReborn.WMUpgrade_Weapon_TurretVision";
		NewItem.PriceMultiplier = 0.15f;
		NewItem.bIsStatic = False;
		default.WeaponUpgrade_Upgrade.AddItem(NewItem);
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

	for (i = 0; i < default.WeaponUpgrade_Upgrade.Length; ++i)
	{
		if (default.WeaponUpgrade_Upgrade[i].PriceUnit < 0)
		{
			LogBadConfigMessage("WeaponUpgrade_Upgrade - Line" @ string(i + 1) @ "- PriceUnit",
				string(default.WeaponUpgrade_Upgrade[i].PriceUnit),
				"0", "0 dosh, free", "value >= 0");
			default.WeaponUpgrade_Upgrade[i].PriceUnit = 0;
		}

		if (default.WeaponUpgrade_Upgrade[i].PriceMultiplier < 0)
		{
			LogBadConfigMessage("WeaponUpgrade_Upgrade - Line" @ string(i + 1) @ "- PriceMultiplier",
				string(default.WeaponUpgrade_Upgrade[i].PriceMultiplier),
				"0.0", "0% increase, no scaling", "value >= 0.0");
			default.WeaponUpgrade_Upgrade[i].PriceMultiplier = 0;
		}

		if (default.WeaponUpgrade_Upgrade[i].MaxLevel < 0)
		{
			LogBadConfigMessage("WeaponUpgrade_Upgrade - Line" @ string(i + 1) @ "- MaxLevel",
				string(default.WeaponUpgrade_Upgrade[i].MaxLevel),
				"0", "0 levels, disable upgrade", "value >= 0");
			default.WeaponUpgrade_Upgrade[i].MaxLevel = 0;
		}

		if (default.WeaponUpgrade_Upgrade[i].MaxLevel > 255)
		{
			LogBadConfigMessage("WeaponUpgrade_Upgrade - Line" @ string(i + 1) @ "- MaxLevel",
				string(default.WeaponUpgrade_Upgrade[i].MaxLevel),
				"255", "255 levels, max upgrade", "value >= 0");
			default.WeaponUpgrade_Upgrade[i].MaxLevel = 255;
		}
	}
}

static function LoadConfigObjects(out array<S_WeaponUpgrade> ValidUpgrades, out array< class<WMUpgrade_Weapon> > UpgradeObjects)
{
	local int i;
	local class<WMUpgrade_Weapon> Obj;

	ValidUpgrades.Length = 0;
	UpgradeObjects.Length = 0;

	for (i = 0; i < default.WeaponUpgrade_Upgrade.Length; ++i)
	{
		if (default.WeaponUpgrade_Upgrade[i].MaxLevel > 0)
		{
			Obj = class<WMUpgrade_Weapon>(DynamicLoadObject(default.WeaponUpgrade_Upgrade[i].WeaponPath, class'Class', True));
			if (Obj == None)
			{
				LogBadLoadObjectConfigMessage("WeaponUpgrade_Upgrade", i, default.WeaponUpgrade_Upgrade[i].WeaponPath);
			}
			else
			{
				ValidUpgrades.AddItem(default.WeaponUpgrade_Upgrade[i]);
				UpgradeObjects.AddItem(Obj);
			}
		}
		else
			`log("ZR Config Info: Weapon upgrade disabled because max level is zero:" @default.WeaponUpgrade_Upgrade[i].WeaponPath);
	}
}

defaultproperties
{
	Name="Default__Config_WeaponUpgrade"
}
