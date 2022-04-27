class WMWeap_Rifle_M14EBR_Precious extends KFWeap_Rifle_M14EBR;

defaultproperties
{
	MagazineCapacity(0)=30
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=144
	InstantHitDamage(BASH_FIREMODE)=34
	InstantHitDamage(DEFAULT_FIREMODE)=100
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_M14EBR_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Rifle_M14EBR_Precious"
}
