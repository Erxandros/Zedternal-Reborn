class WMWeap_HRG_Nailgun_Precious extends WMWeap_HRG_Nailgun;

defaultproperties
{
	MagazineCapacity(0)=63
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=404
	InstantHitDamage(ALTFIRE_FIREMODE)=50
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Nail_HRGNailgun_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=50
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Nail_HRGNailgun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Nailgun_Precious"
}
