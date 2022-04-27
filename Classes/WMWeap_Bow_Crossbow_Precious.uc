class WMWeap_Bow_Crossbow_Precious extends KFWeap_Bow_Crossbow;

defaultproperties
{
	SpareAmmoCapacity(0)=41
	InstantHitDamage(BASH_FIREMODE)=37
	FireInterval(DEFAULT_FIREMODE)=0.15
	InstantHitDamage(DEFAULT_FIREMODE)=490
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_Crossbow_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Bow_Crossbow_Precious"
}
