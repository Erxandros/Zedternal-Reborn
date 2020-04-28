class WMWeap_Revolver_DualRem1858_Precious extends KFWeap_Revolver_DualRem1858;

defaultproperties
{
	SingleClass=Class'ZedternalReborn.WMWeap_Revolver_Rem1858_Precious'
	MagazineCapacity(0)=18 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=173 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_DualSW500_Precious"
}
