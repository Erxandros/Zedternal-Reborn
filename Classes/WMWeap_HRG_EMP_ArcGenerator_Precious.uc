class WMWeap_HRG_EMP_ArcGenerator_Precious extends KFWeap_HRG_EMP_ArcGenerator;

defaultproperties
{
	MagazineCapacity(0)=135 //50% increase
	AmmoPickupScale(0)=0.25 //50% decrease
	SpareAmmoCapacity(0)=540 //20% increase
	FireInterval(DEFAULT_FIREMODE)=0.08 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=275 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_EMP_ArcGenerator_Precious"
}
