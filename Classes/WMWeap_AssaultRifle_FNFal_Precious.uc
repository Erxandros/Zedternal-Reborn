class WMWeap_AssaultRifle_FNFal_Precious extends KFWeap_AssaultRifle_FNFal;

defaultproperties
{
	MagazineCapacity(0)=30 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=192 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=88.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=88.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_FNFal_Precious"
}
