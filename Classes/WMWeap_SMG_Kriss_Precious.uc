class WMWeap_SMG_Kriss_Precious extends KFWeap_SMG_Kriss;

defaultproperties
{
	MagazineCapacity(0)=66
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=693
	InstantHitDamage(ALTFIRE_FIREMODE)=45
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=45
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	Name="Default__WMWeap_SMG_Kriss_Precious"
}
