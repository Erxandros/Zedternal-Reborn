class WMWeap_Shotgun_Nailgun_Precious extends WMWeap_Shotgun_Nailgun;

defaultproperties
{
	MagazineCapacity(0)=63
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=454
	InstantHitDamage(ALTFIRE_FIREMODE)=44
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Nail_Nailgun_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=44
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Nail_Nailgun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_Nailgun_Precious"
}
