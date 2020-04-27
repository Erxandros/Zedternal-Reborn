class WMWeap_SMG_P90_Precious extends KFWeap_SMG_P90;

defaultproperties
{
	MagazineCapacity(0)=75 //50% increase
	SpareAmmoCapacity(0)=420 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_P90_Precious"
}
