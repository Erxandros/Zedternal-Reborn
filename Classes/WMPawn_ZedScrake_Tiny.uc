class WMPawn_ZedScrake_Tiny extends KFPawn_ZedScrake;

var transient Zed_Arch_ScrakeTiny ZedArch;

static function string GetLocalizedName()
{
	return "Tiny Scrake";
}

simulated function PostBeginPlay()
{
	IntendedBodyScale = 0.75f;
	ZedArch = class'Zed_Arch_ScrakeTiny'.static.GetArch(WorldInfo);
	if (ZedArch != None)
		updateArch();
	SetEnraged(True);
	super.PostBeginPlay();
}

simulated function updateArch()
{
	ZedArch = class'Zed_Arch_ScrakeTiny'.Static.GetArch(WorldInfo);
	if (ZedArch != None)
	{
		Mesh.AnimSets = ZedArch.zedClientArch.AnimSets;
		Mesh.SetAnimTreeTemplate(ZedArch.zedClientArch.AnimTreeTemplate);
		PawnAnimInfo = ZedArch.zedClientArch.AnimArchetype;
	}
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
	RageHealthThresholdNormal=0.99f
	RageHealthThresholdHard=0.99f
	RageHealthThresholdSuicidal=0.99f
	RageHealthThresholdHellOnEarth=0.99f

	bLargeZed=True
	bCanRage=True
	DoshValue=55
	XPValues(0)=35
	XPValues(1)=42
	XPValues(2)=45
	XPValues(3)=52
	LocalizationKey="WMPawn_ZedScrake_Omega"

	Begin Object Class=KFMeleeHelperAI Name=WMMeleeHelper_0
		BaseDamage=15.000000
		MyDamageType=Class'kfgamecontent.KFDT_Slashing_Scrake'
		MomentumTransfer=30000.000000
		MaxHitRange=180.000000
		Name="MeleeHelper_0"
	End Object
	MeleeAttackHelper=WMMeleeHelper_0

	HitZones(0)=(GoreHealth=400)
	HitZones(8)=(GoreHealth=25,DmgScale=0.200000,SkinID=2)
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

	SprintSpeed=680.0f
	Mass=150.0f
	GroundSpeed=540.0f
	Health=600

	Name="Default__WMPawn_ZedScrake_Tiny"
}
