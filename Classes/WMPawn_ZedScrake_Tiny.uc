class WMPawn_ZedScrake_Tiny extends KFPawn_ZedScrake;

var transient Zed_Arch_ScrakeTiny ZedArch;

static function string GetLocalizedName()
{
	return "Tiny Scrake";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.750000;
	ZedArch = class'Zed_Arch_ScrakeTiny'.static.GetArch(WorldInfo);
	if (ZedArch!=none)
		updateArch();
	SetEnraged( true );
	super.PostBeginPlay();
	
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_ScrakeTiny'.Static.GetArch(WorldInfo);
	if(ZedArch!=None)
	{
		Mesh.AnimSets = ZedArch.zedClientArch.AnimSets;
		Mesh.SetAnimTreeTemplate(ZedArch.zedClientArch.AnimTreeTemplate);
		PawnAnimInfo = ZedArch.zedClientArch.AnimArchetype;
	}
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

defaultproperties
{
   RageHealthThresholdNormal=0.990000
   RageHealthThresholdHard=0.990000
   RageHealthThresholdSuicidal=0.990000
   RageHealthThresholdHellOnEarth=0.990000
   bLargeZed=True
   bCanRage=True
   DoshValue=55
   XPValues(0)=35.000000
   XPValues(1)=42.000000
   XPValues(2)=45.000000
   XPValues(3)=52.000000
   LocalizationKey="WMPawn_ZedScrake_Omega"
   
   Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0 Archetype=KFMeleeHelperAI'KFGame.Default__KFPawn_Monster:MeleeHelper_0'
      BaseDamage=15.000000
      MyDamageType=Class'kfgamecontent.KFDT_Slashing_Scrake'
      MomentumTransfer=30000.000000
      MaxHitRange=180.000000
      Name="MeleeHelper_0"
   End Object
   MeleeAttackHelper=KFMeleeHelperAI'Zedternal.Default__WMPawn_ZedScrake_Tiny:WMMeleeHelper_0'

   HitZones(0)=(GoreHealth=400)
   HitZones(1)=()
   HitZones(2)=()
   HitZones(3)=()
   HitZones(4)=()
   HitZones(5)=()
   HitZones(6)=()
   HitZones(7)=()
   HitZones(8)=(GoreHealth=25,DmgScale=0.200000,SkinID=2)
   HitZones(9)=()
   HitZones(10)=()
   HitZones(11)=()
   HitZones(12)=()
   HitZones(13)=()
   HitZones(14)=()
   HitZones(15)=()
   HitZones(16)=()
   HitZones(17)=()
   HitZones(18)=(ZoneName="rchainsaw",BoneName="RightForearm",GoreHealth=25,DmgScale=0.200000,Limb=BP_RightArm,SkinID=2)
   HitZones(19)=(ZoneName="rchainsawblade",BoneName="RightForearm",GoreHealth=25,DmgScale=0.200000,Limb=BP_RightArm,SkinID=2)
   IncapSettings(0)=(Duration=2.200000,Cooldown=10.000000,Vulnerability=(0.700000))
   IncapSettings(1)=(Duration=3.000000,Cooldown=5.000000,Vulnerability=(0.900000))
   IncapSettings(2)=(Cooldown=1.350000,Vulnerability=(0.500000))
   IncapSettings(3)=(Cooldown=1.700000,Vulnerability=(0.200000))
   IncapSettings(4)=(Cooldown=5.000000,Vulnerability=(0.100000))
   IncapSettings(5)=(Duration=1.500000,Cooldown=10.000000,Vulnerability=(0.200000,0.700000,0.200000,0.200000,0.200000))
   IncapSettings(6)=(Duration=1.500000,Cooldown=20.000000,Vulnerability=(0.600000))
   IncapSettings(7)=(Duration=1.500000,Cooldown=8.500000,Vulnerability=(0.700000,0.700000,1.000000,0.700000))
   IncapSettings(8)=(Cooldown=10.000000,Vulnerability=(0.200000,0.200000,0.250000,0.200000))
   IncapSettings(9)=(Duration=0.500000,Cooldown=1.500000,Vulnerability=(0.500000))
   IncapSettings(10)=(Duration=2.500000,Cooldown=10.000000,Vulnerability=(1.000000))

   SprintSpeed=680.000000

   Begin Object Name=SpecialMoveHandler_0 Archetype=KFSpecialMoveHandler'kfgamecontent.Default__KFPawn_ZedScrake:SpecialMoveHandler_0'
      SpecialMoveClasses(0)=None
      SpecialMoveClasses(1)=Class'KFGame.KFSM_MeleeAttack'
      SpecialMoveClasses(2)=Class'kfgamecontent.KFSM_PlayerScrake_Melee'
      SpecialMoveClasses(3)=Class'KFGame.KFSM_GrappleCombined'
      SpecialMoveClasses(4)=Class'KFGame.KFSM_Stumble'
      SpecialMoveClasses(5)=Class'KFGame.KFSM_RecoverFromRagdoll'
      SpecialMoveClasses(6)=Class'KFGame.KFSM_RagdollKnockdown'
      SpecialMoveClasses(7)=Class'KFGame.KFSM_DeathAnim'
      SpecialMoveClasses(8)=Class'KFGame.KFSM_Stunned'
      SpecialMoveClasses(9)=Class'KFGame.KFSM_Frozen'
      SpecialMoveClasses(10)=None
      SpecialMoveClasses(11)=None
      SpecialMoveClasses(12)=Class'KFGame.KFSM_Zed_Taunt'
      SpecialMoveClasses(13)=Class'KFGame.KFSM_Block'
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
   SpecialMoveHandler=KFSpecialMoveHandler'Zedternal.Default__WMPawn_ZedScrake_Omega:SpecialMoveHandler_0'
   Mass=150.000000
   GroundSpeed=540.000000
   Health=600
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
	  Scale=1.000000
      Name="KFPawnSkeletalMeshComponent"
   End Object
   Mesh=KFPawnSkeletalMeshComponent
   RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
   Name="Default__WMPawn_ZedScrake_Tiny"
}
