class WMWeap_HRG_Vampire_Precious extends KFWeap_HRG_Vampire;

defaultproperties
{
	MagazineCapacity(0)=60 //50% increase
	MagazineCapacity(1)=150 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=288 //20% increase
	FireInterval(DEFAULT_FIREMODE)=+0.08 //25% increase
	InstantHitDamage(ALTFIRE_FIREMODE)=400.0 //25% increase
	AmmoCost(ALTFIRE_FIREMODE)=16 //20% decrease
	WeaponProjectiles(CUSTOM_FIREMODE)=class'ZedternalReborn.WMProj_BloodBall_HRG_Vampire_Precious'
	InstantHitDamage(CUSTOM_FIREMODE)=188.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Vampire_Precious"
}
