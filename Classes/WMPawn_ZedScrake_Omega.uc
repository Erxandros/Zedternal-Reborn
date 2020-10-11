class WMPawn_ZedScrake_Omega extends KFPawn_ZedScrake;

var transient Zed_Arch_ScrakeOmega ZedArch;
var transient ParticleSystemComponent SpecialFXPSCs[2];
var float ExtraResistance;

static function string GetLocalizedName()
{
	return "Scrake Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.16f;
	ZedArch = class'Zed_Arch_ScrakeOmega'.static.GetArch(WorldInfo);
	if (ZedArch != None)
		updateArch();

	if (WorldInfo.NetMode != NM_DedicatedServer)
		ApplySpecialFX();

	bVersusZed = True;

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
		SpecialFXPSCs[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_L', True, vect(0,0,0));

	SocketBoneName = Mesh.GetSocketBoneName('FX_EYE_R');
	if (SocketBoneName != '' && SocketBoneName != 'None')
		SpecialFXPSCs[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ParticleSystem'ZedternalReborn_Zeds.FX_Omega', Mesh, 'FX_EYE_R', True, vect(0,0,0));
}

simulated function EndSpecialFX()
{
	if (SpecialFXPSCs[0] != None && SpecialFXPSCs[0].bIsActive)
	{
		SpecialFXPSCs[0].DeactivateSystem();
	}
	if (SpecialFXPSCs[1] != None && SpecialFXPSCs[1].bIsActive)
	{
		SpecialFXPSCs[1].DeactivateSystem();
	}
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_ScrakeOmega'.Static.GetArch(WorldInfo);
	if (ZedArch != None)
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

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < CharacterMICs.length; ++i)
		{
			CharacterMICs[i].SetVectorParameterValue('Vector_GlowColor', class'WMPawn_OmegaConstants'.default.OmegaColor);
			CharacterMICs[i].SetVectorParameterValue('Vector_FresnelGlowColor', class'WMPawn_OmegaConstants'.default.OmegaFresnelColor);
		}
	}
}

function float GetDamageTypeModifier(class<DamageType> DT)
{
	local float currentMod;

	// Omega ZEDs have extra resistance against all damage type
	currentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.01f, currentMod - ExtraResistance);
}

function CauseHeadTrauma(float BleedOutTime=5.f)
{
	if (!bIsHeadless && !bPlayedDeath && !bDisableHeadless)
	{
		if (MyKFAIC != None && KFGameInfo(WorldInfo.Game) != None && MyKFAIC.TimeFirstSawPlayer >= 0)
		{
			KFGameInfo(WorldInfo.Game).GameConductor.HandleZedKill(FMax((WorldInfo.TimeSeconds - MyKFAIC.TimeFirstSawPlayer),0.0));
			// Set this so we know we already logged a kill for our pawn
			MyKFAIC.TimeFirstSawPlayer = -1;
		}

		bPlayShambling = True;
		bIsHeadless = True;

		if (MyKFAIC != None)
		{
			MyKFAIC.SetSprintingDisabled(True);
		}

		// No more auto aiming to this zed
		bCanBeAdheredTo = False;
		bCanBeFrictionedTo = False;

		StopAkEventsOnBone('head');

		// insti-kill while doing a root motion SM (uninterruptable)
		if (IsDoingSpecialMove() && Mesh.RootMotionMode == RMM_Accel)
		{
			Died(LastHitBy, class'DamageType', Location);
		}

		// initiate the "headless wander" AICommand
		if (IsAliveAndWell() && MyKFAIC != None)
		{
			// Only allow headless wander if were doing an SM that allows a wander interupt
			// otherwise wait until the end of the move
			if (SpecialMove == SM_None || !SpecialMoves[SpecialMove].bCanOnlyWanderAtEnd)
			{
				MyKFAIC.DoHeadlessWander();
			}
		}

		if (BleedOutTime > 0)
		{
			SetTimer(FMax(7.0f, BleedOutTime), False, nameof(BleedOutTimer));
		}
	}
}

simulated event bool UsePlayerControlledZedSkin()
{
	return True;
}

defaultproperties
{
	RageHealthThresholdNormal=0.6f
	RageHealthThresholdHard=0.7f
	RageHealthThresholdSuicidal=0.75f
	RageHealthThresholdHellOnEarth=0.8f

	bLargeZed=True
	bCanRage=True
	DoshValue=150
	XPValues(0)=68
	XPValues(1)=90
	XPValues(2)=120
	XPValues(3)=138
	Health=3800
	ExtraResistance=0.3f
	GroundSpeed=215.0f
	SprintSpeed=700.0f
	LocalizationKey="WMPawn_ZedScrake_Omega"

	Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0
		BaseDamage=50.0f
		MaxHitRange=200.0f
		MomentumTransfer=45000.0f
		MyDamageType=class'KFGameContent.KFDT_Slashing_Scrake'
	End Object
	MeleeAttackHelper=WMMeleeHelper_0

	bVersusZed=False

	HitZones(0)=(GoreHealth=1800)

	Mass=150.0f

	Name="Default__WMPawn_ZedScrake_Omega"
}
