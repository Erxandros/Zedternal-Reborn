class WMUpgrade_Equipment_NightVision extends WMUpgrade_Equipment;

static simulated function bool HasNightVision(int upgLevel)
{
	return True;
}

defaultproperties
{
	UpgradeName="Night Vision"
	UpgradeDescription(0)="Grants night vision ability"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_NightVision'

	Name="Default__WMUpgrade_Equipment_NightVision"
}
