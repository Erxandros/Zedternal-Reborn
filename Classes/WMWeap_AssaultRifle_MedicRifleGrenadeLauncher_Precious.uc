class WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious extends KFWeap_AssaultRifle_MedicRifleGrenadeLauncher;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=252 //20% increase
	MagazineCapacity(1)=2 //50% increase (round up)
	AmmoPickupScale(1)=0.5 //50% decrease
	SpareAmmoCapacity(1)=11 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=59.0 //25% increase (round up)
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=Class'ZedternalReborn.WMProj_MedicGrenade_Mini_Precious'
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_MedicRifleGrenadeLauncher_Precious"
}
