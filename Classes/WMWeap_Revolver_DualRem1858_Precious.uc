class WMWeap_Revolver_DualRem1858_Precious extends KFWeap_Revolver_DualRem1858;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_Revolver_Rem1858_Precious'
	MagazineCapacity(0)=24
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=202
	InstantHitDamage(ALTFIRE_FIREMODE)=68
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RevolverRem1858_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=68
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RevolverRem1858_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_DualRem1858_Precious"
}
