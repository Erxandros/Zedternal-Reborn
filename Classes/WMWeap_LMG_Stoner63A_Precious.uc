class WMWeap_LMG_Stoner63A_Precious extends KFWeap_LMG_Stoner63A;

defaultproperties
{
	MagazineCapacity(0)=113
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=600
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(DEFAULT_FIREMODE)=38
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_AssaultRifle_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_LMG_Stoner63A_Precious"
}
