class WMWeap_Shotgun_M4_Precious extends KFWeap_Shotgun_M4;

defaultproperties
{
	MagazineCapacity(0)=12 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=77 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=35.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_M4_Precious"
}
