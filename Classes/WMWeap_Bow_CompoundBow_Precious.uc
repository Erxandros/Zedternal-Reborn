class WMWeap_Bow_CompoundBow_Precious extends KFWeap_Bow_CompoundBow;

defaultproperties
{
	MagazineCapacity(0)=2 //50% increase  (round up)
	AmmoPickupScale(0)=1.5 //50% decrease
	SpareAmmoCapacity(0)=36 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=313.0 //25% increase (round up)
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_CompoundBowCryo_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=63.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=125.0 //25% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Bow_CompoundBow_Precious_Precious"
}
