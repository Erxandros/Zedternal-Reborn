class WMWeap_Revolver_SW500_Precious extends KFWeap_Revolver_SW500;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Revolver_DualSW500_Precious'
	MagazineCapacity(0)=8 //50% increase (round up)
	SpareAmmoCapacity(0)=120 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=200.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=29.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_SW500_Precious"
}
