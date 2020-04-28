class WMProj_Rocket_SealSqueal_Precious extends KFProj_Rocket_SealSqueal;

defaultproperties
{
	// explosion
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=313 //25% increase (round up)
	    DamageRadius=720 //20% increase
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_SealSqueal'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_Seal_Squeal_ARCH.SealSquealHarpoon_Explosion'
		ExplosionSound=AkEvent'WW_WEP_SealSqueal.Play_WEP_SealSqueal_Shoot_Explode'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=900
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplatePrecious

	Name="Default__WMProj_Rocket_SealSqueal_Precious"
}
