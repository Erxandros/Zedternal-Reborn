class WMProj_Rocket_RPG7_Precious extends KFProj_Rocket_RPG7
	hidedropdown;

defaultproperties
{
   Begin Object Class=KFGameExplosion Name=ExploTemplatePrecious
      ExplosionEffects=KFImpactEffectInfo'WEP_RPG7_ARCH.RPG7_Explosion'
      Damage=1050.000000
      DamageRadius=400.000000
      DamageFalloffExponent=2.000000
      MyDamageType=Class'kfgamecontent.KFDT_Explosive_RPG7'
      KnockDownStrength=0.000000
      ExplosionSound=AkEvent'WW_WEP_SA_RPG7.Play_WEP_SA_RPG7_Explosion'
      ExploLight=PointLightComponent'ZedternalReborn.Default__WMProj_Rocket_RPG7_Precious:ExplosionPointLight'
      ExploLightFadeOutTime=0.200000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Grenades.Default_Grenade'
      CamShakeInnerRadius=200.000000
      CamShakeFalloff=1.500000
      Name="ExploTemplatePrecious"
      ObjectArchetype=KFGameExplosion'KFGame.Default__KFGameExplosion'
   End Object
   ExplosionTemplate=KFGameExplosion'ZedternalReborn.Default__WMProj_Rocket_RPG7_Precious:ExploTemplatePrecious'
   Name="Default__WMProj_Rocket_RPG7_Precious"
}
