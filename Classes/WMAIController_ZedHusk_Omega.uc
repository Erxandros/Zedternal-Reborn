class WMAIController_ZedHusk_Omega extends KFAIController_ZedHusk;

var float BaseHealthPercentForSprint, RequiredHealthPercentForSprintNormal, RequiredHealthPercentForSprintHard, RequiredHealthPercentForSprintSuicidal, RequiredHealthPercentForSprintHellOnEarth;

event PostBeginPlay()
{
	local KFGameInfo KFGI;

	super.PostBeginPlay();

	if (WorldInfo.Game != none)
	{
		KFGI = KFGameInfo(WorldInfo.Game);
		// If the difficulty is hard or higher, enable the flamethrower
		if (KFGI != none && KFGI.GameDifficulty >= KFGI.DifficultyInfo.GetDifficultyValue(2))
		{
			bCanUseFlameThrower = true;
		}
	}

	// Determine the interval of allowing fireballs to be fired
	if (Skill == class'KFGameDifficultyInfo'.static.GetDifficultyValue(0)) // Normal
	{
		BaseTimeBetweenFireBalls = FireballFireIntervalNormal;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintNormal;
	}
	else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(1)) // Hard
	{
		BaseTimeBetweenFireBalls = FireballFireIntervalHard;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintHard;
	}
	else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(2)) // Suicidal
	{
		BaseTimeBetweenFireBalls = FireballFireIntervalSuicidal;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintSuicidal;
	}
	else // Hell on Earth
	{
		BaseTimeBetweenFireBalls = FireballFireIntervalHellOnEarth;
		BaseHealthPercentForSprint = RequiredHealthPercentForSprintHellOnEarth;
	}

	// Set the low intensity attack cooldown based off the current fireball interval
	LowIntensityAttackCooldown = BaseTimeBetweenFireBalls * LowIntensityAttackScaleOfFireballInterval;

	TimeBetweenFireBalls = BaseTimeBetweenFireBalls + RandRange(-FireballRandomizedValue, FireballRandomizedValue);
}

simulated function Tick(FLOAT DeltaTime)
{
	local float DistToTargetSq;

	super.Tick(DeltaTime);

	if (Role == ROLE_Authority && Enemy != none && MyKFPawn != none)
	{
		// Do not check every tick
		if ((WorldInfo.TimeSeconds - LastCheckSpecialMoveTime) >= CheckSpecialMoveTime && !MyKFPawn.IsDoingSpecialMove())
		{
			if (GetActiveCommand() != none && !GetActiveCommand().IsA('AICommand_SpecialMove'))
			{
				// Trace from worldinfo, open doors ignore traces from zeds
				if (WorldInfo.FastTrace(Enemy.Location, Pawn.Location,, true))
				{
					DistToTargetSq = VSizeSq(Enemy.Location - Pawn.Location);

					// If you are suicidal, do not even try to use the flamethrower or fireball
					if (IsSuicidal())
					{
						if (CanDoSuicide(DistToTargetSq))
						{
							class'AICommand_Husk_Suicide'.static.Suicide(self);
						}
					}
					// Check if i can use my flamethrower
					else if (CanDoFlamethrower(DistToTargetSq))
					{
						if (KFGameInfo(WorldInfo.Game) != none && KFGameInfo(WorldInfo.Game).GameConductor != none)
						{
							KFGameInfo(WorldInfo.Game).GameConductor.UpdateOverallAttackCoolDowns(self);
						}

						class'AICommand_HuskFlameThrowerAttack'.static.FlameThrowerAttack(self);
					}
					// Check if i can use my projectile
					else if (CanDoFireball(DistToTargetSq))
					{
						if (KFGameInfo(WorldInfo.Game) != none && KFGameInfo(WorldInfo.Game).GameConductor != none)
						{
							KFGameInfo(WorldInfo.Game).GameConductor.UpdateOverallAttackCoolDowns(self);
						}

						class'AICommand_HuskFireBallAttack'.static.FireBallAttack(self);
						// Randomize the next fireball time
						TimeBetweenFireBalls = BaseTimeBetweenFireBalls + RandRange(-FireballRandomizedValue, FireballRandomizedValue);
					}
				}
			}
			LastCheckSpecialMoveTime = WorldInfo.TimeSeconds;
		}
	}
}


/** Always sprint if we are suicidal */
function bool ShouldSprint()
{
	if (IsSuicidal())
	{
		return true;
	}
	else if (GetHealthPercentage() <= BaseHealthPercentForSprint)
		return true;
	return super.ShouldSprint();
}

