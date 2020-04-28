class WMWeap_Revolver_Rem1858_Precious extends KFWeap_Revolver_Rem1858;

defaultproperties
{
	DualClass=Class'ZedternalReborn.WMWeap_Revolver_DualRem1858_Precious'
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=1.0 //50% decrease
	SpareAmmoCapacity(0)=173 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=28.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_Rem1858_Precious"
}
