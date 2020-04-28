class WMWeap_HRG_Nailgun_Precious extends KFWeap_HRG_Nailgun;

defaultproperties
{
	MagazineCapacity(0)=63 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=404 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Nailgun_Precious"
}
