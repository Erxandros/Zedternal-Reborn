class WMAIController_ZedHusk_Omega extends KFAIController_ZedHusk;

var float LastFireBallBarrageTime;
var float BaseTimeBetweenFireBallBarrages;
var float TimeBetweenFireBallBarrages;
var float FireballBarrageRandomizedValue;
var int MinDistanceForFireBallBarrage;
var int MaxDistanceForFireBallBarrage;

var float BaseHealthPercentForSprint;

var const float FireballBarrageFireIntervalNormal;
var const float FireballBarrageFireIntervalHard;
var const float FireballBarrageFireIntervalSuicidal;
var const float FireballBarrageFireIntervalHellOnEarth;

var const float RequiredHealthPercentForSprintNormal;
var const float RequiredHealthPercentForSprintHard;
var const float RequiredHealthPercentForSprintSuicidal;
var const float RequiredHealthPercentForSprintHellOnEarth;

event PostBeginPlay()
{
	super.PostBeginPlay();

	if (Skill == class'KFGameDifficultyInfo'.static.GetDifficultyValue(0)) // Normal
	{
		BaseTimeBetweenFireBallBarrages = FireballBarrageFireIntervalNormal;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintNormal;
	}
	else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(1)) // Hard
	{
		BaseTimeBetweenFireBallBarrages = FireballBarrageFireIntervalHard;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintHard;
	}
	else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(2)) // Suicidal
	{
		BaseTimeBetweenFireBallBarrages = FireballBarrageFireIntervalSuicidal;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintSuicidal;
	}
	else // Hell on Earth
	{
		BaseTimeBetweenFireBallBarrages = FireballBarrageFireIntervalHellOnEarth;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintHellOnEarth;
	}
}

simulated function Tick(float DeltaTime)
{
	local float DistToTargetSq;

	if (Role == ROLE_Authority && Enemy != None && MyKFPawn != None)
	{
		if (`TimeSince(LastCheckSpecialMoveTime) >= CheckSpecialMoveTime && !MyKFPawn.IsDoingSpecialMove())
		{
			if (GetActiveCommand() != None && !GetActiveCommand().IsA('AICommand_SpecialMove'))
			{
				if (WorldInfo.FastTrace(Enemy.Location, Pawn.Location, , True))
				{
					DistToTargetSq = VSizeSq(Enemy.Location - Pawn.Location);
					if (!IsSuicidal() && CanDoFireballBarrage(DistToTargetSq))
					{
						if (KFGameInfo(WorldInfo.Game) != None && KFGameInfo(WorldInfo.Game).GameConductor != None)
						{
							KFGameInfo(WorldInfo.Game).GameConductor.UpdateOverallAttackCoolDowns(self);
						}

						class'WMAICommand_HuskOmegaFireBallBarrageAttack'.static.FireBallBarrageAttack(self);
						TimeBetweenFireBallBarrages = BaseTimeBetweenFireBallBarrages + RandRange(-FireballBarrageRandomizedValue, FireballBarrageRandomizedValue);
					}
				}
			}
		}
	}

	super.Tick(DeltaTime);
}

function bool CanDoFireballBarrage(float DistToTargetSq)
{
	if(!CheckOverallCooldownTimer())
		return False;

	return ((LastFireBallBarrageTime == 0 || (`TimeSince(LastFireBallBarrageTime) > TimeBetweenFireBallBarrages))
		&& DistToTargetSq >= Square(MinDistanceForFireBallBarrage)
		&& DistToTargetSq <= Square(MaxDistanceForFireBallBarrage)
		&& MyKFPawn.CanDoSpecialMove(SM_Custom1))
		&& IsCeilingClear();
}

function bool IsCeilingClear()
{
	local vector TraceStart, TraceEnd, Extent;

	if (MyKFPawn == None)
	{
		return False;
	}

	TraceStart = MyKFPawn.Location + vect(0,0,1) * MyKFPawn.GetCollisionHeight();
	TraceEnd = TraceStart + vect(0,0,1) * 175.0f;
	Extent.X = MyKFPawn.GetCollisionRadius() * 2.0f;
	Extent.Y = Extent.X;
	Extent.Z = 1.0f;

	return MyKFPawn.FastTrace(TraceEnd, TraceStart, Extent, True);
}

function bool ShouldSprint()
{
	if (GetHealthPercentage() <= BaseHealthPercentForSprint)
		return True;
	else
		return super.ShouldSprint();
}

