class WMWeap_Bow_CompoundBow_Precious extends KFWeap_Bow_CompoundBow;

defaultproperties
{
	SpareAmmoCapacity(0)=49
	FireInterval(ALTFIRE_FIREMODE)=0.1
	InstantHitDamage(ALTFIRE_FIREMODE)=75
	WeaponProjectiles(ALTFIRE_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_CompoundBowCryo_Precious'
	InstantHitDamage(BASH_FIREMODE)=150
	FireInterval(DEFAULT_FIREMODE)=0.1
	InstantHitDamage(DEFAULT_FIREMODE)=375
	WeaponProjectiles(DEFAULT_FIREMODE)=class'ZedternalReborn.WMProj_Bolt_CompoundBowSharp_Precious'
	Name="Default__WMWeap_Bow_CompoundBow_Precious"
}
