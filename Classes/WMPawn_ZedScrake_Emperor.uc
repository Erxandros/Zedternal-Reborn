class WMPawn_ZedScrake_Emperor extends KFPawn_ZedScrake;

var transient Zed_Arch_ScrakeOmega ZedArch;

static function string GetLocalizedName()
{
	return "Scrake Emperor";
}

simulated function PostBeginPlay()
{
	Mesh.SetScale(1.40);
	ZedArch = class'Zed_Arch_ScrakeOmega'.static.GetArch(WorldInfo);
	if (ZedArch!=none)
		updateArch();
	super.PostBeginPlay();
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_ScrakeOmega'.Static.GetArch(WorldInfo);
	if(ZedArch!=None)
	{
		Mesh.SetSkeletalMesh(ZedArch.zedClientArch.CharacterMesh);
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

defaultproperties
{
   DifficultySettings=Class'Zedternal.WMDifficulty_Scrake_Emperor'
   RageHealthThresholdNormal=0.200000
   RageHealthThresholdHard=0.225000
   RageHealthThresholdSuicidal=0.250000
   RageHealthThresholdHellOnEarth=0.275000
   bLargeZed=True
   bCanRage=True
   DoshValue=400
   XPValues(0)=75.000000
   XPValues(1)=100.000000
   XPValues(2)=135.000000
   XPValues(3)=150.000000
   LocalizationKey="WMPawn_ZedScrake_Emperor"
   
   Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0 Archetype=KFMeleeHelperAI'KFGame.Default__KFPawn_Monster:MeleeHelper_0'
      BaseDamage=20.000000
      MyDamageType=Class'kfgamecontent.KFDT_Slashing_Scrake'
      MomentumTransfer=60000.000000
      MaxHitRange=200.000000
      Name="MeleeHelper_0"
   End Object
   MeleeAttackHelper=KFMeleeHelperAI'Zedternal.Default__WMPawn_ZedScrake_Emperor:WMMeleeHelper_0'
   
   bVersusZed=True

   HitZones(0)=(GoreHealth=3000)
   HitZones(1)=()
   HitZones(2)=()
   HitZones(3)=()
   HitZones(4)=()
   HitZones(5)=()
   HitZones(6)=()
   HitZones(7)=()
   HitZones(8)=(GoreHealth=75,DmgScale=0.100000,SkinID=2)
   HitZones(9)=()
   HitZones(10)=()
   HitZones(11)=()
   HitZones(12)=()
   HitZones(13)=()
   HitZones(14)=()
   HitZones(15)=()
   HitZones(16)=()
   HitZones(17)=()
   HitZones(18)=(ZoneName="rchainsaw",BoneName="RightForearm",GoreHealth=75,DmgScale=0.100000,Limb=BP_RightArm,SkinID=2)
   HitZones(19)=(ZoneName="rchainsawblade",BoneName="RightForearm",GoreHealth=75,DmgScale=0.100000,Limb=BP_RightArm,SkinID=2)
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

   SprintSpeed=640.000000

   Mass=225.000000
   GroundSpeed=180.000000
   Health=4000
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
   Name="Default__WMPawn_ZedScrake_Emperor"
}
