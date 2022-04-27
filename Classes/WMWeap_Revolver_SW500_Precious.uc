class WMWeap_Revolver_SW500_Precious extends KFWeap_Revolver_SW500;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Revolver_DualSW500_Precious'
	MagazineCapacity(0)=8
	AmmoPickupScale(0)=1
	SpareAmmoCapacity(0)=120
	InstantHitDamage(BASH_FIREMODE)=29
	InstantHitDamage(DEFAULT_FIREMODE)=200
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_RevolverSW500_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Revolver_SW500_Precious"
}
