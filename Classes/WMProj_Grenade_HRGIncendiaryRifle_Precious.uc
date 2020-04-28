class WMProj_Grenade_HRGIncendiaryRifle_Precious extends KFProj_Grenade_HRGIncendiaryRifle;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=125 //25% increase
		DamageRadius=600 //20% increase
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		bIgnoreInstigator=false

		MomentumTransferScale=0

		// Damage Effects
		MyDamageType=class'KFDT_Explosive_HRGIncendiaryRifle'
		KnockDownStrength=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'wep_molotov_arch.Molotov_Explosion'
		ExplosionSound=AkEvent'WW_WEP_EXP_Grenade_Frag.Play_WEP_EXP_Grenade_Frag_Explosion'

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

	Begin Object Class=KFGameExplosion Name=ExploTemplatePreciousFire
		Damage=13 //25% increase (round up)
		DamageRadius=180 //20% increase
		DamageFalloffExponent=1.f
		DamageDelay=0.f

		bDirectionalExplosion=true

		MomentumTransferScale=1
		
		// Damage Effects
		MyDamageType=class'KFDT_Fire_Ground_HRGIncendiaryRifle'
		KnockDownStrength=0
		FractureMeshRadius=0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'wep_molotov_arch.Molotov_GroundFire'
		ExplosionSound=AkEvent'WW_WEP_EXP_MOLOTOV.Play_WEP_EXP_Molotov_Explosion'

		// Dynamic Light
		ExploLight=FlamePointLight
		ExploLightStartFadeOutTime=0.4
		ExploLightFadeOutTime=0.2

		// Camera Shake
		CamShake=none
	End Object
	GroundFireExplosionTemplate=ExploTemplatePreciousFire

	Name="Default__WMProj_Grenade_HRGIncendiaryRifle_Precious"
}
