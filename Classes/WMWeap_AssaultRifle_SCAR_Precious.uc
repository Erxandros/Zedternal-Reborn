class WMWeap_AssaultRifle_SCAR_Precious extends KFWeap_AssaultRifle_SCAR;

defaultproperties
{
	MagazineCapacity(0)=30 //50% increase
	SpareAmmoCapacity(0)=408 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=69.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=69.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_SCAR_Precious"
}
