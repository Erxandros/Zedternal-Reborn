class WMWeap_Beam_Microwave_Precious extends KFWeap_Beam_Microwave;

defaultproperties
{
	MagazineCapacity(0)=150 //50% increase
	AmmoPickupScale(0)=0.25 //50% decrease
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(0)=0.056 //25% increase
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)

	Begin Object Name=ExploTemplate0
		Damage=263.0 //25% increase (round up)
		DamageRadius=900.0 //20% increase
	End Object
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Beam_Microwave_Precious"
}
