class WMWeap_Rifle_FrostShotgunAxe_Precious extends KFWeap_Rifle_FrostShotgunAxe;

defaultproperties
{
	MagazineCapacity(0)=9 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=80 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=38.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=94.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_FrostShotgunAxe_Precious"
}
