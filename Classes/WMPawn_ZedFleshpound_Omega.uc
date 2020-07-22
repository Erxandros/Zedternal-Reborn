class WMPawn_ZedFleshpound_Omega extends KFPawn_ZedFleshpound;

var transient Zed_Arch_FleshpoundOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;
var linearColor omegaColor, omegaFresnelColor;

var const float RallyRadius;
var const ParticleSystem RallyEffect, AltRallyEffect;
var const name RallyEffectBoneName;
var const name AltRallyEffectBoneNames[2];
var const vector RallyEffectOffset, AltRallyEffectOffset;

var KFGameExplosion OmegaExplosionTemplate;

static function string GetLocalizedName()
{
	return "Fleshpound Omega";
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
	//Mesh.SetScale(1.15);
	IntendedBodyScale = 1.15;
	ZedArch = class'Zed_Arch_FleshpoundOmega'.static.GetArch(WorldInfo);
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
		SpecialFXPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_L', true, vect(0,0,0) );
			
	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_R');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_R', true, vect(0,0,0) );
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
	ZedArch = class'Zed_Arch_FleshpoundOmega'.Static.GetArch(WorldInfo);
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
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', omegaColor);
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

simulated function ANIMNOTIFY_OmegaKick()
{
	local vector ExploLocation;

	Mesh.GetSocketWorldLocationAndRotation( 'RightMG3_socket', ExploLocation );
	TriggerOmegaExplosion( ExploLocation);
}

simulated function TriggerOmegaExplosion( vector ExploLocation)
{
	local KFExplosionActor ExploActor;

	// Boom
	ExploActor = Spawn( class'KFExplosionActor', self,, ExploLocation );
	ExploActor.InstigatorController = Controller;
	ExploActor.Instigator = self;
	ExploActor.Explode( OmegaExplosionTemplate, vect(0,0,1) );
}

simulated function bool SetEnraged( bool bNewEnraged )
{
	// Fleshpound Omega will rally nearby zeds (and self) while enraging
	if (!bIsEnraged)
		RallyZeds();
	
	return super.SetEnraged(bNewEnraged);
}

simulated function RallyZeds()
{
    local KFPawn_Monster KFPM;
	local sRallyInfo NewRallyInfo;
	local WMGameReplicationInfo WMGRI;
	
    // Rally nearby zeds
    foreach WorldInfo.GRI.VisibleCollidingActors( class'KFPawn_Monster', KFPM, RallyRadius, Location )
    {
        if( KFPM.IsHeadless() || !KFPM.IsAliveAndWell() || WMPawn_ZedFleshpound_Omega(KFPM) != none )
        {
            continue;
        }
		//Force this ZEDs to sprint
		// Set Rally setting
		WMGRI = WMGameReplicationInfo(Class'WorldInfo'.static.GetWorldInfo().GRI);
		if (WMGRI != none)
		{
			NewRallyInfo = KFPM.DifficultySettings.static.GetRallySettings(KFPM, WMGRI);
			NewRallyInfo.bCanRally = true;
			NewRallyInfo.bCauseSprint = true;
			KFPM.SetRallySettings( NewRallyInfo );
		}
        // Activate buffs and effects
		KFPM.Rally( self,
                    RallyEffect,
                    RallyEffectBoneName,
                    RallyEffectOffset,
                    AltRallyEffect,
                    AltRallyEffectBoneNames,
                    AltRallyEffectOffset );
    }
}

simulated event bool UsePlayerControlledZedSkin()
{
    return true;
}

