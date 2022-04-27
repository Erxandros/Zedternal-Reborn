class WMWeap_Rifle_FrostShotgunAxe_Precious extends KFWeap_Rifle_FrostShotgunAxe;

defaultproperties
{
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=80
	InstantHitDamage(BASH_FIREMODE)=94
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Frost_Shotgun_Axe_Precious'
	InstantHitDamage(HEAVY_ATK_FIREMODE)=63
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_FrostShotgunAxe_Precious"
}
