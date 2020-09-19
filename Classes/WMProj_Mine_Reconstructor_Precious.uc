class WMProj_Mine_Reconstructor_Precious extends KFProj_Mine_Reconstructor;

defaultproperties
{
	Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
		Damage=188.0 //25% increase (round up)
		DamageRadius=240.0 //20% increase
		DamageFalloffExponent=0.5f
		DamageDelay=0.f
		MyDamageType=class'KFDT_Toxic_MineReconstructorExplosion'

		//Impulse applied to Zeds
		MomentumTransferScale=45000

		// Damage Effects
		KnockDownStrength=0
		KnockDownRadius=0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'WEP_Mine_Reconstructor_Arch.Mine_Reconstructor_Mine_Explosion'
		ExplosionSound=AkEvent'WW_WEP_MineReconstructor.Play_WEP_Mine_Reconstructor_Mine_Explosion'

		// Dynamic Light
		ExploLight=none

		// Camera Shake
		CamShake=CameraShake'WEP_Mine_Reconstructor_Arch.Camera_Shake'
		CamShakeInnerRadius=200
		CamShakeOuterRadius=400
		CamShakeFalloff=1.f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplatePrecious

	Name="Default__WMProj_Mine_Reconstructor_Precious"
}
