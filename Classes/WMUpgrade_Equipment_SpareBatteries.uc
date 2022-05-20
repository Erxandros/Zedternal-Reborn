class WMUpgrade_Equipment_SpareBatteries extends WMUpgrade_Equipment;

var float Recharge;

static simulated function GetBatteryRateScale(out float InRechargeRateFL, out float InRechargeRateNVG, int upgLevel, KFPawn OwnerPawn)
{
	InRechargeRateFL = 1.0f / (1.0f / InRechargeRateFL + default.Recharge * upgLevel);
	InRechargeRateNVG = 1.0f / (1.0f / InRechargeRateNVG + default.Recharge * upgLevel);
}

defaultproperties
{
	Recharge=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Equipment_SpareBatteries"
	LocalizeDescriptionLineCount=1
	EquipmentBonus(0)=(baseValue=0, incValue=50, maxValue=-1)
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_Batteries'

	Name="Default__WMUpgrade_Equipment_SpareBatteries"
}
