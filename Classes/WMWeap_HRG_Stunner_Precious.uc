class WMWeap_HRG_Stunner_Precious extends KFWeap_HRG_Stunner;

defaultproperties
{
	MagazineCapacity(0)=38 //50% increase (round up)
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=270 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=75.0 //25% increase
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bullet_HRG_Stunner_Alt_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=25.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=33.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Stunner_Precious"
}
