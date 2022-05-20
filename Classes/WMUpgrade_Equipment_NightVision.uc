class WMUpgrade_Equipment_NightVision extends WMUpgrade_Equipment;

static simulated function bool HasNightVision(int upgLevel)
{
	return True;
}

defaultproperties
{
	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Equipment_NightVision"
	LocalizeDescriptionLineCount=1
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_NightVision'

	Name="Default__WMUpgrade_Equipment_NightVision"
}
