class WMWeap_AssaultRifle_AK12_Precious extends KFWeap_AssaultRifle_AK12;

defaultproperties
{
	MagazineCapacity(0)=45
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=360
	InstantHitDamage(ALTFIRE_FIREMODE)=50
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=50
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_AK12_Precious"
}
