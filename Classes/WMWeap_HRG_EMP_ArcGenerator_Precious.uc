class WMWeap_HRG_EMP_ArcGenerator_Precious extends KFWeap_HRG_EMP_ArcGenerator;

defaultproperties
{
	MagazineCapacity(0)=180
	AmmoPickupScale(0)=0.25
	SpareAmmoCapacity(0)=630
	InstantHitDamage(ALTFIRE_FIREMODE)=297
	InstantHitDamage(BASH_FIREMODE)=36
	FireInterval(DEFAULT_FIREMODE)=0.075
	MinAmmoConsumed=1
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_EMP_ArcGenerator_Precious"
}
