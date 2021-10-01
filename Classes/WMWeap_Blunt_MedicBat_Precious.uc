class WMWeap_Blunt_MedicBat_Precious extends KFWeap_Blunt_MedicBat;

defaultproperties
{
	MagazineCapacity(0)=3 //50% increase
	AmmoPickupScale(0)=0.5 //50% decrease
	SpareAmmoCapacity(0)=12 //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	AmmoCost(DEFAULT_FIREMODE)=32 //20% decrease
	InstantHitDamage(HEAVY_ATK_FIREMODE)=175.0 //25% increase
	InstantHitDamage(BASH_FIREMODE)=50.0 //25% increase
	Begin Object Name=HeavyAttackHealingExplosion
		Damage=282.0f //25% increase (round up)
		DamageRadius=600.0f //20% increase
	End Object
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Blunt_MedicBat_Precious"
}
