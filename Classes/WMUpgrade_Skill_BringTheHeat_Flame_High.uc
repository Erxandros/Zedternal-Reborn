class WMUpgrade_Skill_BringTheHeat_Flame_High extends WMUpgrade_Skill_BringTheHeat_Flame_Base
	hidedropdown;


defaultproperties
{
   NumResidualFlames=7
   Begin Object Class=KFGameExplosion Name=ExploTemplate0
      ExplosionEffects=KFImpactEffectInfo'WEP_Flamethrower_ARCH.GroundFire_Impacts'
      Damage=115.000000
	  DamageRadius=350.000000
      MyDamageType=Class'ZedternalReborn.WMUpgrade_Weapon_DT_HeatWave_Base'
      KnockDownStrength=0.000000
      MomentumTransferScale=0.000000
      ExplosionSound=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_Impact'
      ExploLightFadeOutTime=0.200000
      ExploLightStartFadeOutTime=0.400000
      FractureMeshRadius=0.000000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Grenades.Molotov'
      CamShakeInnerRadius=15.000000
      CamShakeOuterRadius=24.000000
      Name="ExploTemplate0"
   End Object
   ExplosionTemplate=KFGameExplosion'ZedternalReborn.Default__WMUpgrade_Skill_BringTheHeat_Flame_High:ExploTemplate0'
   Name="Default__WMUpgrade_Skill_BringTheHeat_Flame_High"
}