defaultproperties
{
   DefaultGlowColor=(R=1.000000,G=0.250000,B=0.000000,A=1.000000)
   EnragedGlowColor=(R=1.000000,G=0.000000,B=0.000000,A=1.000000)
   DeadGlowColor=(R=0.000000,G=0.000000,B=0.000000,A=1.000000)
   RageBumpDamageType=Class'kfgamecontent.KFDT_HeavyZedBump'

   bVersusZed=False
   
   RallyRadius=1750.000000
   RallyEffect=ParticleSystem'ZedternalReborn_Zeds.FX_Fleshpound_Rage_01'
   AltRallyEffect=ParticleSystem'ZedternalReborn_Zeds.FX_Fleshpound_Buff_01'
   RallyEffectBoneName="Root"
   AltRallyEffectBoneNames(0)="FX_EYE_L"
   AltRallyEffectBoneNames(1)="FX_EYE_R"
   RallyEffectOffset=(X=0.000000,Y=0.000000,Z=0.000000)
   AltRallyEffectOffset=(X=0.000000,Y=0.000000,Z=0.000000)
   
   DoshValue=400
   XPValues(0)=70.000000
   XPValues(1)=94.000000
   XPValues(2)=126.000000
   XPValues(3)=144.000000
   Health=4000
   ExtraResistance=0.200000
   GroundSpeed=460.000000
   SprintSpeed=615.000000

   FootstepCameraShakeInnerRadius=230.000000
   FootstepCameraShakeOuterRadius=1035.000000

   LocalizationKey="WMPawn_ZedFleshpound_Omega"

   HitZones(0)=(GoreHealth=1950)
   
   omegaColor=(R=0.500000,G=0.250000,B=1.000000)
   omegaFresnelColor=(R=0.400000,G=0.250000,B=0.700000)

   OmegaExplosionTemplate=KFGameExplosion'kfgamecontent.Default__KFPawn_ZedFleshpoundKing:ExploTemplate1'
   Begin Object Class=KFSpecialMoveHandler Name=SpecialMoveHandler_0 Archetype=KFSpecialMoveHandler'KFGame.Default__KFPawn_Monster:SpecialMoveHandler_0'
      SpecialMoveClasses(0)=None
      SpecialMoveClasses(1)=Class'KFGame.KFSM_MeleeAttack'
      SpecialMoveClasses(2)=Class'KFGame.KFSM_DoorMeleeAttack'
      SpecialMoveClasses(3)=Class'KFGame.KFSM_GrappleCombined'
      SpecialMoveClasses(4)=Class'KFGame.KFSM_Stumble'
      SpecialMoveClasses(5)=Class'KFGame.KFSM_RecoverFromRagdoll'
      SpecialMoveClasses(6)=Class'KFGame.KFSM_RagdollKnockdown'
      SpecialMoveClasses(7)=Class'KFGame.KFSM_DeathAnim'
      SpecialMoveClasses(8)=Class'KFGame.KFSM_Stunned'
      SpecialMoveClasses(9)=Class'KFGame.KFSM_Frozen'
      SpecialMoveClasses(10)=None
      SpecialMoveClasses(11)=None
      SpecialMoveClasses(12)=Class'kfgamecontent.KFSM_PlayerFleshpound_Rage'
      SpecialMoveClasses(13)=Class'kfgamecontent.KFSM_PlayerFleshpound_Rage'
      SpecialMoveClasses(14)=Class'KFGame.KFSM_Evade'
      SpecialMoveClasses(15)=None
      SpecialMoveClasses(16)=Class'KFGame.KFSM_Block'
      SpecialMoveClasses(17)=None
      SpecialMoveClasses(18)=None
      SpecialMoveClasses(19)=None
      SpecialMoveClasses(20)=None
      SpecialMoveClasses(21)=None
      SpecialMoveClasses(22)=None
      SpecialMoveClasses(23)=None
      SpecialMoveClasses(24)=None
      SpecialMoveClasses(25)=None
      SpecialMoveClasses(26)=None
      SpecialMoveClasses(27)=None
      SpecialMoveClasses(28)=None
      SpecialMoveClasses(29)=Class'KFGame.KFSM_GrappleVictim'
      SpecialMoveClasses(30)=Class'KFGame.KFSM_HansGrappleVictim'
      Name="SpecialMoveHandler_0"
   End Object
   Mass=220.000000
   Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0 Archetype=KFMeleeHelperAI'KFGame.Default__KFPawn_Monster:MeleeHelper_0'
      BaseDamage=30.000000
      MyDamageType=Class'kfgamecontent.KFDT_Bludgeon_Fleshpound'
      MomentumTransfer=65000.000000
      MaxHitRange=260.000000
      Name="MeleeHelper_0"
   End Object
   MeleeAttackHelper=KFMeleeHelperAI'ZedternalReborn.Default__WMPawn_ZedFleshpound_Omega:WMMeleeHelper_0'
   Begin Object Name=KFPawnSkeletalMeshComponent Archetype=KFSkeletalMeshComponent'KFGame.Default__KFPawn_Monster:KFPawnSkeletalMeshComponent'
      WireframeColor=(B=0,G=255,R=255,A=255)
      MinDistFactorForKinematicUpdate=0.200000
      bSkipAllUpdateWhenPhysicsAsleep=True
      bIgnoreControllersWhenNotRendered=True
      bHasPhysicsAssetInstance=True
      bPerBoneMotionBlur=True
      bOverrideAttachmentOwnerVisibility=True
      bChartDistanceFactor=True
      ReplacementPrimitive=None
      RBChannel=RBCC_Pawn
      RBDominanceGroup=20
      bOwnerNoSee=True
      bAcceptsDynamicDecals=True
      bUseOnePassLightingOnTranslucency=True
      CollideActors=True
      BlockZeroExtent=True
      BlockRigidBody=True
      RBCollideWithChannels=(Default=True,Pawn=True,Vehicle=True,BlockingVolume=True)
      Translation=(X=0.000000,Y=0.000000,Z=-86.000000)
      ScriptRigidBodyCollisionThreshold=200.000000
      PerObjectShadowCullDistance=2500.000000
      bAllowPerObjectShadows=True
      TickGroup=TG_DuringAsyncWork
      Name="KFPawnSkeletalMeshComponent"
   End Object
   Mesh=KFPawnSkeletalMeshComponent
   Name="Default__WMPawn_ZedFleshpound_Omega"
}
