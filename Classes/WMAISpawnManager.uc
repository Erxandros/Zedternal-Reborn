class WMAISpawnManager extends KFAISpawnManager
	config(GameEndlessSpawn);
	
struct SMonster
{
	var int MinWave, MaxWave;
	var int MinGr, MaxGr;
	var int Value;
	var class<KFPawn_Monster> MClass;
};
var SMonster SMonster_Temp;


struct SGroupToSpawn
{
	var array < class<KFPawn_Monster> > MClass;
	var float Delay;
};
var array< SGroupToSpawn > groupList;

// stuck zed variables
struct SStuckZed
{
	var KFPawn_Monster pawn;
	var vector lastloc;
	var int countDown;
};
var array< SStuckZed > lastZedInfo;

var bool bAllowTurboSpawn;


function SetupNextWave(byte NextWaveIndex, int TimeToNextWaveBuffer = 0)
{
	local KFGameReplicationInfo KFGRI;
	local WMGameReplicationInfo WMGRI;
	local array< class<WMSpecialWave> > WMSW;
	local KFPlayerController KFPC;
	local array<SMonster> MToA;
	local byte i, j, k, choice, NbPlayer;
	local int waveValue, number;
	local float tempWaveValue;
	local float customSpawnRate;
	local bool bNewSquad;
	local int noLargeZedCountDown;
	local int maxNumberOfZed;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	
	bAllowTurboSpawn = class'Zedternal.Config_Game'.default.Game_bAllowFastSpawning;
	
	`log("Generating ZED list for wave " $ NextWaveIndex $ "...");
	
	/////////////////////////////////////////////////////////////////////
	// Create the list of all zeds that will spawn in the current wave //
	/////////////////////////////////////////////////////////////////////
	
	NbPlayer=0;
	MToA.length=0;
	
	// Number of players:
	foreach DynamicActors(class'KFPlayerController', KFPC)
	{
		if (KFPC.GetTeamNum() != 255)
			NbPlayer += 1;
	}
	if (NbPlayer == 0)
		NbPlayer = 1;
	
	//First, to randomize waves, we use a certain number of different MonsterToSpawn
	//Lets select only monsters that can spawn in the current wave:
	
	if (WMGRI.SpecialWaveID[0] != -1)
	{
		WMSW.length = 0;
		for(k=0;k<=1;k+=1)
		{
			if (WMGRI.SpecialWaveID[k] != -1)
				WMSW.AddItem(WMGRI.specialWaves[WMGRI.SpecialWaveID[k]]);
		}
		
		if (WMSW[0].default.bReplaceMonstertoAdd || (WMSW.length > 1 && WMSW[1].default.bReplaceMonstertoAdd))
		{
			for (k=0;k<WMSW.length;k+=1)
			{
				for (i=0;i<WMSW[k].default.MonsterToAdd.Length;i+=1)
				{
					if (NextWaveIndex>=WMSW[k].default.MonsterToAdd[i].MinWave && NextWaveIndex<=WMSW[k].default.MonsterToAdd[i].MaxWave)
					{
						MToA.AddItem(default.SMonster_Temp);
						MToA[MToA.length-1].MinWave = WMSW[k].default.MonsterToAdd[i].MinWave;
						MToA[MToA.length-1].MaxWave = WMSW[k].default.MonsterToAdd[i].MaxWave;
						MToA[MToA.length-1].MinGr = WMSW[k].default.MonsterToAdd[i].MinGr;
						MToA[MToA.length-1].MaxGr = WMSW[k].default.MonsterToAdd[i].MaxGr;
						MToA[MToA.length-1].Value = class'Zedternal.Config_Zed'.static.GetMonsterValue(WMSW[k].default.MonsterToAdd[i].MClass, NbPlayer);
						MToA[MToA.length-1].MClass = WMSW[k].default.MonsterToAdd[i].MClass;
					}
				}
			}
		}
		else
		{
			for (i=0;i<class'Zedternal.Config_Zed'.default.Zed_Monsters.Length;i+=1)
			{
				if (NextWaveIndex>=class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MinWave && NextWaveIndex<=class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MaxWave)
				{
					MToA.AddItem(default.SMonster_Temp);
					MToA[MToA.length-1].MinWave = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MinWave;
					MToA[MToA.length-1].MaxWave = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MaxWave;
					MToA[MToA.length-1].MinGr = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MinGr;
					MToA[MToA.length-1].MaxGr = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MaxGr;
					MToA[MToA.length-1].Value = class'Zedternal.Config_Zed'.static.GetMonsterValue(class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MClass, NbPlayer);
					MToA[MToA.length-1].MClass = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MClass;
				}
			}
			// Remove exceded Element
			while (MToA.Length>class'Zedternal.Config_Zed'.default.Zed_MaxDifferentMonster && MToA.Length>1)
			{
				choice = Rand(MToA.Length);
				MToA.Remove(choice,1);
			}
			for (k=0;k<WMSW.length;k+=1)
			{
				for (i=0;i<WMSW[k].default.MonsterToAdd.Length;i+=1)
				{
					if (NextWaveIndex>=WMSW[k].default.MonsterToAdd[i].MinWave && NextWaveIndex<=WMSW[k].default.MonsterToAdd[i].MaxWave)
					{
						MToA.AddItem(default.SMonster_Temp);
						MToA[MToA.length-1].MinWave = WMSW[k].default.MonsterToAdd[i].MinWave;
						MToA[MToA.length-1].MaxWave = WMSW[k].default.MonsterToAdd[i].MaxWave;
						MToA[MToA.length-1].MinGr = WMSW[k].default.MonsterToAdd[i].MinGr;
						MToA[MToA.length-1].MaxGr = WMSW[k].default.MonsterToAdd[i].MaxGr;
						MToA[MToA.length-1].Value = class'Zedternal.Config_Zed'.static.GetMonsterValue(WMSW[k].default.MonsterToAdd[i].MClass, NbPlayer);
						MToA[MToA.length-1].MClass = WMSW[k].default.MonsterToAdd[i].MClass;
					}
				}
			}
		}
	}
	else
	{
		for (i=0;i<class'Zedternal.Config_Zed'.default.Zed_Monsters.Length;i+=1)
		{
			if (NextWaveIndex>=class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MinWave && NextWaveIndex<=class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MaxWave)
			{
				MToA.AddItem(default.SMonster_Temp);
				MToA[MToA.length-1].MinWave = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MinWave;
				MToA[MToA.length-1].MaxWave = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MaxWave;
				MToA[MToA.length-1].MinGr = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MinGr;
				MToA[MToA.length-1].MaxGr = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MaxGr;
				MToA[MToA.length-1].Value = class'Zedternal.Config_Zed'.static.GetMonsterValue(class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MClass, NbPlayer);
				MToA[MToA.length-1].MClass = class'Zedternal.Config_Zed'.default.Zed_Monsters[i].MClass;
			}
		}
		// Remove exceded Element
		while (MToA.Length>class'Zedternal.Config_Zed'.default.Zed_MaxDifferentMonster && MToA.Length>1)
		{
			choice = Rand(MToA.Length);
			MToA.Remove(choice,1);
		}
	}
	
	//Next, we need to calcul the value for the current wave.
	//Points are used to spawn ZEDs (where big ZEDs cost more points).
	//Value of the wave are depend on the number of players, the wave number and the difficulty
	
	// Number of points for this wave :
	// 1) wave points at current wave
	tempWaveValue = float(class'Zedternal.Config_Waves'.static.GetBaseValue(GameDifficulty)) + float(class'Zedternal.Config_Waves'.static.GetValueIncPerwave(GameDifficulty))*float(NextWaveIndex-1);
	
	// 2) wave points factor at current wave (so wave value vs wavenum is not linear)
	tempWaveValue *= 1.f + class'Zedternal.Config_Waves'.default.ZedSpawn_ValueFactorPerWave * float(NextWaveIndex);
	
	// 3) wave points power at current wave (greatly increase wave value at high waves)
	tempWaveValue = tempWaveValue ** (1.f + class'Zedternal.Config_Waves'.default.ZedSpawn_ValuePowerPerWave * float(NextWaveIndex-1));
	
	// 4) increase wave points based on number of players
		tempWaveValue *= class'Zedternal.Config_Waves'.static.GetValueFactor(NbPlayer);
	
	// 5) change wave points from current specialWaves
	for (k=0;k<WMSW.length;k+=1)
	{
		tempWaveValue *= WMSW[k].default.waveValueFactor;
	}
	
	// 6) change wave points from custom map settings
	tempWaveValue *= class'Zedternal.Config_Map'.static.GetZedNumberScale(WorldInfo.GetMapName(true));
	
	// 7) round result
	waveValue = int(tempWaveValue);
		
	`Log("Wave's Value = "$waveValue);
	
	
	
	// we are now ready to build the list
	// we use two arrays : One for the Zed's Class and one for the delay between each spawn
	groupList.Length = 0;
	WaveTotalAI = 0;
	
	// we need to compute the spawn rate
	// 1) spawn rate factor at current wave
	customSpawnRate = 1.f / (class'Zedternal.Config_Waves'.static.GetZedSpawnRate(GameDifficulty) + class'Zedternal.Config_Waves'.default.ZedSpawn_ZedSpawnRateIncPerWave * (NextWaveIndex-1));
	
	// 2) spawn rate power to greatly increase spawn rate at late waves
	customSpawnRate = customSpawnRate ** (1.f + class'Zedternal.Config_Waves'.default.ZedSpawn_ZedSpawnRatePowerPerWave * float(NextWaveIndex-1));
	
	// 3) spawn rate factor based on number of players
	customSpawnRate = customSpawnRate / class'Zedternal.Config_Waves'.static.ZedSpawnRateFactor(NbPlayer);
	for (k=0;k<WMSW.length;k+=1)
	{
		customSpawnRate = customSpawnRate/(WMSW[k].default.zedSpawnRateFactor);
	}
	
	// 4) reduce spawn rate by 35% only for wave 1
	if (NextWaveIndex == 1)
		customSpawnRate *= 1.350000;
	
	// 5) change spawnrate from custom map settings
	customSpawnRate *= 1.f / class'Zedternal.Config_Map'.static.GetZedSpawnRate(WorldInfo.GetMapName(true));
	
	`log("SpawnRateFactor = "$customSpawnRate);
	
	// now, we can create the list of ZEDs (meaning that at the begining of the wave, we already know which ZEDs and when they will spawn)
	bNewSquad = true;
	noLargeZedCountDown = 0;	// this script will try to avoid spamming large zed using this variable
	maxNumberOfZed = class'Zedternal.Config_Waves'.default.ZedSpawn_MaxNumberOfMonster;
	while (waveValue>0 && WaveTotalAI<maxNumberOfZed && MToA.Length>0)
	{
		choice = Rand(MToA.Length);
		
		// check if we have enough value to spawn this monster
		// if not, we remove it from the list
		if (waveValue<(MToA[choice].Value*MToA[choice].MinGr))
			MToA.Remove(choice,1);
		else if (noLargeZedCountDown > 0 && MToA[choice].Mclass.default.bLargeZed)
		{
			noLargeZedCountDown -= 1;
		}
		else
		{
			number = Min(8, Rand(Abs(MToA[choice].MaxGr-MToA[choice].MinGr))+MToA[choice].MinGr+Min(Abs(MToA[choice].MaxGr-MToA[choice].MinGr),1));
			if (bNewSquad)
			{
				groupList.Insert(0,1);
				if ((number < 6 && FRand() < 0.5) || (number < 4 && FRand() < 0.75))
					bNewSquad = false;
			}
			else
			{
				number = Min(number, 8 - groupList[0].MClass.length);
				bNewSquad = true;
			}
			
			groupList[0].Delay += MToA[choice].Value*customSpawnRate*number/10;
			for (i=0;i<number;i+=1)
			{
				groupList[0].MClass.AddItem(MToA[choice].Mclass);
				if (MToA[choice].Mclass.default.bLargeZed)
					noLargeZedCountDown = 1;
				else if(class<KFPawn_MonsterBoss>(MToA[choice].Mclass) != none)
					noLargeZedCountDown = 10;
			}
			
			WaveTotalAI += number;
			waveValue -= MToA[choice].Value*number;
		}
		
	}
	
	// List almost done. We still need to scan each zed from the list to add variant zeds.
	if (class'Zedternal.Config_Zed'.default.Zed_ZedVariant.length != 0)
	{
		for (i=0;i<groupList.length;i++)
		{
			for (j=0;j<groupList[i].MClass.length;j++)
			{
				for (k=0;k<class'Zedternal.Config_Zed'.default.Zed_ZedVariant.length;k++)
				{
					if (groupList[i].MClass[j] == class'Zedternal.Config_Zed'.default.Zed_ZedVariant[k].zedClass
						&& class'Zedternal.Config_Zed'.default.Zed_ZedVariant[k].minDifficulty <= GameDifficulty
						&& class'Zedternal.Config_Zed'.default.Zed_ZedVariant[k].maxDifficulty >= GameDifficulty
						&& class'Zedternal.Config_Zed'.default.Zed_ZedVariant[k].Probability >= FRand())
					{
						groupList[i].MClass[j] = class'Zedternal.Config_Zed'.default.Zed_ZedVariant[k].variantClass;
						k = class'Zedternal.Config_Zed'.default.Zed_ZedVariant.length;
					}
				}
			}
		}
	}
	
	// Clear out any leftover spawn squads from last wave
    LeftoverSpawnSquad.Length = 0;
	
	WaveStartTime = WorldInfo.TimeSeconds;
	TimeUntilNextSpawn = 5.500000;

    // Reset the total waves active time on first wave
	if( NextWaveIndex == 0 )
		TotalWavesActiveTime = 0;

    KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
    if( KFGRI != none && (KFGRI.bDebugSpawnManager || KFGRI.bGameConductorGraphingEnabled) )
    {
    	KFGRI.CurrentSineMod = GetSineMod();
    	KFGRI.CurrentNextSpawnTime = TimeUntilNextSpawn;
    	KFGRI.CurrentSineWavFreq = GetSineWaveFreq();
    	KFGRI.CurrentNextSpawnTimeMod = GetNextSpawnTimeMod();
    	KFGRI.CurrentTotalWavesActiveTime = TotalWavesActiveTime;
    	KFGRI.CurrentMaxMonsters = GetMaxMonsters();
    	KFGRI.CurrentTimeTilNextSpawn = TimeUntilNextSpawn;
    }

	KFGRI.AIRemaining = WaveTotalAI;
    LastAISpawnVolume = none;

	if (bLogAISpawning || bLogWaveSpawnTiming) LogInternal("KFAISpawnManager.SetupNextWave() NextWave:" @ NextWaveIndex @ "WaveTotalAI:" @ WaveTotalAI);
}

function int GetMaxMonsters()
{
    return class'Zedternal.Config_Waves'.default.ZedSpawn_MaxSpawnedMonster;
}

function Update()
{
	local array<class<KFPawn_Monster> > SpawnList;
	local int remainAllowedSpawn;
	
	if( IsWaveActive() )
	{
   		TotalWavesActiveTime += 1.f;
		TimeUntilNextSpawn -= 1.f * GetSineMod();

		if (bAllowTurboSpawn)
			remainAllowedSpawn = 8;
		else
			remainAllowedSpawn = 1;
		
		while (ShouldAddAI() && remainAllowedSpawn > 0)
        {
			SpawnList = GetNextSpawnList();
			NumAISpawnsQueued += SpawnSquad(SpawnList);
			remainAllowedSpawn -= 1;
        }
	}
	
	if (groupList.Length == 0 && GetAIAliveCount() <= 4)
	{
		CheckStuckZed();
	}
}

/** Should we? */
function bool ShouldAddAI()
{
	local int numb;
	
	numb = GetAIAliveCount();
	if(!IsFinishedSpawning() && TotalWavesActiveTime>3
		&& (TimeUntilNextSpawn<=0 || numb==0)
		&& (groupList.Length>0 || LeftoverSpawnSquad.Length>0)
		&& numb<GetMaxMonsters())
	{
        return true;
	}

	return false;
}

function CheckStuckZed()
{
	local KFPawn_Monster KFM;
	local int i;
	local bool bFound;
	
	// remove dead tracked zedClass
	for (i=0; i<lastZedInfo.length; i+=1)
	{
		if (lastZedInfo[i].pawn == none || lastZedInfo[i].pawn.Health <= 0)
		{
			lastZedInfo.Remove(i, 1);
			i -= 1;
		}
	}
	
	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		bFound = false;
		// check if we are currently tracking this monster
		for (i=0; i<lastZedInfo.length; i+=1)
		{
			if (lastZedInfo[i].pawn == KFM)
			{
				bFound = true;	// yes, we are currently tracking this monster
				lastZedInfo[i].countDown -= 1;
				// run this section if this monster is in the world for more than X seconds (when countdown reach 0)
				if (lastZedInfo[i].countDown == 0)
				{
					// if stuck and full health, teleport it
					if (KFM.Health >= (KFM.HealthMax-4))
					{
						groupList.Insert(0,1);
						groupList[0].MClass.AddItem(KFM.default.class);
						groupList[0].Delay = 1.f;
						WaveTotalAI += 1;
						KFGameReplicationInfo(WorldInfo.GRI).AIRemaining += 1;
						
						// kill zed
						KFM.Died(none , none, KFM.Location);
					}
				}
				else
					lastZedInfo[i].countDown -= 1;
			}
		}
		
		// if new zed
		if (!bFound)
		{
			lastZedInfo.Insert(0,1);
			lastZedInfo[0].pawn = KFM;
			lastZedInfo[0].countDown = 120; // will be teleported after 2 minutes
		}
	}
}

/*function KFSpawnVolume GetBestSpawnVolume( optional array< class<KFPawn_Monster> > AIToSpawn, optional Controller OverrideController, optional Controller OtherController, optional bool bTeleporting, optional float MinDistSquared )
{
	local int VolumeIndex, ControllerIndex;
	local Controller RateController;
	local array< int > ValidSpawnVolumeIndex;

    if( OverrideController != none )
    {
        RateController = OverrideController;
    }
    else
    {
        // Get the Controller list ready for spawn selection
        InitControllerList();

        if( RecentSpawnSelectedHumanControllerList.Length > 0 )
        {
            // Randomly grab a Human PRI from the list to use for rating zed spawning
            ControllerIndex = Rand(RecentSpawnSelectedHumanControllerList.Length);
            RateController = RecentSpawnSelectedHumanControllerList[ControllerIndex];
            RecentSpawnSelectedHumanControllerList.Remove( ControllerIndex, 1 );
            if (bLogAISpawning) LogInternal(GetFuncName()$" Rating with Controller "$RateController.PlayerReplicationInfo.PlayerName$" From RecentSpawnSelectedHumanControllerList");
        }
    }

    // If there were no controllers to rate against, return none
    if( RateController == none )
    {
		if (bLogAISpawning) WarnInternal(GetFuncName()$" no controllers to rate spawning with!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        return none;
    }

    if( (OtherController == none || !OtherController.bIsPlayer) && NeedPlayerSpawnVolume() )
    {
    	// Grab the first player controller
    	foreach WorldInfo.AllControllers( class'Controller', OtherController )
    	{
    		if( OtherController.bIsPlayer )
    		{
		    	break;
		    }
	    }
    }

    // pre-sort the list to reduce the number of line checks performed by IsValidForSpawn
	SortSpawnVolumes(RateController, bTeleporting, MinDistSquared);
	
	for ( VolumeIndex = 0; VolumeIndex < SpawnVolumes.Length; VolumeIndex++ )
	{
		if (SpawnVolumes[VolumeIndex].CurrentRating > 0)
		{
			if (SpawnVolumes[VolumeIndex].IsValidForSpawn(DesiredSquadType, OtherController))
			{
				if (bLogAISpawning) LogInternal(GetFuncName()@"returning chosen spawn volume"@SpawnVolumes[VolumeIndex]@"with a rating of"@SpawnVolumes[VolumeIndex].CurrentRating);
					return SpawnVolumes[VolumeIndex];
			}
			//else if (!SpawnVolumes[VolumeIndex].PlayerCanSeeMe())
			else if (!IsPlayerNear(SpawnVolumes[VolumeIndex]))
				ValidSpawnVolumeIndex.AddItem(VolumeIndex);
		}
	}

   if (ValidSpawnVolumeIndex.length > 0)
		return SpawnVolumes[ValidSpawnVolumeIndex[Rand(ValidSpawnVolumeIndex.length)]];
	else
		return none;
}


function bool IsPlayerNear(Actor spawnPoint)
{
	local KFPawn_Human P;
	
	foreach DynamicActors(class'KFPawn_Human', P)
	{
		if (P.IsAliveAndWell() && VSizeSQ(P.Location - spawnPoint.Location) <= 360000)
			return true;
	}
	
	return false;
}*/

function bool IsFinishedSpawning()
{
    if( ActiveSpawner != none && ActiveSpawner.bIsSpawning && ActiveSpawner.PendingSpawns.Length > 0 )
    {
        if (bLogAISpawning) LogInternal("KFAISpawnManager.IsFinishedSpawning() ActiveSpawner Still Spawning " @ string(ActiveSpawner != none && ActiveSpawner.bIsSpawning && ActiveSpawner.PendingSpawns.Length > 0));
        return false;
    }

    // Keep spawning the boss minions until we tell it to stop!
    //if( bSummoningBossMinions )
    //{
    //    return false;
    //}

	if( NumAISpawnsQueued >= WaveTotalAI )
	{
		if (bLogAISpawning) LogInternal("KFAISpawnManager.IsFinishedSpawning()" @ string(NumAISpawnsQueued >= WaveTotalAI));
		return true;
	}

	return false;
}


function float GetSineMod()
{
	return 1.5 - Abs(sin( TotalWavesActiveTime * GetSineWaveFreq() )); // 0.5 to 1.5
}

/** Returns a random AIGroup from the "waiting" list */
function array< class<KFPawn_Monster> > GetNextSpawnList()
{
	local array< class<KFPawn_Monster> >  NewSquad;


    if( LeftoverSpawnSquad.Length > 0)
    {
		TimeUntilNextSpawn = 0.f;
		NewSquad = LeftoverSpawnSquad;
		LeftoverSpawnSquad.Length=0;
	}
    else
    {
		TimeUntilNextSpawn += groupList[0].Delay;
		NewSquad = groupList[0].MClass;
		groupList.Remove(0,1);
    }
	
	// Make sure we properly initialize the DesiredSquadType for the leftover squads, otherwise they will just use whatever size data was left in the system
    SetDesiredSquadTypeForZedList( NewSquad );
	return NewSquad;
}


function UseDefaultMonster()
{
}

defaultproperties
{
   SMonster_Temp=(MinWave=0,MaxWave=99,MinGr=1,MaxGr=2,MClass=class'KFGameContent.KFPawn_ZedClot_Alpha',Value=5)
   SoloWaveSpawnRateModifier(0)=(RateModifier=(0.200000,0.200000,0.200000,0.200000))
   SoloWaveSpawnRateModifier(1)=(RateModifier=(0.200000,0.200000,0.200000,0.200000))
   SoloWaveSpawnRateModifier(2)=(RateModifier=(0.200000,0.200000,0.200000,0.200000))
   SoloWaveSpawnRateModifier(3)=(RateModifier=(0.200000,0.200000,0.200000,0.200000))
   EarlyWaveSpawnRateModifier(0)=0.200000
   EarlyWaveSpawnRateModifier(1)=0.200000
   EarlyWaveSpawnRateModifier(2)=0.200000
   EarlyWaveSpawnRateModifier(3)=0.200000
   EarlyWavesSpawnTimeModByPlayers(0)=0.200000
   EarlyWavesSpawnTimeModByPlayers(1)=0.200000
   EarlyWavesSpawnTimeModByPlayers(2)=0.200000
   EarlyWavesSpawnTimeModByPlayers(3)=0.200000
   EarlyWavesSpawnTimeModByPlayers(4)=0.200000
   EarlyWavesSpawnTimeModByPlayers(5)=0.200000
   LateWavesSpawnTimeModByPlayers(0)=0.200000
   LateWavesSpawnTimeModByPlayers(1)=0.200000
   LateWavesSpawnTimeModByPlayers(2)=0.200000
   LateWavesSpawnTimeModByPlayers(3)=0.200000
   LateWavesSpawnTimeModByPlayers(4)=0.200000
   LateWavesSpawnTimeModByPlayers(5)=0.200000
   RecycleSpecialSquad(0)=False
   RecycleSpecialSquad(1)=False
   RecycleSpecialSquad(2)=True
   RecycleSpecialSquad(3)=True
   MaxSpecialSquadRecycles=-1
   MaxBossMinionScaleByPlayers(0)=1.000000
   MaxBossMinionScaleByPlayers(1)=1.500000
   MaxBossMinionScaleByPlayers(2)=1.500000
   MaxBossMinionScaleByPlayers(3)=1.875000
   MaxBossMinionScaleByPlayers(4)=1.875000
   MaxBossMinionScaleByPlayers(5)=2.000000
   ForcedBossNum=-1
   DifficultyWaveSettings(0)=(Waves=(KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard'))
   DifficultyWaveSettings(1)=(Waves=(KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard'))
   DifficultyWaveSettings(2)=(Waves=(KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard'))
   DifficultyWaveSettings(3)=(Waves=(KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard',KFAIWaveInfo'GP_Spawning_ARCH.Long.Hard.ZED_Wave1_Long_Hard'))
   EarlyWaveIndex=1
   bAllowTurboSpawn=true
   Name="Default__WMAISpawnManager"
}
