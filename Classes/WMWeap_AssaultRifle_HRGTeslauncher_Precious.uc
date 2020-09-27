class WMWeap_AssaultRifle_HRGTeslauncher_Precious extends WMWeap_AssaultRifle_HRGTeslauncher;

defaultproperties
{
	MagazineCapacity(0)=45 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=288 //20% increase
	MagazineCapacity(1)=2 //50% increase (round up)
	AmmoPickupScale(1)=1.0 //50% decrease
	SpareAmmoCapacity(1)=9 //20% increase (round up)
	InstantHitDamage(DEFAULT_FIREMODE)=85.0 //25% increase
	WeaponProjectiles(ALTFIRE_FIREMODE)=Class'ZedternalReborn.WMProj_Grenade_HRGTeslauncher_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_HRGTeslauncher_Precious"
}
