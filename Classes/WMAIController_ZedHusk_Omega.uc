class WMAIController_ZedHusk_Omega extends KFAIController_ZedHusk;

var float BaseHealthPercentForSprint;

var const float RequiredHealthPercentForSprintNormal;
var const float RequiredHealthPercentForSprintHard;
var const float RequiredHealthPercentForSprintSuicidal;
var const float RequiredHealthPercentForSprintHellOnEarth;

event PostBeginPlay()
{
	super.PostBeginPlay();

	if (Skill == class'KFGameDifficultyInfo'.static.GetDifficultyValue(0)) // Normal
	{
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintNormal;
	}
	else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(1)) // Hard
	{
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintHard;
	}
	else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(2)) // Suicidal
	{
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintSuicidal;
	}
	else // Hell on Earth
	{
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintHellOnEarth;
	}
}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
}

function bool ShouldSprint()
{
	if (GetHealthPercentage() <= BaseHealthPercentForSprint)
		return true;
	else
		return super.ShouldSprint();
}

function ShootRandomFireball(class<KFProj_Husk_Fireball> FireballClass)
{
	local vector SocketLocation, DirToEnemy;
	local KFProj_Husk_Fireball MyFireball;
	local vector randVectorDraw;
	local KFPawn_ZedHusk MyHuskPawn;

	if (MyKFPawn == none)
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
		MyFireball.bSpawnGroundFire = false;

		// Fire
		MyFireball.Init(DirToEnemy);
	}
}

function ShootFireballB(class<KFProj_Husk_Fireball> FireballClass, vector FireballOffset)
{
	local vector SocketLocation, DirToEnemy;
	local KFProj_Husk_Fireball MyFireball;
	local Vector AimLocation, GroundAimLocation;
	local float SplashAimChance;
	local vector randVectorDraw;
	local float randDraw;
	local KFPawn_ZedHusk MyHuskPawn;

	if (MyKFPawn == none)
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
	}
}

defaultproperties
{
	MinDistanceToSuicide=425.000000
	RequiredHealthPercentForSuicide=0.200000
	RequiredHealthPercentForSprintNormal=0.700000
	RequiredHealthPercentForSprintHard=0.800000
	RequiredHealthPercentForSprintSuicidal=0.870000
	RequiredHealthPercentForSprintHellOnEarth=0.950000
	TimeBetweenFlameThrower=8.000000
	FireballRandomizedValue=2.500000
	MaxDistanceForFlameThrower=450
	MaxDistanceForFireBall=3000
	CheckSpecialMoveTime=0.250000
	FireballSocketName="FireballSocket"
	FireballAimError=0.030000
	FireballLeadTargetAimError=0.030000
	FireballSpeed=4100.000000
	SplashAimChanceNormal=0.250000
	SplashAimChanceHard=0.350000
	SplashAimChanceSuicidal=0.500000
	SplashAimChanceHellOnEarth=0.750000
	FireballFireIntervalNormal=4.000000
	FireballFireIntervalHard=3.300000
	FireballFireIntervalSuicidal=2.800000
	FireballFireIntervalHellOnEarth=2.200000
	LowIntensityAttackScaleOfFireballInterval=1.250000
	bCanTeleportCloser=False
	bUseDesiredRotationForMelee=False
	EvadeGrenadeChance=0.800000
	BaseShapeOfProjectileForCalc=(X=10.000000,Y=10.000000,Z=10.000000)

	Name="Default__WMAIController_ZedHusk_Omega"
}
