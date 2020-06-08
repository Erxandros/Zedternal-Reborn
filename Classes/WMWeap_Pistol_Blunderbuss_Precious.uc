class WMWeap_Pistol_Blunderbuss_Precious extends KFWeap_Pistol_Blunderbuss;

defaultproperties
{
	MagazineCapacity(0)=5 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=47 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Cannonball_Blunderbuss_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=375.0 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Pistol_Blunderbuss_Precious"
}
