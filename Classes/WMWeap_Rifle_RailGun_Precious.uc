class WMWeap_Rifle_RailGun_Precious extends KFWeap_Rifle_RailGun;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=1.5
	SpareAmmoCapacity(0)=45
	InstantHitDamage(ALTFIRE_FIREMODE)=756
	InstantHitDamage(BASH_FIREMODE)=41
	InstantHitDamage(DEFAULT_FIREMODE)=378
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RailGun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_RailGun_Precious"
}
