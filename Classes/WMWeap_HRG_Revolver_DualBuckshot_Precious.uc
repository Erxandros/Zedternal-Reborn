class WMWeap_HRG_Revolver_DualBuckshot_Precious extends KFWeap_HRG_Revolver_DualBuckshot;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_HRG_Revolver_Buckshot_Precious'
	MagazineCapacity(0)=20
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=112
	InstantHitDamage(ALTFIRE_FIREMODE)=44
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=44
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Revolver_DualBuckshot_Precious"
}
