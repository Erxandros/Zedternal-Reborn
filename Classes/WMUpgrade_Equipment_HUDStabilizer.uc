class WMUpgrade_Equipment_HUDStabilizer extends WMUpgrade_Equipment;

static simulated function bool ImmuneToCameraShake(int upgLevel, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	UpgradeName="HUD Stabilizer"
	UpgradeDescription(0)="Stabilizes your HUD against external shocks and shakes"
	UpgradeIcon(0)=Texture2D'ZedternalReborn_Resource.Equipment.UI_Equipment_HUDStabilizer'

	Name="Default__WMUpgrade_Equipment_HUDStabilizer"
}
