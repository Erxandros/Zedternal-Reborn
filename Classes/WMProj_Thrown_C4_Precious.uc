class WMProj_Thrown_C4_Precious extends KFProj_Thrown_C4;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      Damage=1025 //25% increase
      DamageRadius=480 //20% increase
      DamageFalloffExponent=2.f
      DamageDelay=0.f

      // Damage Effects
      MyDamageType=class'KFDT_Explosive_C4'
      KnockDownStrength=0
      FractureMeshRadius=200.0
      FracturePartVel=500.0
      ExplosionEffects=KFImpactEffectInfo'WEP_C4_ARCH.C4_Explosion'
      ExplosionSound=AkEvent'WW_WEP_EXP_C4.Play_WEP_EXP_C4_Explosion'

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

   Name="Default__WMProj_Thrown_C4_Precious"
}
