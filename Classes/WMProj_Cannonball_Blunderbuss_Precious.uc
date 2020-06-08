class WMProj_Cannonball_Blunderbuss_Precious extends KFProj_Cannonball_Blunderbuss
	hidedropdown;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=313.0 //25% increase (round up)
		DamageRadius=900.0 //20% increase
		DamageFalloffExponent=2
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_Blunderbuss'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_Blunderbuss_ARCH.Cannonball_Explosion'
		ExplosionSound=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Explosion'

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

	Name="Default__WMProj_Cannonball_Blunderbuss_Precious"
}
