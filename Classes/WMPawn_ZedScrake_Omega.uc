class WMPawn_ZedScrake_Omega extends KFPawn_ZedScrake;

var transient Zed_Arch_ScrakeOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;
var linearColor omegaColor, omegaFresnelColor;

static function string GetLocalizedName()
{
	return "Scrake Omega";
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
	IntendedBodyScale = 1.160000;
	ZedArch = class'Zed_Arch_ScrakeOmega'.static.GetArch(WorldInfo);
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
	ZedArch = class'Zed_Arch_ScrakeOmega'.Static.GetArch(WorldInfo);
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

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );

	if( bCanRage && !bPlayedDeath && (GetHealthPercentage() < RageHealthThreshold || GetHeadHealthPercent() < RageHealthThreshold) )
	{
		SetEnraged( true );
	}
}


/*********************************************************************************************
* Movement
********************************************************************************************* */

function SetSprinting( bool bNewSprintStatus )
{
	if( bEmpDisrupted && (MyKFAIC == none || !MyKFAIC.bHasDebugCommand) )
	{
		return;
	}

	super.SetSprinting( bNewSprintStatus );
}

/*********************************************************************************************
* Notifications
********************************************************************************************* */

/** Interrupt certain moves when bEmpDisrupted is set */
function OnStackingAfflictionChanged(byte Id)
{
	Super.OnStackingAfflictionChanged(Id);

	if( bEMPDisrupted && bIsSprinting && MyKFAIC != none && IsAliveAndWell() )
	{
		SetSprinting( false );
	}
}

function CauseHeadTrauma(float BleedOutTime=5.f)
{
	if ( !bIsHeadless && !bPlayedDeath && !bDisableHeadless )
	{
    	if( MyKFAIC != none && KFGameInfo(WorldInfo.Game) != none && MyKFAIC.TimeFirstSawPlayer >= 0 )
    	{
            KFGameInfo(WorldInfo.Game).GameConductor.HandleZedKill( FMax((WorldInfo.TimeSeconds - MyKFAIC.TimeFirstSawPlayer),0.0));
    	   	// Set this so we know we already logged a kill for our pawn
            MyKFAIC.TimeFirstSawPlayer = -1;
    	}

        bPlayShambling = true;
		bIsHeadless = true;

		if( MyKFAIC != none )
		{
			MyKFAIC.SetSprintingDisabled(true);
		}

        // No more auto aiming to this zed
        bCanBeAdheredTo=false;
        bCanBeFrictionedTo=false;

		StopAkEventsOnBone( 'head' );

		// insti-kill while doing a root motion SM (uninterruptable)
		if ( IsDoingSpecialMove() && Mesh.RootMotionMode == RMM_Accel )
		{
			Died(LastHitBy, class'DamageType', Location);
		}

		// initiate the "headless wander" AICommand
		if( IsAliveAndWell() && MyKFAIC != none )
		{
            // Only allow headless wander if were doing an SM that allows a wander interupt
            // otherwise wait until the end of the move
			if ( SpecialMove == SM_None || !SpecialMoves[SpecialMove].bCanOnlyWanderAtEnd )
			{
				MyKFAIC.DoHeadlessWander();
			}
		}

		if ( BleedOutTime > 0 )
		{
			SetTimer(FMax(7.f,BleedOutTime) , false, nameof(BleedOutTimer));
		}
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
    return true;
}

defaultproperties
{
   RageHealthThresholdNormal=0.600000
   RageHealthThresholdHard=0.700000
   RageHealthThresholdSuicidal=0.750000
   RageHealthThresholdHellOnEarth=0.8000000
   bLargeZed=True
   bCanRage=True
   DoshValue=150
   XPValues(0)=68.000000
   XPValues(1)=90.000000
   XPValues(2)=120.000000
   XPValues(3)=138.000000
   Health=3800
   ExtraResistance=0.300000
   GroundSpeed=215.000000
   SprintSpeed=700.000000
   LocalizationKey="WMPawn_ZedScrake_Omega"
   
   Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0 Archetype=KFMeleeHelperAI'KFGame.Default__KFPawn_Monster:MeleeHelper_0'
      BaseDamage=50.000000
      MyDamageType=Class'kfgamecontent.KFDT_Slashing_Scrake'
      MomentumTransfer=45000.000000
      MaxHitRange=200.000000
      Name="MeleeHelper_0"
   End Object
   MeleeAttackHelper=KFMeleeHelperAI'ZedternalReborn.Default__WMPawn_ZedScrake_Omega:WMMeleeHelper_0'
   
   bVersusZed=False

   HitZones(0)=(GoreHealth=1800)
   
   omegaColor=(R=0.500000,G=0.250000,B=1.000000)
   omegaFresnelColor=(R=0.400000,G=0.250000,B=0.700000)

   Mass=150.000000
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
	  Scale=1.200000
      Name="KFPawnSkeletalMeshComponent"
   End Object
   Mesh=KFPawnSkeletalMeshComponent
   RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
   Name="Default__WMPawn_ZedScrake_Omega"
}
