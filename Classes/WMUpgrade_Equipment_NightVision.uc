class WMUpgrade_Equipment_NightVision extends WMUpgrade_Equipment;

static simulated function bool HasNightVision(int upgLevel)
{
	return True;
}

defaultproperties
{
	upgradeName="Night Vision"
	upgradeDescription(0)="Grants night vision ability"
	upgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_NightVision'

	Name="Default__WMUpgrade_Equipment_NightVision"
}
