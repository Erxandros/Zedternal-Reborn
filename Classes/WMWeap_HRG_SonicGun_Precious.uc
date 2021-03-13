class WMWeap_HRG_SonicGun_Precious extends KFWeap_HRG_SonicGun;

defaultproperties
{
	MagazineCapacity(0)=18 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=116 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=157.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_SonicGun_Precious"
}
