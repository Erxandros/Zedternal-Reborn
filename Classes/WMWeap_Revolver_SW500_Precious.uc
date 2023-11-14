class WMWeap_Revolver_SW500_Precious extends KFWeap_Revolver_SW500;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Revolver_DualSW500_Precious'
	MagazineCapacity(0)=10
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=140
	InstantHitDamage(BASH_FIREMODE)=32
	InstantHitDamage(DEFAULT_FIREMODE)=216
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RevolverSW500_Precious'
	Name="Default__WMWeap_Revolver_SW500_Precious"
}
