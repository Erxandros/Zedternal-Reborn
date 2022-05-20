class WMUpgrade_Equipment_HUDStabilizer extends WMUpgrade_Equipment;

static simulated function bool ImmuneToCameraShake(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Equipment_HUDStabilizer"
	LocalizeDescriptionLineCount=1
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_HUDStabilizer'

	Name="Default__WMUpgrade_Equipment_HUDStabilizer"
}
