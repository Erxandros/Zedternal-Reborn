class WMPawn_ZedScrake_Tiny extends KFPawn_ZedScrake;

var const AnimSet ScrakeTinyAnimSet;
var const AnimSet ScrakeOmegaAnimSet;
var const KFPawnAnimInfo ScrakeTinyAnimInfo;

static function string GetLocalizedName()
{
	return "Tiny Scrake";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.75f;

	Mesh.AnimSets.AddItem(ScrakeTinyAnimSet);
	Mesh.AnimSets.AddItem(ScrakeOmegaAnimSet);
	PawnAnimInfo = ScrakeTinyAnimInfo;

	super.PostBeginPlay();

	SetEnraged(True);
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

defaultproperties
{
	ScrakeTinyAnimSet=AnimSet'ZedternalReborn_Zeds.Scrake.Tiny_Scrake_AnimSet'
	ScrakeOmegaAnimSet=AnimSet'ZedternalReborn_Zeds.Scrake.Scrake_Omega_AnimSet'
	ScrakeTinyAnimInfo=KFPawnAnimInfo'ZedternalReborn_Zeds.Scrake.Tiny_Scrake_AnimGroup'
	LocalizationKey="WMPawn_ZedScrake_Omega"

	RageHealthThresholdNormal=0.99f
	RageHealthThresholdHard=0.99f
	RageHealthThresholdSuicidal=0.99f
	RageHealthThresholdHellOnEarth=0.99f

	DoshValue=55
	Health=600
	Mass=150.0f
	GroundSpeed=540.0f
	SprintSpeed=680.0f

	Begin Object Name=MeleeHelper_0
		BaseDamage=15.0f
		MaxHitRange=180.0f
		MomentumTransfer=30000.0f
	End Object

	XPValues(0)=35
	XPValues(1)=42
	XPValues(2)=45
	XPValues(3)=52

	HitZones(0)=(GoreHealth=400)
	HitZones(8)=(GoreHealth=25)

	Name="Default__WMPawn_ZedScrake_Tiny"
}
