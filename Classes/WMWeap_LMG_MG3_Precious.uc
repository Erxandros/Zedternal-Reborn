class WMWeap_LMG_MG3_Precious extends KFWeap_LMG_MG3;

defaultproperties
{
	MagazineCapacity(0)=150
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=735
	InstantHitDamage(ALTFIRE_FIREMODE)=21
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_MG3_Alt_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=48
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	Name="Default__WMWeap_LMG_MG3_Precious"
}
