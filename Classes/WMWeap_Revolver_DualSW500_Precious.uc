class WMWeap_Revolver_DualSW500_Precious extends KFWeap_Revolver_DualSW500;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Revolver_SW500_Precious'
	MagazineCapacity(0)=16 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=114 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=200.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=200.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_DualSW500_Precious"
}
