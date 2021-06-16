class WMWeap_HRG_BarrierRifle_Precious extends KFWeap_HRG_BarrierRifle;

defaultproperties
{
	MagazineCapacity(0)=90 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=648 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=42.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_BarrierRifle_Precious"
}
