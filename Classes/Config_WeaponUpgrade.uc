class Config_WeaponUpgrade extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config array<string> WeaponUpgrade_Upgrade;
var config array<string> WeaponUpgrade_StaticUpgrade;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.WeaponUpgrade_Upgrade[0] = "ZedternalReborn.WMUpgrade_Weapon_Damage_Clot";
		default.WeaponUpgrade_Upgrade[1] = "ZedternalReborn.WMUpgrade_Weapon_Damage_GroundFire";
		default.WeaponUpgrade_Upgrade[2] = "ZedternalReborn.WMUpgrade_Weapon_Damage_Headshot";
		default.WeaponUpgrade_Upgrade[3] = "ZedternalReborn.WMUpgrade_Weapon_DamageTaken";
		default.WeaponUpgrade_Upgrade[4] = "ZedternalReborn.WMUpgrade_Weapon_HardMeleeAttack";
		default.WeaponUpgrade_Upgrade[5] = "ZedternalReborn.WMUpgrade_Weapon_Heal";
		default.WeaponUpgrade_Upgrade[6] = "ZedternalReborn.WMUpgrade_Weapon_KnockdownPower";
		default.WeaponUpgrade_Upgrade[7] = "ZedternalReborn.WMUpgrade_Weapon_MagSize";
		default.WeaponUpgrade_Upgrade[8] = "ZedternalReborn.WMUpgrade_Weapon_MagSize_Small";
		default.WeaponUpgrade_Upgrade[9] = "ZedternalReborn.WMUpgrade_Weapon_MeleeAttackSpeed";
		default.WeaponUpgrade_Upgrade[10] = "ZedternalReborn.WMUpgrade_Weapon_Penetration";
		default.WeaponUpgrade_Upgrade[11] = "ZedternalReborn.WMUpgrade_Weapon_RateOfFire";
		default.WeaponUpgrade_Upgrade[12] = "ZedternalReborn.WMUpgrade_Weapon_Recoil";
		default.WeaponUpgrade_Upgrade[13] = "ZedternalReborn.WMUpgrade_Weapon_ReloadSpeed";
		default.WeaponUpgrade_Upgrade[14] = "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo";
		default.WeaponUpgrade_Upgrade[15] = "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo_C4";
		default.WeaponUpgrade_Upgrade[16] = "ZedternalReborn.WMUpgrade_Weapon_StumblePower";
		default.WeaponUpgrade_Upgrade[17] = "ZedternalReborn.WMUpgrade_Weapon_StunPower";
		default.WeaponUpgrade_Upgrade[18] = "ZedternalReborn.WMUpgrade_Weapon_SwitchSpeed";
		default.WeaponUpgrade_Upgrade[19] = "ZedternalReborn.WMUpgrade_Weapon_TightChoke";
		default.WeaponUpgrade_Upgrade[20] = "ZedternalReborn.WMUpgrade_Weapon_AmmunitionConsumption";
		default.WeaponUpgrade_Upgrade[21] = "ZedternalReborn.WMUpgrade_Weapon_Damage_Fleshpound";

		default.WeaponUpgrade_StaticUpgrade[0] = "ZedternalReborn.WMUpgrade_Weapon_Damage";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckConfigValues()
{
	local int i;
	local object Obj;

	for (i = 0; i < default.WeaponUpgrade_Upgrade.Length; ++i)
	{
		Obj = class<WMUpgrade_Weapon>(DynamicLoadObject(default.WeaponUpgrade_Upgrade[i], class'Class', True));
		if (Obj == None)
		{
			`log("ZR Error: Weapon upgrade" @ default.WeaponUpgrade_Upgrade[i] @ "failed to load."
				@"Skip adding the Weapon upgrade to the game."
				@"Please double check the name in the config and make sure the correct mod resources are installed.");
			default.WeaponUpgrade_Upgrade.Remove(i, 1);
			--i;
		}
	}

	for (i = 0; i < default.WeaponUpgrade_StaticUpgrade.Length; ++i)
	{
		Obj = class<WMUpgrade_Weapon>(DynamicLoadObject(default.WeaponUpgrade_StaticUpgrade[i], class'Class', True));
		if (Obj == None)
		{
			`log("ZR Error: Static Weapon upgrade" @ default.WeaponUpgrade_StaticUpgrade[i] @ "failed to load."
				@"Skip adding the static Weapon upgrade to the game."
				@"Please double check the name in the config and make sure the correct mod resources are installed.");
			default.WeaponUpgrade_StaticUpgrade.Remove(i, 1);
			--i;
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponUpgrade"
}
