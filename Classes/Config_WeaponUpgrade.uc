class Config_WeaponUpgrade extends Config_Base
	config(Zedternal);

var config int MODEVERSION;

var config array< string > WeaponUpgrade_WeaponUpgrades;
var config array< string > WeaponUpgrade_StaticWeaponUpgrades;
var config int WeaponUpgrade_NumberUpgradePerWeapon;
var config int WeaponUpgrade_MaxLevel;
var config float WeaponUpgrade_PriceFactor;
var config int WeaponUpgrade_PriceUnit;

	
static function UpdateConfig()
{
	local int index;

	if (default.MODEVERSION < 2)
	{
		default.WeaponUpgrade_PriceFactor = 0.150000;
		default.WeaponUpgrade_PriceUnit = 50;
		default.WeaponUpgrade_NumberUpgradePerWeapon = 3;
		default.WeaponUpgrade_MaxLevel = 3;
		
		default.WeaponUpgrade_WeaponUpgrades.length=22;
		default.WeaponUpgrade_WeaponUpgrades[0]="Zedternal.WMUpgrade_Weapon_Damage";
		default.WeaponUpgrade_WeaponUpgrades[1]="Zedternal.WMUpgrade_Weapon_Damage_Clot";
		default.WeaponUpgrade_WeaponUpgrades[2]="Zedternal.WMUpgrade_Weapon_Damage_GroundFire";
		default.WeaponUpgrade_WeaponUpgrades[3]="Zedternal.WMUpgrade_Weapon_Damage_Headshot";
		default.WeaponUpgrade_WeaponUpgrades[4]="Zedternal.WMUpgrade_Weapon_DamageTaken";
		default.WeaponUpgrade_WeaponUpgrades[5]="Zedternal.WMUpgrade_Weapon_HardMeleeAttack";
		default.WeaponUpgrade_WeaponUpgrades[6]="Zedternal.WMUpgrade_Weapon_Heal";
		default.WeaponUpgrade_WeaponUpgrades[7]="Zedternal.WMUpgrade_Weapon_KnockdownPower";
		default.WeaponUpgrade_WeaponUpgrades[8]="Zedternal.WMUpgrade_Weapon_MagSize";
		default.WeaponUpgrade_WeaponUpgrades[9]="Zedternal.WMUpgrade_Weapon_MagSize_Small";
		default.WeaponUpgrade_WeaponUpgrades[10]="Zedternal.WMUpgrade_Weapon_MeleeAttackSpeed";
		default.WeaponUpgrade_WeaponUpgrades[11]="Zedternal.WMUpgrade_Weapon_Penetration";
		default.WeaponUpgrade_WeaponUpgrades[12]="Zedternal.WMUpgrade_Weapon_RateOfFire";
		default.WeaponUpgrade_WeaponUpgrades[13]="Zedternal.WMUpgrade_Weapon_Recoil";
		default.WeaponUpgrade_WeaponUpgrades[14]="Zedternal.WMUpgrade_Weapon_ReloadSpeed";
		default.WeaponUpgrade_WeaponUpgrades[15]="Zedternal.WMUpgrade_Weapon_SpareAmmo";
		default.WeaponUpgrade_WeaponUpgrades[16]="Zedternal.WMUpgrade_Weapon_SpareAmmo_C4";
		default.WeaponUpgrade_WeaponUpgrades[17]="Zedternal.WMUpgrade_Weapon_StumblePower";
		default.WeaponUpgrade_WeaponUpgrades[18]="Zedternal.WMUpgrade_Weapon_StunPower";
		default.WeaponUpgrade_WeaponUpgrades[19]="Zedternal.WMUpgrade_Weapon_SwitchSpeed";
		default.WeaponUpgrade_WeaponUpgrades[20]="Zedternal.WMUpgrade_Weapon_TightChoke";
		default.WeaponUpgrade_WeaponUpgrades[21]="Zedternal.WMUpgrade_Weapon_AmmunitionConsomption";
	}
	
	if (default.MODEVERSION < 10)
	{
		default.WeaponUpgrade_WeaponUpgrades.AddItem("Zedternal.WMUpgrade_Weapon_Damage_Fleshpound");
	}
	
	if (default.MODEVERSION < 13)
	{
		// adding new static weapon upgrade variable
		default.WeaponUpgrade_StaticWeaponUpgrades.length=1;
		default.WeaponUpgrade_StaticWeaponUpgrades[0]="Zedternal.WMUpgrade_Weapon_Damage";
		
		// remove damage upgrade from the pool
		index = default.WeaponUpgrade_WeaponUpgrades.Find("Zedternal.WMUpgrade_Weapon_Damage");
		if (index >= 0)
			default.WeaponUpgrade_WeaponUpgrades.Remove(index, 1);
	}
	
	if (default.MODEVERSION < class'Zedternal.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'Zedternal.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}
	
defaultproperties
{
}