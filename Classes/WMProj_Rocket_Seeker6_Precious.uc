class WMProj_Rocket_Seeker6_Precious extends KFProj_Rocket_Seeker6
	hidedropdown;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      ExplosionEffects=KFImpactEffectInfo'WEP_SeekerSix_ARCH.FX_SeekerSix_Explosion'
      Damage=200.000000
      DamageRadius=290.000000
      DamageFalloffExponent=2.000000
      MyDamageType=Class'kfgamecontent.KFDT_Explosive_Seeker6'
      KnockDownStrength=0.000000
      ExplosionSound=AkEvent'WW_WEP_Seeker_6.Play_WEP_Seeker_6_Explosion'
      ExploLight=PointLightComponent'ZedternalReborn.Default__WMProj_Rocket_Seeker6_Precious:ExplosionPointLight'
      ExploLightFadeOutTime=0.200000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Misc_Explosions.Seeker6'
      CamShakeInnerRadius=180.000000
      CamShakeOuterRadius=500.000000
      CamShakeFalloff=1.500000
      Name="ExploTemplatePrecious"
      ObjectArchetype=KFGameExplosion'KFGame.Default__KFGameExplosion'
   End Object
   ExplosionTemplate=KFGameExplosion'ZedternalReborn.Default__WMProj_Rocket_Seeker6_Precious:ExploTemplatePrecious'
   Name="Default__WMProj_Rocket_Seeker6_Precious"
}
