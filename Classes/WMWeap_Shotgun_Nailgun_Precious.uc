class WMWeap_Shotgun_Nailgun_Precious extends WMWeap_Shotgun_Nailgun;

defaultproperties
{
	MagazineCapacity(0)=84
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=530
	InstantHitDamage(ALTFIRE_FIREMODE)=48
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Nail_Nailgun_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=48
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Nail_Nailgun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_Nailgun_Precious"
}
