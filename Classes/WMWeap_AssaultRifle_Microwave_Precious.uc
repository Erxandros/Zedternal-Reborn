class WMWeap_AssaultRifle_Microwave_Precious extends KFWeap_AssaultRifle_Microwave;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=384
	InstantHitDamage(ALTFIRE_FIREMODE)=63
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_MicrowaveRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=63
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_MicrowaveRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_AssaultRifle_Microwave_Precious"
}
