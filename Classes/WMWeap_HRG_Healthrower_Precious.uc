class WMWeap_HRG_Healthrower_Precious extends KFWeap_HRG_Healthrower;

defaultproperties
{
	MagazineCapacity(0)=200
	AmmoPickupScale(0)=0.375
	SpareAmmoCapacity(0)=700
	AmmoCost(ALTFIRE_FIREMODE)=30
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=38
	FireInterval(DEFAULT_FIREMODE)=0.075
	MinAmmoConsumed=2
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Healthrower_Precious"
}
