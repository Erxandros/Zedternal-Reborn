class WMWeap_Shotgun_HZ12_Precious extends KFWeap_Shotgun_HZ12;

defaultproperties
{
	MagazineCapacity(0)=24 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=96 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_HZ12_Precious"
}
