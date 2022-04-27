class WMWeap_SMG_Kriss_Precious extends KFWeap_SMG_Kriss;

defaultproperties
{
	MagazineCapacity(0)=50
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=594
	InstantHitDamage(ALTFIRE_FIREMODE)=42
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=42
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_SMG_Kriss_Precious"
}
