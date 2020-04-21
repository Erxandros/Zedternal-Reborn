class WMWeap_Beam_Microwave_Precious extends KFWeap_Beam_Microwave;

const VARIANT_SKIN_ID = 3435;

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
	MagazineCapacity(0)=150 //50% increase
	SpareAmmoCapacity(0)=600 //20% increase
	FireInterval(0)=0.056 //25% increase
	InstantHitDamage(BASH_FIREMODE)=38.0 //25% increase (round up)
	Begin Object Class=GameExplosion Name=ExploTemplatePrecious
		bDirectionalExplosion=True
		DirectionalExplosionAngleDeg=30
		Damage=263.0 //25% increase (round up)
		DamageRadius=900.0 //20% increase
		DamageFalloffExponent=1.0
		MomentumTransferScale=200000.0
		MyDamageType=Class'KFDT_Microwave_Blast'
		ParticleEmitterTemplate=ParticleSystem'WEP_Microwave_Gun_EMIT.FX_Microwave_Blast_01'
	End Object
	ExplosionTemplate=ExploTemplatePrecious
	Name="Default__WMWeap_Beam_Microwave_Precious"
}