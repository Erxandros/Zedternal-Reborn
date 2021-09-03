class Config_WeaponUpgrade extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

struct S_WeaponUpgrade
{
	var string WeaponPath;
	var bool bIsStatic;
};

var config array<S_WeaponUpgrade> WeaponUpgrade_Upgrade;

static function UpdateConfig()
{
	local int i;

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

		for (i = 1; i <= 22; ++i)
		{
			default.WeaponUpgrade_Upgrade[22].bIsStatic = False;
		}
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
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
		Obj = class<WMUpgrade_Weapon>(DynamicLoadObject(default.WeaponUpgrade_Upgrade[i].WeaponPath, class'Class', True));
		if (Obj == None)
		{
			`log("ZR Config: Weapon upgrade" @ default.WeaponUpgrade_Upgrade[i].WeaponPath @ "failed to load."
				@"Skip adding the Weapon upgrade to the game."
				@"Please double check the name in the config and make sure the correct mod resources are installed.");
		}
		else
		{
			ValidUpgrades.AddItem(default.WeaponUpgrade_Upgrade[i]);
			UpgradeObjects.AddItem(Obj);
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponUpgrade"
}
