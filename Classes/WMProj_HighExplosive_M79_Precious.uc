class WMProj_HighExplosive_M79_Precious  extends KFProj_HighExplosive_M79
	hidedropdown;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      ExplosionEffects=KFImpactEffectInfo'WEP_M79_ARCH.M79Grenade_Explosion'
      Damage=650.000000
      DamageRadius=850.000000
      DamageFalloffExponent=2.000000
      MyDamageType=Class'kfgamecontent.KFDT_Explosive_M79'
      KnockDownStrength=0.000000
      ExplosionSound=AkEvent'WW_WEP_SA_M79.Play_WEP_SA_M79_Explosion'
      ExploLight=PointLightComponent'Zedternal.Default__WMProj_HighExplosive_M79_Precious:ExplosionPointLight'
      ExploLightFadeOutTime=0.200000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
      CamShakeInnerRadius=200.000000
      CamShakeFalloff=1.500000
      Name="ExploTemplatePrecious"
      ObjectArchetype=KFGameExplosion'KFGame.Default__KFGameExplosion'
   End Object
   ExplosionTemplate=KFGameExplosion'Zedternal.Default__WMProj_HighExplosive_M79_Precious:ExploTemplatePrecious'
   Name="Default__WMProj_HighExplosive_M79_Precious"
}