function ShootRandomFireball(class<KFProj_Husk_Fireball> FireballClass)
{
	local vector SocketLocation, DirToEnemy;
	local KFProj_Husk_Fireball MyFireball;
	local vector randVectorDraw;
	local KFPawn_ZedHusk MyHuskPawn;

	if (MyKFPawn == None)
	{
		return;
	}

	SocketLocation = MyKFPawn.GetPawnViewLocation();
	if (Role == ROLE_Authority)
	{
		randVectorDraw.X = FRand() * 2.0f - 1.0f;
		randVectorDraw.Y = FRand() * 2.0f - 1.0f;
		randVectorDraw.Z = FRand() + 0.1f;
		DirToEnemy = normal(randVectorDraw);

		MyHuskPawn = KFPawn_ZedHusk(MyKFPawn);

		// Shoot the fireball
		MyFireball = Spawn(FireballClass, MyKFPawn, , SocketLocation, Rotator(DirToEnemy));
		MyFireball.Instigator = MyKFPawn;
		MyFireball.InstigatorController = self;

		// Set our difficulty setings
		MyFireball.ExplosionTemplate.MomentumTransferScale = MyHuskPawn.FireballSettings.ExplosionMomentum * 0.5f;
		MyFireball.bSpawnGroundFire = False;

		// Fire
		MyFireball.Init(DirToEnemy);
	}
}

function ShootFireballBarrage(class<KFProj_Husk_Fireball> FireballClass, vector FireballOffset)
{
	local vector SocketLocation, DirToEnemy;
	local KFProj_Husk_Fireball MyFireball;
	local Vector AimLocation, GroundAimLocation;
	local float SplashAimChance;
	local vector randVectorDraw;
	local float randDraw;
	local KFPawn_ZedHusk MyHuskPawn;

	if (MyKFPawn == None)
	{
		return;
	}

	SocketLocation = MyKFPawn.GetPawnViewLocation() + (FireballOffset >> Pawn.GetViewRotation());
	if (MyKFPawn.Health > 0.0f && Role == ROLE_Authority)
	{
		AimLocation = Enemy.Location;

		SplashAimChance = 0.6f;

		randDraw = FRand();

		if (randDraw < SplashAimChance)
		{
			// Simple pass at making the Husk try and do splash damage when it shoots at a player rather than just shoot directly at them (and most likely miss)
			GroundAimLocation = Enemy.Location - (vect(0,0,1) * Enemy.GetCollisionHeight());

			if (GroundAimLocation.Z < SocketLocation.Z)
			{
				AimLocation = GroundAimLocation;
			}
		}

		randVectorDraw = VRand();
		DirToEnemy = normal(AimLocation - SocketLocation) + randVectorDraw * FireballAimError;

		DirToEnemy.Z = 1.1f + FRand() * 0.3f;
		DirToEnemy.X += FRand() * 0.2f - 0.1f;
		DirToEnemy.Y += FRand() * 0.2f - 0.1f;
		DirToEnemy = normal(DirToEnemy);

		MyHuskPawn = KFPawn_ZedHusk(MyKFPawn);

		// Shoot the fireball
		MyFireball = Spawn(FireballClass, MyKFPawn,, SocketLocation, Rotator(DirToEnemy));
		MyFireball.Instigator = MyKFPawn;
		MyFireball.InstigatorController = self;

		// Set our difficulty setings
		MyFireball.ExplosionTemplate.MomentumTransferScale = MyHuskPawn.FireballSettings.ExplosionMomentum;
		MyFireball.bSpawnGroundFire = MyHuskPawn.FireballSettings.bSpawnGroundFire;

		// Fire
		MyFireball.Init(DirToEnemy);

		LastFireBallBarrageTime = WorldInfo.TimeSeconds;
	}
}

defaultproperties
{
	bUseDesiredRotationForMelee=False
	bCanTeleportCloser=False

	// Behaviors
	EvadeGrenadeChance=0.8f
	CheckSpecialMoveTime=0.25f

	// Fireball
	MinDistanceForFireBall=300
	MaxDistanceForFireBall=3000

	FireballFireIntervalNormal=4.0f
	FireballFireIntervalHard=3.3f
	FireballFireIntervalSuicidal=2.8f
	FireballFireIntervalHellOnEarth=2.2f

	FireballRandomizedValue=2.5f

	SplashAimChanceNormal=0.25f
	SplashAimChanceHard=0.35f
	SplashAimChanceSuicidal=0.5f
	SplashAimChanceHellOnEarth=0.75f

	FireballSpeed=4100.0f
	FireballAimError=0.03f
	FireballLeadTargetAimError=0.03f
	bDebugAimError=False
	bCanLeadTarget=False

	// Fireball Barrage
	MinDistanceForFireBallBarrage=600
	MaxDistanceForFireBallBarrage=750

	FireballBarrageFireIntervalNormal=3.5f
	FireballBarrageFireIntervalHard=3.0f
	FireballBarrageFireIntervalSuicidal=2.5f
	FireballBarrageFireIntervalHellOnEarth=2.0f

	FireballBarrageRandomizedValue=2.0f

	// Sprint
	RequiredHealthPercentForSprintNormal=0.7f
	RequiredHealthPercentForSprintHard=0.8f
	RequiredHealthPercentForSprintSuicidal=0.87f
	RequiredHealthPercentForSprintHellOnEarth=0.95f

	// FlameThrower
	TimeBetweenFlameThrower=8.0f
	MaxDistanceForFlameThrower=450
	LowIntensityAttackScaleOfFireballInterval=1.25f

	// Suicide
	MinDistanceToSuicide=425
	RequiredHealthPercentForSuicide=0.2f

	Name="Default__WMAIController_ZedHusk_Omega"
}
