class WMUpgrade_Weapon_Heal extends WMUpgrade_Weapon
	abstract;

var float Heal;

// Only Medic weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_MedicBase>(KFW) != None)
		return True;
	else if (class<KFWeap_Rifle_HRGIncision>(KFW) != None)
		return True;
	else if (class<KFWeap_HRG_Healthrower>(KFW) != None)
		return True;
	else if (class<KFWeap_Blunt_MedicBat>(KFW) != None)
		return True;

	return False;
}

static function ModifyHealAmount(out float InHealAmount, float DefaultHealAmount, int upgLevel)
{
	InHealAmount += DefaultHealAmount * default.Heal * upgLevel;
}

defaultproperties
{
	Heal=0.2f

	upgradeName="Heal Potency"
	upgradeDescription(0)="Increase healing potency of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Heal"
}
