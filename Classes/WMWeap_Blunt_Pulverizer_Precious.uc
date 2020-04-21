class WMWeap_Blunt_Pulverizer_Precious extends KFWeap_Blunt_Pulverizer;

const VARIANT_SKIN_ID = 3430;

reliable client function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	Super.ClientWeaponSet(bOptionalSet, bDoNotActivate);
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantClientWeaponSet( self, VARIANT_SKIN_ID );
}

function SetOriginalValuesFromPickup( KFWeapon PickedUpWeapon )
{
	class'ZedternalReborn.WMWeaponPrecious_Helper'.static.VariantSetOriginalValuesFromPickup( self, PickedUpWeapon, VARIANT_SKIN_ID );
}

defaultproperties
{
	MagazineCapacity(0)=8 //50% increase (round up)
	SpareAmmoCapacity(0)=18  //20% increase
	InstantHitDamage(DEFAULT_FIREMODE)=100.0 //25% increase
	InstantHitDamage(HEAVY_ATK_FIREMODE)=182.0 //25% increase (round up)
	InstantHitDamage(BASH_FIREMODE)=25.0 //25% increase
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		bDirectionalExplosion=true
		DirectionalExplosionAngleDeg=75.0

		Damage=479.0 //25% increase (round up)
		DamageRadius=480.0 //20% increase

		MyDamageType=class'DamageType'

		ParticleEmitterTemplate=ParticleSystem'WEP_1P_Pulverizer_EMIT.FX_Explosion_01'
		ExplosionEmitterScale=4.0
	End Object
	ExplosionTemplate=ExploTemplatePrecious
	Name="Default__WMWeap_Blunt_Pulverizer_Precious"
}