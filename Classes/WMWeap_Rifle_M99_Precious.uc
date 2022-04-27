class WMWeap_Rifle_M99_Precious extends KFWeap_Rifle_M99;

defaultproperties
{
	MagazineCapacity(0)=2
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=24
	InstantHitDamage(BASH_FIREMODE)=38
	InstantHitDamage(DEFAULT_FIREMODE)=1063
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_M99_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_M99_Precious"
}
