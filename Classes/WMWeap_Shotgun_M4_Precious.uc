class WMWeap_Shotgun_M4_Precious extends KFWeap_Shotgun_M4;

defaultproperties
{
	MagazineCapacity(0)=16
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=90
	InstantHitDamage(BASH_FIREMODE)=38
	InstantHitDamage(DEFAULT_FIREMODE)=41
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_M4_Precious"
}
