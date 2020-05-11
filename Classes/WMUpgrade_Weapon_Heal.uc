Class WMUpgrade_Weapon_Heal extends WMUpgrade_Weapon
	abstract;

var float Heal;

// Only Medic weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_MedicBase>(KFW) != none)
		return true;
	else if (class<KFWeap_Rifle_HRGIncision>(KFW) != none)
		return true;
	else if (class<KFWeap_HRG_Healthrower>(KFW) != none)
		return true;
	else if (class<KFWeap_Blunt_MedicBat>(KFW) != none)
		return true;

	return false;
}

static function ModifyHealAmount( out float InHealAmount, float DefaultHealAmount, int upgLevel)
{
	InHealAmount += DefaultHealAmount * default.Heal * upgLevel;
}

defaultproperties
{
	upgradeName="Heal Potency"
	upgradeDescription(0)="Increase healing potency of this weapon %x%%"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)
	Heal=0.200000
}
