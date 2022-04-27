class WMWeap_Revolver_Rem1858_Precious extends KFWeap_Revolver_Rem1858;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Revolver_DualRem1858_Precious'
	MagazineCapacity(0)=9
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=173
	InstantHitDamage(BASH_FIREMODE)=28
	InstantHitDamage(DEFAULT_FIREMODE)=63
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RevolverRem1858_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_Rem1858_Precious"
}
