class WMWeap_AssaultRifle_LazerCutter_Precious extends KFWeap_AssaultRifle_LazerCutter;

defaultproperties
{
	MagazineCapacity(0)=75
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=360
	InstantHitDamage(ALTFIRE_FIREMODE)=50
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_LazerCutter_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=63
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_LazerCutter_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_LazerCutter_Precious"
}
