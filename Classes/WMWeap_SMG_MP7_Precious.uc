class WMWeap_SMG_MP7_Precious extends KFWeap_SMG_MP7;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=396
	InstantHitDamage(ALTFIRE_FIREMODE)=20
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=20
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_MP7_Precious"
}
