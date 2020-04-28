class WMWeap_Shotgun_MB500_Precious extends KFWeap_Shotgun_MB500;

defaultproperties
{
	MagazineCapacity(0)=12 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=68 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=25.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_MB500_Precious"
}
