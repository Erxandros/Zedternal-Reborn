class WMPawn_ZedHusk_Tiny_Green extends WMPawn_ZedHusk_Tiny;

defaultproperties
{
   glowColor=(R=0.600000,G=5.000000,B=0.600000)
   Begin Object Class=KFGameExplosion Name=TinyExploTemplate0 Archetype=KFGameExplosion'kfgamecontent.Default__KFPawn_ZedHusk:ExploTemplate0'
      ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Resource.FX_Husk_Tiny_Explosion_Green'
      Damage=35.000000
      DamageRadius=360.000000
      DamageFalloffExponent=2.000000
      MyDamageType=Class'kfgamecontent.KFDT_Explosive_HuskSuicide'
      KnockDownStrength=0.000000
      CamShake=KFCameraShake'FX_CameraShake_Arch.Misc_Explosions.Seeker6'
      CamShakeInnerRadius=180.000000
      CamShakeOuterRadius=500.000000
      CamShakeFalloff=1.500000
      Name="TinyExploTemplate0"
      ObjectArchetype=KFGameExplosion'kfgamecontent.Default__KFPawn_ZedHusk:ExploTemplate0'
   End Object
   ExplosionTemplate=KFGameExplosion'ZedternalReborn.Default__WMPawn_ZedHusk_Tiny_Green:TinyExploTemplate0'
   Name="Default__WMPawn_ZedHusk_Tiny_Green"
   ObjectArchetype=KFPawn_ZedHusk'ZedternalReborn.Default__WMPawn_ZedHusk_Tiny'
}
