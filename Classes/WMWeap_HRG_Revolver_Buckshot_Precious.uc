class WMWeap_HRG_Revolver_Buckshot_Precious extends KFWeap_HRG_Revolver_Buckshot;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_HRG_Revolver_DualBuckshot_Precious'
	MagazineCapacity(0)=10
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=119
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=44
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	Name="Default__WMWeap_HRG_Revolver_Buckshot_Precious"
}
