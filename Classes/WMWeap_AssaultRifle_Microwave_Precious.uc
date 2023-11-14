class WMWeap_AssaultRifle_Microwave_Precious extends KFWeap_AssaultRifle_Microwave;

defaultproperties
{
	MagazineCapacity(0)=80
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=448
	InstantHitDamage(ALTFIRE_FIREMODE)=68
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_MicrowaveRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=68
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_MicrowaveRifle_Precious'
	Name="Default__WMWeap_AssaultRifle_Microwave_Precious"
}
