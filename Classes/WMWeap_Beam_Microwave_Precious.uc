class WMWeap_Beam_Microwave_Precious extends KFWeap_Beam_Microwave;

defaultproperties
{
	MagazineCapacity(0)=150
	AmmoPickupScale(0)=0.25
	SpareAmmoCapacity(0)=600
	InstantHitDamage(BASH_FIREMODE)=38
	FireInterval(DEFAULT_FIREMODE)=0.056
	Begin Object Name=ExploTemplate0
		Damage=263
		DamageRadius=900
	End Object
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Beam_Microwave_Precious"
}
