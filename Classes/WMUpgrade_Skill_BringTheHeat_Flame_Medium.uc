class WMUpgrade_Skill_BringTheHeat_Flame_Medium extends WMUpgrade_Skill_BringTheHeat_Flame_Base
	hidedropdown;


defaultproperties
{
   NumResidualFlames=4
   Begin Object Class=KFGameExplosion Name=ExploTemplate0
      ExplosionEffects=KFImpactEffectInfo'wep_molotov_arch.Molotov_GroundFire'
      Damage=40.000000
	  DamageRadius=260.000000
      MyDamageType=Class'ZedternalReborn.WMUpgrade_Weapon_DT_HeatWave_Base'
      KnockDownStrength=0.000000
      MomentumTransferScale=0.000000
      ExplosionSound=AkEvent'WW_WEP_SA_DragonsBreath.Play_Bullet_DragonsBreath_Impact_Snow'
      ExploLightFadeOutTime=0.200000
      ExploLightStartFadeOutTime=0.400000
      FractureMeshRadius=0.000000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Grenades.Molotov'
      CamShakeInnerRadius=10.000000
      CamShakeOuterRadius=16.000000
      Name="ExploTemplate0"
   End Object
   ExplosionTemplate=KFGameExplosion'ZedternalReborn.Default__WMUpgrade_Skill_BringTheHeat_Flame_Medium:ExploTemplate0'
   Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_Medium"
}
