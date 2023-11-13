class WMWeap_HRG_93R_Dual_Precious extends KFWeap_HRG_93R_Dual;

defaultproperties
{
	SingleClass=class'ZedternalReborn.WMWeap_HRG_93R_Precious'
	MagazineCapacity(0)=120
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=336
	InstantHitDamage(ALTFIRE_FIREMODE)=21
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	InstantHitDamage(BASH_FIREMODE)=30
	InstantHitDamage(DEFAULT_FIREMODE)=21
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_93R_Dual_Precious"
}
