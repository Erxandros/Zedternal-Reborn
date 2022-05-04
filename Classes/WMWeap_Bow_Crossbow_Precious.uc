class WMWeap_Bow_Crossbow_Precious extends KFWeap_Bow_Crossbow;

defaultproperties
{
	SpareAmmoCapacity(0)=48
	InstantHitDamage(BASH_FIREMODE)=39
	FireInterval(DEFAULT_FIREMODE)=0.15
	InstantHitDamage(DEFAULT_FIREMODE)=525
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_Crossbow_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Bow_Crossbow_Precious"
}
