class WMProj_Grenade_HRGTeslauncher_Precious extends KFProj_Grenade_HRGTeslauncher
	hidedropdown;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=32.0 //25% increase (round up)
		DamageRadius=420.0 //20% increase
		DamageFalloffExponent=1
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_EMP_TeslauncherEMPGrenade'
		FractureMeshRadius=100
		FracturePartVel=250.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.EMPGrenade_Explosion'
		ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_EMP.Play_WEP_EXP_Grenade_EMP_Explosion'

		// Dynamic Light
		ExploLight=ExplosionPointLight
		ExploLightStartFadeOutTime=0.5
		ExploLightFadeOutTime=0.25
		ExploLightFlickerIntensity=5.f
		ExploLightFlickerInterpSpeed=15.f

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
		CamShakeInnerRadius=100	
		CamShakeOuterRadius=450
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplatePrecious

	Name="Default__WMProj_Grenade_HRGTeslauncher_Precious"
}
