//=============================================================================
// KFProj_Husk_Fireball
//=============================================================================
// Husk's fireball projectile
//=============================================================================
// Killing Floor 2
// Copyright (C) 2016 Tripwire Interactive LLC
//=============================================================================
class WMProj_Husk_Fireball_Suicide extends KFProj_Husk_Fireball;

simulated function Tick(float Delta)
{
	SetRotation(rotator(Velocity));
	super.Tick(Delta);
}

defaultproperties
{
   BurnDuration=2.000000
   BurnDamageInterval=0.500000
   /*
   Begin Object Name=ExploTemplate0
      ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.HuskProjectile_Explosion'
      Damage=13.000000
      DamageRadius=250.000000
      MyDamageType=Class'kfgamecontent.KFDT_Fire_HuskFireball'
      MomentumTransferScale=40000.000000
      ExplosionSound=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_Impact'
      ExploLight=PointLightComponent'kfgamecontent.Default__KFProj_Husk_Fireball:ExplosionPointLight'
      ExploLightFadeOutTime=0.500000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Misc_Explosions.HuskFireball'
      Name="ExploTemplate0"
   End Object
   */
   Begin Object Name=ExploTemplate0
      Damage=13.000000
      DamageRadius=250.000000
      Name="ExploTemplate0"
   End Object
   Speed=1200.000000
   MaxSpeed=1200.000000
   Physics=PHYS_Falling
   Name="Default__WMProj_Husk_Fireball_Suicide"
}
