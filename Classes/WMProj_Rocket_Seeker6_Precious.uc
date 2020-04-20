class WMProj_Rocket_Seeker6_Precious extends KFProj_Rocket_Seeker6
	hidedropdown;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      Damage=157.0 //25% increase (round up)
      DamageRadius=300.0 //20% increase
      DamageFalloffExponent=2
      DamageDelay=0.f

      // Damage Effects
      MyDamageType=class'KFDT_Explosive_Seeker6'
      KnockDownStrength=0
      FractureMeshRadius=200.0
      FracturePartVel=500.0
      ExplosionEffects=KFImpactEffectInfo'WEP_SeekerSix_ARCH.FX_SeekerSix_Explosion'
      ExplosionSound=AkEvent'WW_WEP_Seeker_6.Play_WEP_Seeker_6_Explosion'

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.2

      // Camera Shake
      CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.Light_Explosion_Rumble'
      CamShakeInnerRadius=0
      CamShakeOuterRadius=500
      CamShakeFalloff=3.f
      bOrientCameraShakeTowardsEpicenter=true
   End Object
   ExplosionTemplate=ExploTemplatePrecious

   Name="Default__WMProj_Rocket_Seeker6_Precious"
}
