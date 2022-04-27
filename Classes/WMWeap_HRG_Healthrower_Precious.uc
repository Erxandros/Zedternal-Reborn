class WMWeap_HRG_Healthrower_Precious extends KFWeap_HRG_Healthrower;

defaultproperties
{
	MagazineCapacity(0)=150
	AmmoPickupScale(0)=0.375
	SpareAmmoCapacity(0)=600
	AmmoCost(ALTFIRE_FIREMODE)=32
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_HealingDart_MedicBase_Precious'
	InstantHitDamage(BASH_FIREMODE)=35
	FireInterval(DEFAULT_FIREMODE)=0.08
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Healthrower_Precious"
}
