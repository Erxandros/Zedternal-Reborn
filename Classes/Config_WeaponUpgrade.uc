class Config_WeaponUpgrade extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

var config int WeaponUpgrade_PriceUnit;
var config float WeaponUpgrade_PriceFactor;
var config int WeaponUpgrade_NumberUpgradePerWeapon;
var config int WeaponUpgrade_MaxLevel;
var config array< string > WeaponUpgrade_WeaponUpgrades;
var config array< string > WeaponUpgrade_StaticWeaponUpgrades;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.WeaponUpgrade_PriceUnit = 50;
		default.WeaponUpgrade_PriceFactor = 0.150000;
		default.WeaponUpgrade_NumberUpgradePerWeapon = 3;
		default.WeaponUpgrade_MaxLevel = 3;

		default.WeaponUpgrade_WeaponUpgrades.length = 22;
		default.WeaponUpgrade_WeaponUpgrades[0] = "ZedternalReborn.WMUpgrade_Weapon_Damage_Clot";
		default.WeaponUpgrade_WeaponUpgrades[1] = "ZedternalReborn.WMUpgrade_Weapon_Damage_GroundFire";
		default.WeaponUpgrade_WeaponUpgrades[2] = "ZedternalReborn.WMUpgrade_Weapon_Damage_Headshot";
		default.WeaponUpgrade_WeaponUpgrades[3] = "ZedternalReborn.WMUpgrade_Weapon_DamageTaken";
		default.WeaponUpgrade_WeaponUpgrades[4] = "ZedternalReborn.WMUpgrade_Weapon_HardMeleeAttack";
		default.WeaponUpgrade_WeaponUpgrades[5] = "ZedternalReborn.WMUpgrade_Weapon_Heal";
		default.WeaponUpgrade_WeaponUpgrades[6] = "ZedternalReborn.WMUpgrade_Weapon_KnockdownPower";
		default.WeaponUpgrade_WeaponUpgrades[7] = "ZedternalReborn.WMUpgrade_Weapon_MagSize";
		default.WeaponUpgrade_WeaponUpgrades[8] = "ZedternalReborn.WMUpgrade_Weapon_MagSize_Small";
		default.WeaponUpgrade_WeaponUpgrades[9] = "ZedternalReborn.WMUpgrade_Weapon_MeleeAttackSpeed";
		default.WeaponUpgrade_WeaponUpgrades[10] = "ZedternalReborn.WMUpgrade_Weapon_Penetration";
		default.WeaponUpgrade_WeaponUpgrades[11] = "ZedternalReborn.WMUpgrade_Weapon_RateOfFire";
		default.WeaponUpgrade_WeaponUpgrades[12] = "ZedternalReborn.WMUpgrade_Weapon_Recoil";
		default.WeaponUpgrade_WeaponUpgrades[13] = "ZedternalReborn.WMUpgrade_Weapon_ReloadSpeed";
		default.WeaponUpgrade_WeaponUpgrades[14] = "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo";
		default.WeaponUpgrade_WeaponUpgrades[15] = "ZedternalReborn.WMUpgrade_Weapon_SpareAmmo_C4";
		default.WeaponUpgrade_WeaponUpgrades[16] = "ZedternalReborn.WMUpgrade_Weapon_StumblePower";
		default.WeaponUpgrade_WeaponUpgrades[17] = "ZedternalReborn.WMUpgrade_Weapon_StunPower";
		default.WeaponUpgrade_WeaponUpgrades[18] = "ZedternalReborn.WMUpgrade_Weapon_SwitchSpeed";
		default.WeaponUpgrade_WeaponUpgrades[19] = "ZedternalReborn.WMUpgrade_Weapon_TightChoke";
		default.WeaponUpgrade_WeaponUpgrades[20] = "ZedternalReborn.WMUpgrade_Weapon_AmmunitionConsomption";
		default.WeaponUpgrade_WeaponUpgrades[21] = "ZedternalReborn.WMUpgrade_Weapon_Damage_Fleshpound";

		default.WeaponUpgrade_StaticWeaponUpgrades.length = 1;
		default.WeaponUpgrade_StaticWeaponUpgrades[0] = "ZedternalReborn.WMUpgrade_Weapon_Damage";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
}