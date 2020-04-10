class WMUpgrade_Skill_BringTheHeat_Flame_Low extends WMUpgrade_Skill_BringTheHeat_Flame_Base
	hidedropdown;


defaultproperties
{
   NumResidualFlames=2
   Begin Object Class=KFGameExplosion Name=ExploTemplate0
      ExplosionEffects=KFImpactEffectInfo'WEP_Flamethrower_ARCH.GroundFire_Impacts'
      Damage=10.000000
	  DamageRadius=125.000000
      MyDamageType=Class'ZedternalReborn.WMUpgrade_Weapon_DT_HeatWave_Base'
      KnockDownStrength=0.000000
      MomentumTransferScale=0.000000
      ExplosionSound=AkEvent'WW_WEP_Flare_Gun.Play_WEP_Flare_Gun_Explode'
      ExploLightFadeOutTime=0.200000
      ExploLightStartFadeOutTime=0.400000
      FractureMeshRadius=0.000000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Grenades.Molotov'
      CamShakeInnerRadius=5.000000
      CamShakeOuterRadius=8.000000
      Name="ExploTemplate0"
   End Object
   ExplosionTemplate=KFGameExplosion'ZedternalReborn.Default__WMUpgrade_Skill_BringTheHeat_Flame_Low:ExploTemplate0'
   Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_Low"
}
