class WMWeap_Shotgun_Nailgun_Precious extends WMWeap_Shotgun_Nailgun;

defaultproperties
{
	MagazineCapacity(0)=63 //50% increase
	SpareAmmoCapacity(0)=404 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=44.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=44.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_Nailgun_Precious"
}
