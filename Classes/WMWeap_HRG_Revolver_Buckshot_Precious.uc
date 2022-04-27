class WMWeap_HRG_Revolver_Buckshot_Precious extends KFWeap_HRG_Revolver_Buckshot;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_HRG_Revolver_DualBuckshot_Precious'
	MagazineCapacity(0)=8
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=102
	InstantHitDamage(BASH_FIREMODE)=29
	InstantHitDamage(DEFAULT_FIREMODE)=40
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pellet_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Revolver_Buckshot_Precious"
}
