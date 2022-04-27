class WMWeap_Revolver_DualSW500_Precious extends KFWeap_Revolver_DualSW500;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Revolver_SW500_Precious'
	MagazineCapacity(0)=15
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=114
	InstantHitDamage(ALTFIRE_FIREMODE)=200
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RevolverSW500_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=200
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RevolverSW500_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_DualSW500_Precious"
}
