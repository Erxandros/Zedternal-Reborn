class WMWeap_Shotgun_ElephantGun_Precious extends KFWeap_Shotgun_ElephantGun;

defaultproperties
{
	MagazineCapacity(0)=6 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=58 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=50.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=50.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=34.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_ElephantGun_Precious"
}
