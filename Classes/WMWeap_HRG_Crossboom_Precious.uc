class WMWeap_HRG_Crossboom_Precious extends KFWeap_HRG_Crossboom;

defaultproperties
{
	SpareAmmoCapacity(0)=54
	FireInterval(ALTFIRE_FIREMODE)=0.15
	InstantHitDamage(ALTFIRE_FIREMODE)=15
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_HRG_CrossboomAlt_Precious'
	InstantHitDamage(BASH_FIREMODE)=39
	FireInterval(DEFAULT_FIREMODE)=0.15
	InstantHitDamage(DEFAULT_FIREMODE)=15
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_HRG_Crossboom_Precious'
	DroppedPickupClass=class'ZedternalReborn.WMPreciousDroppedPickup'
	Name="Default__WMWeap_HRG_Crossboom_Precious"
}
