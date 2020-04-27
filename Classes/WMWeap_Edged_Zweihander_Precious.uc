class WMWeap_Edged_Zweihander_Precious extends KFWeap_Edged_Zweihander;

defaultproperties
{
	InstantHitMomentum(DEFAULT_FIREMODE)=37500.f //25% increase
	InstantHitDamage(DEFAULT_FIREMODE)=107.0 //25% increase (round up)
	InstantHitMomentum(HEAVY_ATK_FIREMODE)=37500.f //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=244.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=79.0 //25% increase (round up)
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_Edged_Zweihander_Precious"
}
