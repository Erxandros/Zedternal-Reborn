class WMWeap_Shotgun_MB500_Precious extends KFWeap_Shotgun_MB500;

defaultproperties
{
	MagazineCapacity(0)=12
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=68
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=25
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_MB500_Precious"
}
