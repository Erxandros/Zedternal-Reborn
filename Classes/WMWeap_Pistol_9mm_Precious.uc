class WMWeap_Pistol_9mm_Precious extends KFWeap_Pistol_9mm;

defaultproperties
{
	DualClass=class'ZedternalReborn.WMWeap_Pistol_Dual9mm_Precious'
	MagazineCapacity(0)=30
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=105
	InstantHitDamage(BASH_FIREMODE)=27
	InstantHitDamage(DEFAULT_FIREMODE)=34
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_Pistol9mm_Precious'
	Name="Default__WMWeap_Pistol_9mm_Precious"
}
