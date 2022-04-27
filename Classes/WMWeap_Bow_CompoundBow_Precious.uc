class WMWeap_Bow_CompoundBow_Precious extends KFWeap_Bow_CompoundBow;

defaultproperties
{
	SpareAmmoCapacity(0)=42
	FireInterval(ALTFIRE_FIREMODE)=0.1
	InstantHitDamage(ALTFIRE_FIREMODE)=70
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_CompoundBowCryo_Precious'
	InstantHitDamage(BASH_FIREMODE)=140
	FireInterval(DEFAULT_FIREMODE)=0.1
	InstantHitDamage(DEFAULT_FIREMODE)=350
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_CompoundBowSharp_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Bow_CompoundBow_Precious"
}
