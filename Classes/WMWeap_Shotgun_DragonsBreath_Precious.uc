class WMWeap_Shotgun_DragonsBreath_Precious extends KFWeap_Shotgun_DragonsBreath;

defaultproperties
{
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=72 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=44.00 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=32.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_DragonsBreath_Precious"
}
