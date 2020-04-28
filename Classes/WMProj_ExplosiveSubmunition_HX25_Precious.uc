class WMProj_ExplosiveSubmunition_HX25_Precious extends KFProj_ExplosiveSubmunition_HX25
	hidedropdown;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=38 //25% increase (round up)
		DamageRadius=180 //20% increase
		DamageFalloffExponent=1.0f
		DamageDelay=0.f

		MomentumTransferScale=1.f

		// Damage Effects
		MyDamageType=class'KFDT_ExplosiveSubmunition_HX25'
		KnockDownStrength=10
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_HX25_Pistol_ARCH.HX25_Pistol_Submunition_Explosion'
		ExplosionSound=AkEvent'WW_WEP_SA_HX25.Play_WEP_SA_HX25_Mini_Explosion'
		bIgnoreInstigator=true
		ActorClassToIgnoreForDamage=class'KFProj_ExplosiveSubmunition_HX25'

		// Dynamic Light
		ExploLight=ExplosionPointLight
		ExploLightStartFadeOutTime=0.0
		ExploLightFadeOutTime=0.3

		// Camera Shake
		CamShake=KFCameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=0
		CamShakeOuterRadius=300
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplatePrecious

	Name="Default__WMProj_ExplosiveSubmunition_HX25_Precious"
}
