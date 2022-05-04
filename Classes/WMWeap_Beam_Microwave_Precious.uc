class WMWeap_Beam_Microwave_Precious extends KFWeap_Beam_Microwave;

defaultproperties
{
	MagazineCapacity(0)=200
	AmmoPickupScale(0)=0.25
	SpareAmmoCapacity(0)=700
	InstantHitDamage(BASH_FIREMODE)=41
	FireInterval(DEFAULT_FIREMODE)=0.053
	MinAmmoConsumed=2
	Begin Object Name=ExploTemplate0
		Damage=284
		DamageRadius=975
	End Object
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Beam_Microwave_Precious"
}
