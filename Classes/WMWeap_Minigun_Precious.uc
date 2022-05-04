class WMWeap_Minigun_Precious extends KFWeap_Minigun;

defaultproperties
{
	MagazineCapacity(0)=180
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=756
	InstantHitDamage(BASH_FIREMODE)=41
	InstantHitDamage(DEFAULT_FIREMODE)=48
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Minigun_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Minigun_Precious"
}
