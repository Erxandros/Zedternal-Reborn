class WMWeap_Shotgun_HRG_Kaboomstick_Precious extends KFWeap_Shotgun_HRG_Kaboomstick;

defaultproperties
{
	MagazineCapacity(0)=3 //50% increase
	AmmoPickupScale(0)=1.5 //50% decrease
	SpareAmmoCapacity(0)=56 //20% increase (round up)
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRG_Kaboomstick_Precious'
	InstantHitDamage(DEFAULT_FIREMODE)=19.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRG_Kaboomstick_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=19.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_HRG_Kaboomstick_Precious"
}
