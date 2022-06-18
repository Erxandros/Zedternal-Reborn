class WMUpgrade_Equipment_Grenade extends WMUpgrade_Equipment;

static simulated function ModifySpareGrenadeAmount(out int SpareGrenade, int DefaultSpareGrenade, int upgLevel)
{
	SpareGrenade += upgLevel;
}

defaultproperties
{
	UpgradeName="Grenades"
	UpgradeDescription(0)="Moar grenades"
	EquipmentBonus(0)=(baseValue=0, incValue=1, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_ArmorUp'

	Name="Default__WMUpgrade_Equipment_Grenade"
}
