class WMProj_Thrown_C4_Precious extends KFProj_Thrown_C4;


defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      ExplosionEffects=KFImpactEffectInfo'WEP_C4_ARCH.C4_Explosion'
      Damage=1100.000000
      DamageRadius=500.000000
      DamageFalloffExponent=2.000000
      MyDamageType=Class'kfgamecontent.KFDT_Explosive_C4'
      KnockDownStrength=0.000000
      ExplosionSound=AkEvent'WW_WEP_EXP_C4.Play_WEP_EXP_C4_Explosion'
      ExploLight=PointLightComponent'Zedternal.Default__WMProj_Thrown_C4_Precious:ExplosionPointLight'
      ExploLightFadeOutTime=0.200000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
      CamShakeInnerRadius=200.000000
      CamShakeFalloff=1.500000
      Name="ExploTemplatePrecious"
      ObjectArchetype=KFGameExplosion'KFGame.Default__KFGameExplosion'
   End Object
   ExplosionTemplate=KFGameExplosion'Zedternal.Default__WMProj_Thrown_C4_Precious:ExploTemplatePrecious'
   Name="Default__WMProj_Thrown_C4_Precious"
}
