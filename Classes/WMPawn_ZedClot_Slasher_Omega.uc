class WMPawn_ZedClot_Slasher_Omega extends KFPawn_ZedClot_Slasher;

var transient Zed_Arch_SlasherOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;
var linearColor omegaColor, omegaFresnelColor;

static function string GetLocalizedName()
{
	return "Slasher Omega";
}

function PossessedBy( Controller C, bool bVehicleTransition )
{
	local string NPCName;
	
	super.PossessedBy( C, bVehicleTransition );
	
	if( MyKFAIC != none && MyKFAIC.PlayerReplicationInfo != None )
	{
		NPCName = GetLocalizedName();
		PlayerReplicationInfo.PlayerName = NPCName;
		MyKFAIC.PlayerReplicationInfo.PlayerName = NPCName;
	}
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.125000;
	ZedArch = class'Zed_Arch_SlasherOmega'.static.GetArch(WorldInfo);
	if (ZedArch!=none)
		updateArch();
	
	if (WorldInfo.NetMode != NM_DedicatedServer)
		ApplySpecialFX();
	
	bVersusZed = true;
	
	super.PostBeginPlay();
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
		EndSpecialFX();
	
	super.PlayDying(DamageType, HitLoc);
}

simulated function ApplySpecialFX()
{
	local Name SocketBoneName;
	
	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_L');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZED_Omega.FX_Omega', Mesh, 'FX_EYE_L', true, vect(0,0,0) );
			
	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_R');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZED_Omega.FX_Omega', Mesh, 'FX_EYE_R', true, vect(0,0,0) );
}

simulated function EndSpecialFX()
{
	if( SpecialFXPSCs[0] != none && SpecialFXPSCs[0].bIsActive )
	{
		SpecialFXPSCs[0].DeactivateSystem();
	}
	if( SpecialFXPSCs[1] != none && SpecialFXPSCs[1].bIsActive )
	{
		SpecialFXPSCs[1].DeactivateSystem();
	}
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_SlasherOmega'.Static.GetArch(WorldInfo);
	if(ZedArch!=None)
	{
		Mesh.AnimSets = ZedArch.zedClientArch.AnimSets;
		Mesh.SetAnimTreeTemplate(ZedArch.zedClientArch.AnimTreeTemplate);
		PawnAnimInfo = ZedArch.zedClientArch.AnimArchetype;
		
		// update texture effects
		UpdateGameplayMICParams();
	}
}

simulated function UpdateGameplayMICParams()
{
	local byte i;
	
	super.UpdateGameplayMICParams();
	
	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i=0; i<CharacterMICs.length; i++)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', omegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', omegaFresnelColor);
		}
	}
}

/** Returns damage multiplier for an incoming damage type @todo: c++?*/
function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float currentMod;
	
	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
}

simulated event bool UsePlayerControlledZedSkin()
{
    return true;
}

defaultproperties
{
   //MonsterArchPath=KFCharacterInfo_Monster'ZED_Omega.ZED_Clot_Slasher_Omega_Archetype'
   DoshValue=15
   XPValues(0)=16.000000
   XPValues(1)=22.000000
   XPValues(2)=22.000000
   XPValues(3)=22.000000
   Health=250
   ExtraResistance=0.150000
   GroundSpeed=340.000000
   SprintSpeed=580.000000
   LocalizationKey="WMPawn_ZedSlasher_Omega"
   
   Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0 Archetype=KFMeleeHelperAI'KFGame.Default__KFPawn_Monster:MeleeHelper_0'
      BaseDamage=10.000000
      MyDamageType=Class'kfgamecontent.KFDT_Slashing_ZedWeak'
      MomentumTransfer=25000.000000
      MaxHitRange=180.000000
      Name="MeleeHelper_0"
   End Object
   MeleeAttackHelper=KFMeleeHelperAI'ZedternalReborn.Default__WMPawn_ZedClot_Slasher_Omega:WMMeleeHelper_0'
   
   bVersusZed=False
   ParryResistance=1
   GrabAttackFrequency=0.600000

   HitZones(0)=(GoreHealth=150)
   
   omegaColor=(R=0.500000,G=0.250000,B=1.000000)
   omegaFresnelColor=(R=0.400000,G=0.250000,B=0.700000)

   Name="Default__WMPawn_ZedClot_Slasher_Omega"
}
