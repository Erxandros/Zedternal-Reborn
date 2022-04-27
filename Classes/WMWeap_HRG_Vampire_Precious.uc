class WMWeap_HRG_Vampire_Precious extends KFWeap_HRG_Vampire;

defaultproperties
{
	MagazineCapacity(0)=60
	AmmoPickupScale(0)=0.5
	SpareAmmoCapacity(0)=288
	AmmoCost(ALTFIRE_FIREMODE)=16
	InstantHitDamage(ALTFIRE_FIREMODE)=400
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_CrystalSpike_HRG_Vampire_Precious'
	InstantHitDamage(BASH_FIREMODE)=33
	InstantHitDamage(CUSTOM_FIREMODE)=188
	WeaponProjectiles(CUSTOM_FIREMODE)=class'ZedternalReborn.WMProj_BloodBall_HRG_Vampire_Precious'
	FireInterval(DEFAULT_FIREMODE)=0.08
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Vampire_Precious"
}
