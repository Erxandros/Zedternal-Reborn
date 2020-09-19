class WMProj_BrokenFlare_HRGScorcher_Precious extends KFProj_BrokenFlare_HRGScorcher
	hidedropdown;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=0.0 //25% increase
		DamageRadius=600.0 //20% increase
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		bIgnoreInstigator=false

		MomentumTransferScale=0

		// Damage Effects
		MyDamageType=class'KFDT_Fire_HRGScorcherDoT'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_HRGScorcher_Pistol_ARCH.HRGScorcher_Pistol_Grenade_Explosion'
		ExplosionSound=AkEvent'WW_WEP_HRG_Scorcher.Play_WEP_HRG_Scorcher_AltFire_Explosion'

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

	Name="Default__WMProj_BrokenFlare_HRGScorcher_Precious"
}
