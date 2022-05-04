class WMWeap_Shotgun_HRG_Kaboomstick_Precious extends KFWeap_Shotgun_HRG_Kaboomstick;

defaultproperties
{
	MagazineCapacity(0)=4
	AmmoPickupScale(0)=1.5
	SpareAmmoCapacity(0)=65
	InstantHitDamage(ALTFIRE_FIREMODE)=21
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRG_Kaboomstick_Precious'
	InstantHitDamage(BASH_FIREMODE)=36
	InstantHitDamage(DEFAULT_FIREMODE)=21
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Explosive_HRG_Kaboomstick_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Shotgun_HRG_Kaboomstick_Precious"
}
