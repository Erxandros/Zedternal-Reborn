class WMWeap_HRG_BarrierRifle_Precious extends KFWeap_HRG_BarrierRifle;

defaultproperties
{
	MagazineCapacity(0)=90
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=648
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=42
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_BarrierRifle_Precious"
}
