class WMProj_HighExplosive_M16M203_Precious extends KFProj_HighExplosive_M16M203
    hidedropdown;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      ExplosionEffects=KFImpactEffectInfo'Wep_M16_M203_ARCH.M16_M203_Grenade_Explosion'
      Damage=250.000000
      DamageFalloffExponent=2.500000
      MyDamageType=Class'kfgamecontent.KFDT_Explosive_M16M203'
      KnockDownStrength=0.000000
      ExplosionSound=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Explosion'
      ExploLight=PointLightComponent'Zedternal.Default__WMProj_HighExplosive_M16M203_Precious:ExplosionPointLight'
      ExploLightFadeOutTime=0.200000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
      CamShakeInnerRadius=0.000000
      CamShakeOuterRadius=0.000000
      Name="ExploTemplatePrecious"
      ObjectArchetype=KFGameExplosion'KFGame.Default__KFGameExplosion'
   End Object
   ExplosionTemplate=KFGameExplosion'Zedternal.Default__WMProj_HighExplosive_M16M203_Precious:ExploTemplatePrecious'
   Name="Default__WMProj_HighExplosive_M16M203_Precious"
}
