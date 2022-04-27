class WMWeap_HRG_Revolver_DualBuckshot_Precious extends KFWeap_HRG_Revolver_DualBuckshot;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_HRG_Revolver_Buckshot_Precious'
	MagazineCapacity(0)=15
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=96
	InstantHitDamage(ALTFIRE_FIREMODE)=40
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=40
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Revolver_DualBuckshot_Precious"
}
