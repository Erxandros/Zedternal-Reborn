class WMUpgrade_Equipment_FallCompensatorBoots extends WMUpgrade_Equipment;

var float DamageResistance;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Falling'))
		InDamage -= Round(float(DefaultDamage) * FMin(default.DamageResistance * upgLevel, 0.8f));
}

defaultproperties
{
	DamageResistance=0.4f

	UpgradeName="Fall Compensator Boots"
	UpgradeDescription(0)="Decrease fall damage by %x%%"
	EquipmentBonus(0)=(baseValue=0, incValue=40, maxValue=80)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_FallCompensatorBoots'

	Name="Default__WMUpgrade_Equipment_FallCompensatorBoots"
}
