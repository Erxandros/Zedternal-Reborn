class WMWeap_Thrown_C4_Precious extends KFWeap_Thrown_C4;

defaultproperties
{
	WeaponProjectiles(THROW_FIREMODE)=Class'ZedternalReborn.WMProj_Thrown_C4_Precious'
	SpareAmmoCapacity(0)=4 //double spare ammo
	InstantHitDamage(BASH_FIREMODE)=29.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Thrown_C4_Precious"
}
