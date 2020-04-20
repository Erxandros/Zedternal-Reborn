class WMProj_Rocket_RPG7_Precious extends KFProj_Rocket_RPG7
	hidedropdown;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      Damage=938.0 //25% increase (round up)
      DamageRadius=480.0 //20% increase
      DamageFalloffExponent=2
      DamageDelay=0.f

      // Damage Effects
      MyDamageType=class'KFDT_Explosive_RPG7'
      KnockDownStrength=0
      FractureMeshRadius=200.0
      FracturePartVel=500.0
      ExplosionEffects=KFImpactEffectInfo'WEP_RPG7_ARCH.RPG7_Explosion'
      ExplosionSound=AkEvent'WW_WEP_SA_RPG7.Play_WEP_SA_RPG7_Explosion'

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
   
   Name="Default__WMProj_Rocket_RPG7_Precious"
}