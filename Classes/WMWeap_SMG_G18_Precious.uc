class WMWeap_SMG_G18_Precious extends KFWeap_SMG_G18;

defaultproperties
{
	MagazineCapacity(0)=50
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=555
	InstantHitDamage(ALTFIRE_FIREMODE)=35
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18_Precious'
	InstantHitDamage(BASH_FIREMODE)=44
	InstantHitDamage(DEFAULT_FIREMODE)=35
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_G18_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_G18_Precious"
}
