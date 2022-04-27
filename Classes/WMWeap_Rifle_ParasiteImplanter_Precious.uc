class WMWeap_Rifle_ParasiteImplanter_Precious extends KFWeap_Rifle_ParasiteImplanter;

defaultproperties
{
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=94
	MagazineCapacity(1)=150
	InstantHitDamage(ALTFIRE_FIREMODE)=2
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_ParasiteImplanterAlt_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=344
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_ParasiteImplanter_Precious'
	SeedAmmo=150
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_ParasiteImplanter_Precious"
}
