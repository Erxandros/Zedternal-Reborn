class WMProj_Bolt_CompoundBowCryo_Precious extends KFProj_Bolt_CompoundBowCryo
	hidedropdown;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=32 //25% increase (round up)
		DamageRadius=240 //20% increase
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		bIgnoreInstigator=false

		MomentumTransferScale=1

		// Damage Effects
		MyDamageType=class'KFDT_Freeze_CompoundBowCryExplosion'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_CompoundBow_ARCH.FX_CompoundBow_Cryo_Projectile_Explosion'
		ExplosionSound=AkEvent'WW_WEP_SA_CompoundBow.Play_Arrow_Impact_Cryo'

		// Dynamic Light
		ExploLight=ExplosionPointLight
		ExploLightStartFadeOutTime=0.0
		ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=None
	End Object
	ExplosionTemplate=ExploTemplatePrecious

	Name="Default__WMProj_Bolt_CompoundBowCryo_Precious"
}