function ShootFireball(class<KFProj_Husk_Fireball> FireballClass, vector FireballOffset)
{
	local vector		SocketLocation, DirToEnemy, HitLocation, HitNormal;
	local KFProj_Husk_Fireball MyFireball;
	local actor			HitActor;
	local Vector AimLocation, GroundAimLocation;
	local float SplashAimChance;
	local vector randVectorDraw;
	local float randDraw;
	local vector displacementToHitLoc;
	local float distanceToHitLoc;
	local KFPawn_ZedHusk MyHuskPawn;

	if (MyKFPawn == none)
	{
		return;
	}

	if (bDebugAimError)
	{
		// Render debug lines and simulate several shots at once to evaluate aimerror
		DebugAimError(FireballSocketName, FireballAimError);
		return;
	}

	SocketLocation = MyKFPawn.GetPawnViewLocation() + (FireballOffset >> Pawn.GetViewRotation());
	if (MyKFPawn.Health > 0.f && Role == ROLE_Authority && MyKFPawn.IsDoingSpecialMove(SM_StandAndShootAttack))
	{
		AimLocation = Enemy.Location;

		// Determine the random chance of aiming at the ground for splash damage
		if (Skill == class'KFGameDifficultyInfo'.static.GetDifficultyValue(0)) // Normal
		{
			SplashAimChance = SplashAimChanceNormal;
		}
		else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(1)) // Hard
		{
			SplashAimChance = SplashAimChanceHard;
		}
		else if (Skill <= class'KFGameDifficultyInfo'.static.GetDifficultyValue(2)) // Suicidal
		{
			SplashAimChance = SplashAimChanceSuicidal;
		}
		else // Hell on Earth
		{
			SplashAimChance = SplashAimChanceHellOnEarth;
		}

		randDraw = FRand();

		if (!class'Engine'.static.GetEngine().bDIsableAILogging && self!= None) { self.AILog_Internal(GetFuncName() @ " SplashAimChance: " @ SplashAimChance @ " randDraw: " @ randDraw,'FireBall'); };

		if (randDraw < SplashAimChance)
		{
			// Simple pass at making the Husk try and do splash damage when it shoots at a player rather than just shoot directly at them (and most likely miss)
			GroundAimLocation = Enemy.Location - (vect(0,0,1) * Enemy.GetCollisionHeight());

			if (GroundAimLocation.Z < SocketLocation.Z)
			{
				AimLocation = GroundAimLocation;
			}
		}

		//DrawDebugLine(SocketLocation, AimLocation, 0, 0, 255, true);

		HitActor = WorldInfo.Trace(HitLocation, HitNormal, AimLocation, SocketLocation, true);

		// Don't shoot if it's too close
		if (HitActor == Enemy)
		{
			//DrawDebugStar(HitLocation, 50, 0, 255, 0, true);

			randVectorDraw = VRand();

			if (!bCanLeadTarget)
			{
				DirToEnemy = normal(AimLocation - SocketLocation) + randVectorDraw * FireballAimError;

				if (!class'Engine'.static.GetEngine().bDIsableAILogging && self!= None) { self.AILog_Internal(GetFuncName() @ " HitActor: " @ HitActor @ " Is My Enemy: " @ Enemy @ " randVectorDraw: " @ randVectorDraw @ " - not leading with an error of: " @ randVectorDraw * FireballAimError,'FireBall'); };
			}
			else
			{
				DirToEnemy = normal(CalcAimLocToHit(AimLocation, SocketLocation, FireballSpeed, FireballSpeed, Enemy.Velocity) - SocketLocation) + randVectorDraw * FireballLeadTargetAimError;

				if (!class'Engine'.static.GetEngine().bDIsableAILogging && self!= None) { self.AILog_Internal(GetFuncName() @ " HitActor: " @ HitActor @ " Is My Enemy: " @ Enemy @ " randVectorDraw: " @ randVectorDraw @ " - leading with an error of: " @ randVectorDraw * FireballLeadTargetAimError,'FireBall'); };
			}
		}
		else
		{
			// If our path to the enemy is blocked, try his last known position
			AimLocation = AICommand_HuskFireBallAttack(GetActiveCommand()).LastKnownEnemyLocation;
			HitActor = Trace(HitLocation, HitNormal, AimLocation, SocketLocation, true);

			displacementToHitLoc = HitLocation - SocketLocation;
			distanceToHitLoc = VSize(displacementToHitLoc);

			// If there is an object in front of us, cancel the attack
			if (distanceToHitLoc < 300)
			{
				//DrawDebugStar(HitLocation, 50, 255, 0, 0, true);

				if (!class'Engine'.static.GetEngine().bDIsableAILogging && self!= None) { self.AILog_Internal(GetFuncName() @ " HitActor: " @ HitActor @ " Is NOT My Enemy: " @ Enemy @ " and distanceToHitLoc: " @ distanceToHitLoc @ " is too close so not firing!!!",'FireBall'); };
				MyKFPawn.SpecialMoves[ SM_StandAndShootAttack ].AbortedByAICommand();
				LastFireBallTime = WorldInfo.TimeSeconds;
				return;
			}
			else // Otherwise fire at the enemies last known position
			{
				//DrawDebugStar(HitLocation, 50, 0, 0, 255, true);

				randVectorDraw = VRand();
				DirToEnemy = normal((AimLocation - SocketLocation) + randVectorDraw * FireballAimError);

				if (!class'Engine'.static.GetEngine().bDIsableAILogging && self!= None) { self.AILog_Internal(GetFuncName() @" Fire at enemy last known position: " @ Enemy @ AimLocation @ " randVectorDraw: " @ randVectorDraw @ " - leading with an error of: " @ randVectorDraw * FireballLeadTargetAimError,'FireBall'); };
			}
		}

		//DrawDebugLine(SocketLocation, SocketLocation + DirToEnemy * 5000.0, 255, 0, 0, true);
		MyHuskPawn = KFPawn_ZedHusk(MyKFPawn);

		// Shoot the fireball
		MyFireball = Spawn(FireballClass, MyKFPawn,, SocketLocation, Rotator(DirToEnemy));
		MyFireball.Instigator			= MyKFPawn;
		MyFireball.InstigatorController	= self;
		MyFireball.Speed				= FireballSpeed;
		MyFireball.MaxSpeed				= FireballSpeed;

		// Set our difficulty setings
		MyFireball.ExplosionTemplate.MomentumTransferScale = MyHuskPawn.FireballSettings.ExplosionMomentum;
		MyFireball.bSpawnGroundFire = MyHuskPawn.FireballSettings.bSpawnGroundFire;

		// Fire
		MyFireball.Init(DirToEnemy);

		LastFireBallTime = WorldInfo.TimeSeconds;
	}
}

