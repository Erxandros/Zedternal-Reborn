class WMProj_Explosive_HRG_Kaboomstick_Precious extends KFProj_Explosive_HRG_Kaboomstick
	hidedropdown;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=48.0 //25% increase (round up)
		DamageRadius=240.0 //20% increase
		DamageFalloffExponent=1.0f
		DamageDelay=0.f

		MomentumTransferScale=22500

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_HRG_Kaboomstick'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionSound=AkEvent'WW_WEP_SA_HX25.Play_WEP_SA_HX25_Explosion'
		ExplosionEffects=KFImpactEffectInfo'WEP_HRG_Kaboomstick_ARCH.WEP_HRG_Kaboomstick_Explosion'

		// Dynamic Light
		ExploLight=ExplosionPointLight
		ExploLightStartFadeOutTime=0.0
		ExploLightFadeOutTime=0.3

		bIgnoreInstigator=true

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=0
		CamShakeOuterRadius=300
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplatePrecious

	Name="Default__WMProj_Explosive_HRG_Kaboomstick_Precious"
}
