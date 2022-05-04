class WMWeap_HRG_Vampire_Precious extends KFWeap_HRG_Vampire;

defaultproperties
{
	MagazineCapacity(0)=80
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=336
	AmmoCost(ALTFIRE_FIREMODE)=15
	InstantHitDamage(ALTFIRE_FIREMODE)=432
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_CrystalSpike_HRG_Vampire_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(CUSTOM_FIREMODE)=203
	WeaponProjectiles(CUSTOM_FIREMODE)=class'ZedternalReborn.WMProj_BloodBall_HRG_Vampire_Precious'
	FireInterval(DEFAULT_FIREMODE)=0.075
	MinAmmoConsumed=2
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Vampire_Precious"
}
