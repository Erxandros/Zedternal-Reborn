class WMProj_HighExplosive_M16M203_Precious extends KFProj_HighExplosive_M16M203
   hidedropdown;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      Damage=288.0 //25% increase (round up)
      DamageRadius=600.0 //20% increase
      DamageFalloffExponent=1
      DamageDelay=0.f

      // Damage Effects
      MyDamageType=class'KFDT_Explosive_M16M203'
      KnockDownStrength=0
      FractureMeshRadius=200.0
      FracturePartVel=500.0
      ExplosionEffects=KFImpactEffectInfo'Wep_M16_M203_ARCH.M16_M203_Grenade_Explosion'
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

   Name="Default__WMProj_HighExplosive_M16M203_Precious"
}