function ShootRandomFireball(class<KFProj_Husk_Fireball> FireballClass)
{
	local vector		SocketLocation, DirToEnemy;
	local KFProj_Husk_Fireball MyFireball;
	local vector randVectorDraw;
	local KFPawn_ZedHusk MyHuskPawn;

	if (MyKFPawn == none)
	{
		return;
	}

	SocketLocation = MyKFPawn.GetPawnViewLocation();// + (FireballOffset >> Pawn.GetViewRotation());
	if (Role == ROLE_Authority)
	{
		randVectorDraw.X = FRand()*2.f-1.f;
		randVectorDraw.Y = FRand()*2.f-1.f;
		randVectorDraw.Z = FRand()+0.100000;
		DirToEnemy = normal(randVectorDraw);

		MyHuskPawn = KFPawn_ZedHusk(MyKFPawn);

		// Shoot the fireball
		MyFireball = Spawn(FireballClass, MyKFPawn,, SocketLocation, Rotator(DirToEnemy));
		MyFireball.Instigator			= MyKFPawn;
		MyFireball.InstigatorController	= self;

		// Set our difficulty setings
		MyFireball.ExplosionTemplate.MomentumTransferScale = MyHuskPawn.FireballSettings.ExplosionMomentum*0.500000;
		MyFireball.bSpawnGroundFire = false;

		// Fire
		MyFireball.Init(DirToEnemy);
	}
}

function ShootFireballB(class<KFProj_Husk_Fireball> FireballClass, vector FireballOffset)
{
	local vector		SocketLocation, DirToEnemy;
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
	if (MyKFPawn.Health > 0.f && Role == ROLE_Authority)
	{
		AimLocation = Enemy.Location;

		SplashAimChance = 0.600000;

		randDraw = FRand();

		if (!class'Engine'.static.GetEngine().bDIsableAILogging && self!= None) { self.AILog_Internal(GetFuncName() @ " SplashAimChance: " @ SplashAimChance @ " randDraw: " @ randDraw,'FireBall'); };

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

		DirToEnemy.Z = 1.100000+FRand()*0.300000;
		DirToEnemy.X += FRand()*0.200000-0.100000;
		DirToEnemy.Y += FRand()*0.200000-0.100000;
		DirToEnemy = normal(DirToEnemy);

		//DrawDebugLine(SocketLocation, SocketLocation + DirToEnemy * 5000.0, 255, 0, 0, true);
		MyHuskPawn = KFPawn_ZedHusk(MyKFPawn);

		// Shoot the fireball
		MyFireball = Spawn(FireballClass, MyKFPawn,, SocketLocation, Rotator(DirToEnemy));
		MyFireball.Instigator			= MyKFPawn;
		MyFireball.InstigatorController	= self;

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
