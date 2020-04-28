class WMWeap_Shotgun_DoubleBarrel_Precious extends KFWeap_Shotgun_DoubleBarrel;

defaultproperties
{
	MagazineCapacity(0)=3 //50% increase
	AmmoPickupScale(0)=1.5 //50% decrease
	SpareAmmoCapacity(0)=56 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=32.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=30.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_DoubleBarrel_Precious"
}
