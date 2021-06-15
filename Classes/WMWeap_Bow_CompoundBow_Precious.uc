class WMWeap_Bow_CompoundBow_Precious extends KFWeap_Bow_CompoundBow;

defaultproperties
{
	SpareAmmoCapacity(0)=42 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=350.0 //40% increase
	FireInterval(DEFAULT_FIREMODE)=0.1 //50% increase
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_CompoundBowCryo_Precious'
	InstantHitDamage(ALTFIRE_FIREMODE)=70.0 //40% increase
	FireInterval(ALTFIRE_FIREMODE)=0.1 //50% increase
	InstantHitDamage(BASH_FIREMODE)=140.0 //40% increase
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Bow_CompoundBow_Precious_Precious"
}
