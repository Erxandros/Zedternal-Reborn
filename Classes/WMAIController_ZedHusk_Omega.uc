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
