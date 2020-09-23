class WMExplosion_TinyHusk extends KFGameExplosion;

defaultproperties
{
	Begin Object Class=PointLightComponent Name=ExplosionPointLight
		LightColor=(R=245, G=190, B=140, A=255)
		bCastPerObjectShadows=false
	End Object

	Damage=35.0
	DamageRadius=360.0
	DamageFalloffExponent=2.0
	DamageDelay=0.0
	bFullDamageToAttachee=true

	// Damage Effects
	MyDamageType=class'KFDT_Explosive_HuskSuicide'
	FractureMeshRadius=200.0
	FracturePartVel=500.0
	ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.HuskSuicide_Explosion'
	ExplosionSound=AkEvent'WW_WEP_Husk_Cannon.Play_WEP_Husk_Cannon_3P_Fire'
	KnockDownStrength=0.0
	MomentumTransferScale=1.0

	// Dynamic Light
	ExploLight=ExplosionPointLight
	ExploLightStartFadeOutTime=0.0
	ExploLightFadeOutTime=0.5

	// Camera Shake
	CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Seeker6'
	CamShakeInnerRadius=180.0
	CamShakeOuterRadius=500.0
	CamShakeFalloff=1.5
	bOrientCameraShakeTowardsEpicenter=true

	Name="Default__WMExplosion_TinyHusk"
}
