class WMPawn_ZedScrake_Omega extends KFPawn_ZedScrake;

var const AnimSet ScrakeOmegaAnimSet;
var const KFPawnAnimInfo ScrakeOmegaAnimInfo;

var transient ParticleSystemComponent SpecialFXPSCs[2];
var const float ExtraAfflictionResistance, ExtraDamageResistance;

static function string GetLocalizedName()
{
	return "Scrake Omega";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 1.16f;
	bVersusZed = True;

	Mesh.AnimSets.AddItem(ScrakeOmegaAnimSet);
	PawnAnimInfo = ScrakeOmegaAnimInfo;

	super.PostBeginPlay();

	UpdateGameplayMICParams();
	if (WorldInfo.NetMode != NM_DedicatedServer)
		ApplySpecialFX();
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
	local float CurrentMod;

	// Omega ZEDs have extra resistance against all damage type
	CurrentMod = super.GetDamageTypeModifier(DT);
	return FMax(0.025f, CurrentMod - ExtraDamageResistance);
}

simulated function AdjustAffliction(out float AfflictionPower)
{
	super.AdjustAffliction(AfflictionPower);
	AfflictionPower *= 1.0f - ExtraAfflictionResistance;
}

function CauseHeadTrauma(float BleedOutTime = 5.0f)
{
	if (!bIsHeadless && !bPlayedDeath && !bDisableHeadless)
	{
		if (MyKFAIC != None && KFGameInfo(WorldInfo.Game) != None && MyKFAIC.TimeFirstSawPlayer >= 0)
		{
			KFGameInfo(WorldInfo.Game).GameConductor.HandleZedKill(FMax(`TimeSince(MyKFAIC.TimeFirstSawPlayer), 0.0f));
			MyKFAIC.TimeFirstSawPlayer = -1;
		}

		bPlayShambling = True;
		bIsHeadless = True;

		if (MyKFAIC != None)
		{
			MyKFAIC.SetSprintingDisabled(True);
		}

		bCanBeAdheredTo = False;
		bCanBeFrictionedTo = False;

		StopAkEventsOnBone('head');

		if (IsDoingSpecialMove() && Mesh.RootMotionMode == RMM_Accel)
		{
			Died(LastHitBy, class'DamageType', Location);
		}

		if (IsAliveAndWell() && MyKFAIC != None)
		{
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
	ScrakeOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Scrake.Scrake_Omega_AnimSet'
	ScrakeOmegaAnimInfo=KFPawnAnimInfo'ZedternalReborn_Zeds.Scrake.Scrake_Omega_AnimGroup'
	LocalizationKey="WMPawn_ZedScrake_Omega"

	RageHealthThresholdNormal=0.6f
	RageHealthThresholdHard=0.7f
	RageHealthThresholdSuicidal=0.75f
	RageHealthThresholdHellOnEarth=0.8f

	bVersusZed=False
	DoshValue=150
	Health=3800
	Mass=150.0f
	GroundSpeed=215.0f
	SprintSpeed=700.0f
	ExtraAfflictionResistance=0.4f
	ExtraDamageResistance=0.3f

	Begin Object Name=MeleeHelper_0
		BaseDamage=50.0f
	End Object

	XPValues(0)=68
	XPValues(1)=90
	XPValues(2)=120
	XPValues(3)=138

	HitZones(0)=(GoreHealth=1800)

	Name="Default__WMPawn_ZedScrake_Omega"
}
