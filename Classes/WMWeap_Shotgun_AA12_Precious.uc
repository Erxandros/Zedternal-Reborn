class WMWeap_Shotgun_AA12_Precious extends KFWeap_Shotgun_AA12;

defaultproperties
{
	MagazineCapacity(0)=30 //50% increase
	SpareAmmoCapacity(0)=144 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=25.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_AA12_Precious"
}
