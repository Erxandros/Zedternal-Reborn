class WMWeap_SMG_HK_UMP_Precious extends KFWeap_SMG_HK_UMP;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	SpareAmmoCapacity(0)=348 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=57.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=57.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_HK_UMP_Precious"
}
