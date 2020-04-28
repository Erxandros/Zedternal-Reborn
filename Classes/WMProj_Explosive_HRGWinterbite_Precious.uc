class WMProj_Explosive_HRGWinterbite_Precious extends KFProj_Explosive_HRGWinterbite;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=25 //25% increase
		DamageRadius=240 //20% increase
		DamageFalloffExponent=0
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_HRGWinterbite'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_HRG_Winterbite_ARCH.FX_WinterBite_Projectile_Explosion'
		ExplosionSound=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Explode_Ice'

		// Dynamic Light
		ExploLight=ExplosionPointLight
		ExploLightStartFadeOutTime=0.0
		ExploLightFadeOutTime=0.3

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
		CamShakeInnerRadius=0
		CamShakeOuterRadius=300
		CamShakeFalloff=1.5f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplatePrecious

	Name="Default__WMProj_Explosive_HRGWinterbite_Precious"
}
