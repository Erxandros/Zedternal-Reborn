class WMWeap_Shotgun_HZ12_Precious extends KFWeap_Shotgun_HZ12;

defaultproperties
{
	MagazineCapacity(0)=24
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=96
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=25
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_HZ12_Precious"
}
