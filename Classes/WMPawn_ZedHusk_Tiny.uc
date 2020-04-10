class WMPawn_ZedHusk_Tiny extends KFPawn_ZedHusk;

var linearColor glowColor;

static function string GetLocalizedName()
{
	return "Tiny Husk";
}

/** Gets the actual classes used for spawning. Can be overridden to replace this monster with another */
static event class<KFPawn_Monster> GetAIPawnClassToSpawn()
{
	return default.class;
}
	

function PossessedBy( Controller C, bool bVehicleTransition )
{
	super.PossessedBy( C, bVehicleTransition );
	if (KFAIController_ZedHusk(C) != none)
		KFAIController_ZedHusk(C).RequiredHealthPercentForSuicide = 1.f;
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.700000;
	UpdateGameplayMICParams();
}

simulated function UpdateGameplayMICParams()
{
	local byte i;
	
	super.UpdateGameplayMICParams();
	
	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i=0; i<CharacterMICs.length; i++)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', default.glowColor);
		}
	}
}

defaultproperties
{
   glowColor=(R=2.500000,G=20.000000,B=0.600000)
   //glowColor(1)=(R=20.000000,G=0.600000,B=2.500000)
   //glowColor(2)=(R=0.600000,G=2.500000,B=20.000000)
   Begin Object Class=KFGameExplosion Name=TinyExploTemplate0 Archetype=KFGameExplosion'kfgamecontent.Default__KFPawn_ZedHusk:ExploTemplate0'
      ExplosionEffects=KFImpactEffectInfo'ZedternalReborn_Resource.FX_Husk_Tiny_Explosion_Green'
      Damage=35.000000
      DamageRadius=360.000000
      DamageFalloffExponent=2.000000
      MyDamageType=Class'kfgamecontent.KFDT_Explosive_HuskSuicide'
      KnockDownStrength=0.000000
	  ExplosionSound=AkEvent'WW_WEP_Husk_Cannon.Play_WEP_Husk_Cannon_3P_Fire'
      CamShake=KFCameraShake'FX_CameraShake_Arch.Misc_Explosions.Seeker6'
      CamShakeInnerRadius=180.000000
      CamShakeOuterRadius=500.000000
      CamShakeFalloff=1.500000
      Name="TinyExploTemplate0"
      ObjectArchetype=KFGameExplosion'kfgamecontent.Default__KFPawn_ZedHusk:ExploTemplate0'
   End Object
   ExplosionTemplate=KFGameExplosion'ZedternalReborn.Default__WMPawn_ZedHusk_Tiny:TinyExploTemplate0'
   GroundSpeed=480.000000
   SprintSpeed=480.000000
   Health=225
   Name="Default__WMPawn_ZedHusk_Tiny"
   ObjectArchetype=KFPawn_ZedHusk'kfgamecontent.Default__KFPawn_ZedHusk'
}
