class WMAISpawnManager extends KFAISpawnManager;

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
var array<SGroupToSpawn> groupList;

// stuck zed variables
struct SStuckZed
{
	var KFPawn_Monster pawn;
	var vector lastloc;
	var int countDown;
};
var array<SStuckZed> lastZedInfo;

var bool bAllowTurboSpawn;
var float GameDifficultyZedternal;

function Initialize()
{
	if (GameDifficulty > `DIFFICULTY_HELLONEARTH)
		GameDifficultyZedternal = `DIFFICULTY_ZEDTERNALCUSTOM;
	else
		GameDifficultyZedternal = GameDifficulty;

	CheckForBadZedClasses();

	RegisterSpawnVolumes();
}

function CheckForBadZedClasses()
{
	local int i, lineNumber;

	lineNumber = 0;
	for (i = 0; i < class'ZedternalReborn.Config_Zed'.default.Zed_Wave.Length; ++i)
	{
		++lineNumber;

		//Errors
		if (class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass == None)
		{
			`log("ZR Error: Failed to add wave config from Zed_Wave on line"@lineNumber@
				"because the class defined in ZedClass does not exist or is not a valid type, please check your config and verify that the class is correct.");

			class'ZedternalReborn.Config_Zed'.default.Zed_Wave.Remove(i, 1);
			--i;
			continue;
		}

		//Warnings
		if (class'ZedternalReborn.Config_ZedValue'.default.Zed_Value.Find('ZedClass', class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass) == INDEX_NONE)
		{
			`log("ZR Warning: Zed class"@string(class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass)@
				"does not have a value defined under Zed_Value in the config, defaulting to the class's default dosh value.");
		}

		if (class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass.default.MinSpawnSquadSizeType == EST_Boss || class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass.static.IsABoss())
		{
			`log("ZR Warning: Zed class"@string(class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass)@
				"is defined as a boss, it could potentially break ZedternalReborn spawning or something else.");
		}
	}
}

function SetupNextWave(byte NextWaveIndex, int TimeToNextWaveBuffer = 0)
{
	local KFGameReplicationInfo KFGRI;
	local WMGameReplicationInfo WMGRI;
	local KFPlayerController KFPC;
	local array< class<WMSpecialWave> > WMSW;
	local array<SMonster> MToA;
	local byte NbPlayer;
	local int waveValue, number, noLargeZedCountDown, maxNumberOfZed, i, k, choice;
	local float tempWaveValue, customSpawnRate;
	local bool bNewSquad, bVariantZeds, bVariantApplied;
	local array<SZedVariant> trimedZedVariantList;
	local array<float> variantProbabilitiesList;
	local array<int> variantClassesList;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	bAllowTurboSpawn = class'ZedternalReborn.Config_WaveOptions'.static.GetAllowFastSpawning(GameDifficultyZedternal);

	lastZedInfo.length = 0; // Clear the lastZedInfo array just in case

	`log("Generating ZED list for wave " $ NextWaveIndex $ "...");

	/////////////////////////////////////////////////////////////////////
	// Create the list of all zeds that will spawn in the current wave //
	/////////////////////////////////////////////////////////////////////

	NbPlayer = 0;
	MToA.length = 0;

	// Number of players:
	foreach DynamicActors(class'KFPlayerController', KFPC)
	{
		if (KFPC.GetTeamNum() != 255)
			++NbPlayer;
	}
	if (NbPlayer == 0)
		NbPlayer = 1;

	//First, to randomize waves, we use a certain number of different MonsterToSpawn
	//Lets select only monsters that can spawn in the current wave:

	if (WMGRI.SpecialWaveID[0] != INDEX_NONE)
	{
		WMSW.length = 0;
		for (k = 0; k <= 1; ++k)
		{
			if (WMGRI.SpecialWaveID[k] != INDEX_NONE)
				WMSW.AddItem(WMGRI.specialWaves[WMGRI.SpecialWaveID[k]]);
		}

		if (WMSW[0].default.bReplaceMonstertoAdd || (WMSW.length > 1 && WMSW[1].default.bReplaceMonstertoAdd))
		{
			for (k = 0; k < WMSW.length; ++k)
			{
				for (i = 0; i < WMSW[k].default.MonsterToAdd.Length; ++i)
				{
					if (NextWaveIndex >= WMSW[k].default.MonsterToAdd[i].MinWave && NextWaveIndex <= WMSW[k].default.MonsterToAdd[i].MaxWave)
					{
						MToA.AddItem(default.SMonster_Temp);
						MToA[MToA.length - 1].MinWave = WMSW[k].default.MonsterToAdd[i].MinWave;
						MToA[MToA.length - 1].MaxWave = WMSW[k].default.MonsterToAdd[i].MaxWave;
						MToA[MToA.length - 1].MinGr = WMSW[k].default.MonsterToAdd[i].MinGr;
						MToA[MToA.length - 1].MaxGr = WMSW[k].default.MonsterToAdd[i].MaxGr;
						MToA[MToA.length - 1].Value = class'ZedternalReborn.Config_ZedValue'.static.GetZedValue(WMSW[k].default.MonsterToAdd[i].MClass, NbPlayer);
						MToA[MToA.length - 1].MClass = WMSW[k].default.MonsterToAdd[i].MClass;
					}
				}
			}
		}
		else
		{
			for (i = 0; i < class'ZedternalReborn.Config_Zed'.default.Zed_Wave.Length; ++i)
			{
				if (NextWaveIndex >= class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MinWave && NextWaveIndex <= class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MaxWave)
				{
					MToA.AddItem(default.SMonster_Temp);
					MToA[MToA.length - 1].MinWave = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MinWave;
					MToA[MToA.length - 1].MaxWave = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MaxWave;
					MToA[MToA.length - 1].MinGr = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MinGr;
					MToA[MToA.length - 1].MaxGr = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MaxGr;
					MToA[MToA.length - 1].Value = class'ZedternalReborn.Config_ZedValue'.static.GetZedValue(class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass, NbPlayer);
					MToA[MToA.length - 1].MClass = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass;
				}
			}
			// Remove exceeded elements
			while (MToA.Length > class'ZedternalReborn.Config_WaveOptions'.static.GetMaxUniqueZedsInWave(GameDifficultyZedternal) && MToA.Length > 1)
			{
				choice = Rand(MToA.Length);
				MToA.Remove(choice, 1);
			}
			for (k = 0; k < WMSW.length; ++k)
			{
				for (i = 0; i < WMSW[k].default.MonsterToAdd.Length; ++i)
				{
					if (NextWaveIndex >= WMSW[k].default.MonsterToAdd[i].MinWave && NextWaveIndex <= WMSW[k].default.MonsterToAdd[i].MaxWave)
					{
						MToA.AddItem(default.SMonster_Temp);
						MToA[MToA.length - 1].MinWave = WMSW[k].default.MonsterToAdd[i].MinWave;
						MToA[MToA.length - 1].MaxWave = WMSW[k].default.MonsterToAdd[i].MaxWave;
						MToA[MToA.length - 1].MinGr = WMSW[k].default.MonsterToAdd[i].MinGr;
						MToA[MToA.length - 1].MaxGr = WMSW[k].default.MonsterToAdd[i].MaxGr;
						MToA[MToA.length - 1].Value = class'ZedternalReborn.Config_ZedValue'.static.GetZedValue(WMSW[k].default.MonsterToAdd[i].MClass, NbPlayer);
						MToA[MToA.length - 1].MClass = WMSW[k].default.MonsterToAdd[i].MClass;
					}
				}
			}
		}
	}
	else
	{
		for (i = 0; i < class'ZedternalReborn.Config_Zed'.default.Zed_Wave.Length; ++i)
		{
			if (NextWaveIndex >= class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MinWave && NextWaveIndex <= class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MaxWave)
			{
				MToA.AddItem(default.SMonster_Temp);
				MToA[MToA.length - 1].MinWave = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MinWave;
				MToA[MToA.length - 1].MaxWave = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MaxWave;
				MToA[MToA.length - 1].MinGr = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MinGr;
				MToA[MToA.length - 1].MaxGr = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].MaxGr;
				MToA[MToA.length - 1].Value = class'ZedternalReborn.Config_ZedValue'.static.GetZedValue(class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass, NbPlayer);
				MToA[MToA.length - 1].MClass = class'ZedternalReborn.Config_Zed'.default.Zed_Wave[i].ZedClass;
			}
		}
		// Remove exceeded elements
		while (MToA.Length > class'ZedternalReborn.Config_WaveOptions'.static.GetMaxUniqueZedsInWave(GameDifficultyZedternal) && MToA.Length > 1)
		{
			choice = Rand(MToA.Length);
			MToA.Remove(choice, 1);
		}
	}

	//Next, we need to calculate the value for the current wave.
	//Points are used to spawn ZEDs (where big ZEDs cost more points).
	//Value of the wave are depend on the number of players, the wave number and the difficulty

	// Number of points for this wave :
	// 1) wave points at current wave
	tempWaveValue = float(class'ZedternalReborn.Config_WaveValue'.static.GetBaseValue(GameDifficultyZedternal)) + float(class'ZedternalReborn.Config_WaveValue'.static.GetValueIncPerwave(GameDifficultyZedternal)) * float(NextWaveIndex - 1);

	// 2) wave points factor at current wave (so wave value vs wave number is not linear)
	tempWaveValue *= 1.0f + class'ZedternalReborn.Config_WaveValue'.default.Wave_ValueFactorPerWave * float(NextWaveIndex);

	// 3) wave points power at current wave (greatly increase wave value at high waves)
	tempWaveValue = tempWaveValue ** (1.0f + class'ZedternalReborn.Config_WaveValue'.default.Wave_ValuePowerPerWave * float(NextWaveIndex - 1));

	// 4) increase wave points based on number of players
	tempWaveValue *= class'ZedternalReborn.Config_WaveValue'.static.GetValueFactor(NbPlayer);

	// 5) change wave points from current specialWaves
	for (k = 0; k < WMSW.length; ++k)
	{
		tempWaveValue *= WMSW[k].default.waveValueFactor;
	}

	// 6) change wave points from custom map settings
	tempWaveValue *= class'ZedternalReborn.Config_Map'.static.GetZedNumberScale(WorldInfo.GetMapName(True));

	// 7) round result
	waveValue = int(tempWaveValue);

	//Check for integer overflow
	if (waveValue < 0)
		waveValue = MaxInt;

	`Log("Wave's Value = "$waveValue);

	// we are now ready to build the list
	// we use two arrays : One for the Zed's Class and one for the delay between each spawn
	groupList.Length = 0;
	WaveTotalAI = 0;

	// we need to compute the spawn rate
	// 1) spawn rate factor at current wave
	customSpawnRate = 1.0f / (class'ZedternalReborn.Config_WaveSpawnRate'.static.GetZedSpawnRate(GameDifficultyZedternal) + class'ZedternalReborn.Config_WaveSpawnRate'.static.GetZedSpawnRateIncPerWave(GameDifficultyZedternal) * float(NextWaveIndex - 1));

	// 2) spawn rate power to greatly increase spawn rate at late waves
	customSpawnRate = customSpawnRate ** (1.0f + class'ZedternalReborn.Config_WaveSpawnRate'.static.GetZedSpawnRatePowerPerWave(GameDifficultyZedternal) * float(NextWaveIndex - 1));

	// 3) spawn rate factor based on number of players
	customSpawnRate = customSpawnRate / class'ZedternalReborn.Config_WaveSpawnRate'.static.ZedSpawnRateFactor(NbPlayer);
	for (k = 0; k < WMSW.length; ++k)
	{
		customSpawnRate = customSpawnRate/(WMSW[k].default.zedSpawnRateFactor);
	}

	// 4) reduce spawn rate by 35% only for wave 1
	if (NextWaveIndex == 1)
		customSpawnRate *= 1.35f;

	// 5) change spawn rate from custom map settings
	customSpawnRate *= 1.0f / class'ZedternalReborn.Config_Map'.static.GetZedSpawnRate(WorldInfo.GetMapName(True));

	`log("SpawnRateFactor = "$customSpawnRate);

	// Check to see if zed variant list should be enabled
	if (class'ZedternalReborn.Config_ZedVariant'.default.Zed_ZedVariant.Length != 0)
		bVariantZeds = True;
	else
		bVariantZeds = False;

	// We know what zeds will spawn, so shorten the ZedVariant list to make it more efficient and reduce loop counts
	if (bVariantZeds)
	{
		// Use variantClassesList as a counter array to reduce the need of another variable
		variantClassesList.length = class'ZedternalReborn.Config_ZedVariant'.default.Zed_ZedVariant.Length;
		for (k = 0; k < class'ZedternalReborn.Config_ZedVariant'.default.Zed_ZedVariant.Length; ++k)
		{
			variantClassesList[k] = 0;
			for (i = 0; i < MToA.Length; ++i)
			{
				if (MToA[i].Mclass == class'ZedternalReborn.Config_ZedVariant'.default.Zed_ZedVariant[k].ZedClass)
				{
					if (class'ZedternalReborn.Config_ZedVariant'.default.Zed_ZedVariant[k].MinDiff <= GameDifficultyZedternal
						&& class'ZedternalReborn.Config_ZedVariant'.default.Zed_ZedVariant[k].MaxDiff >= GameDifficultyZedternal)
					{
						++variantClassesList[k];
					}
				}
			}
		}

		// Add elements to trimedZedVariantList
		for (k = 0; k < variantClassesList.Length; ++k)
		{
			if (variantClassesList[k] > 0)
				trimedZedVariantList.AddItem(class'ZedternalReborn.Config_ZedVariant'.default.Zed_ZedVariant[k]);
		}
	}

	// now, we can create the list of ZEDs (meaning that at the beginning of the wave, we already know which ZEDs and when they will spawn)
	bNewSquad = True;
	noLargeZedCountDown = 0; // this script will try to avoid spamming large zeds using this variable
	maxNumberOfZed = class'ZedternalReborn.Config_WaveOptions'.static.GetMaxNumberOfZedsToSpawn(GameDifficultyZedternal);
	while (waveValue > 0 && WaveTotalAI < maxNumberOfZed && MToA.Length > 0)
	{
		choice = Rand(MToA.Length);

		// check if we have enough value to spawn this monster
		// if not, we remove it from the list
		if (waveValue < (MToA[choice].Value * MToA[choice].MinGr))
			MToA.Remove(choice, 1);
		else if (noLargeZedCountDown > 0 && MToA[choice].Mclass.default.bLargeZed)
			--noLargeZedCountDown;
		else
		{
			number = Min(8, Rand(Abs(MToA[choice].MaxGr - MToA[choice].MinGr)) + MToA[choice].MinGr + Min(Abs(MToA[choice].MaxGr - MToA[choice].MinGr), 1));
			if (bNewSquad)
			{
				groupList.Insert(0, 1);
				if ((number < 6 && FRand() < 0.5f) || (number < 4 && FRand() < 0.75f))
					bNewSquad = False;
			}
			else
			{
				number = Min(number, 8 - groupList[0].MClass.length);
				bNewSquad = True;
			}

			// Check for zed variants
			if (bVariantZeds)
			{
				variantProbabilitiesList.length = 0;
				variantClassesList.length = 0;
				for (k = 0; k < trimedZedVariantList.length; ++k)
				{
					if (MToA[choice].Mclass == trimedZedVariantList[k].ZedClass)
					{
						if (trimedZedVariantList[k].MinDiff <= GameDifficultyZedternal
							&& trimedZedVariantList[k].MaxDiff >= GameDifficultyZedternal)
						{
							variantProbabilitiesList.AddItem(trimedZedVariantList[k].Probability);
							variantClassesList.AddItem(k);
						}
					}
				}
			}

			groupList[0].Delay += MToA[choice].Value * customSpawnRate * number / 10;
			for (i = 0; i < number; ++i)
			{
				if (bVariantZeds)
				{
					bVariantApplied = False;
					for (k = 0; k < variantProbabilitiesList.length; ++k)
					{
						if (variantProbabilitiesList[k] >= FRand())
						{
							groupList[0].MClass.AddItem(trimedZedVariantList[variantClassesList[k]].VariantClass);
							bVariantApplied = True;
							break;
						}
					}
				}

				if (!bVariantApplied || !bVariantZeds)
					groupList[0].MClass.AddItem(MToA[choice].Mclass);

				if (MToA[choice].Mclass.default.bLargeZed)
					noLargeZedCountDown = 1;
				else if (class<KFPawn_MonsterBoss>(MToA[choice].Mclass) != None)
					noLargeZedCountDown = 10;
			}

			WaveTotalAI += number;
			waveValue -= MToA[choice].Value * number;
		}
	}

	// Inject additional zeds into the group list
	if (class'ZedternalReborn.Config_ZedInject'.default.Zed_bEnableWaveGroupInjection)
	{
		for (i = 0; i < class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject.Length; ++i)
		{
			if (class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].WaveNum == NextWaveIndex
				&& class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].MinDiff <= GameDifficultyZedternal
				&& class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].MaxDiff >= GameDifficultyZedternal)
			{
				bNewSquad = True;
				switch (Caps(class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].Position))
				{
					case "BEG":
						k = 0;
						groupList.Insert(k, 1);
						break;
					case "MID":
						k = groupList.Length / 2;
						groupList.Insert(k, 1);
						break;
					case "END":
						k = groupList.Length;
						groupList.Add(1);
						break;
					default:
						`log("ZR Error:" @ class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].Position @ "is not a known position for a wave group injection,"
							@"only BEG, Mid, and END are valid positions. Please check your config and fix the broken Zed_WaveGroupInject lines");
						bNewSquad = False;
						break;
				}

				if (bNewSquad)
				{
					groupList[k].MClass = class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].ZedClasses;
					groupList[k].Delay = class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].ZedClasses.Length * customSpawnRate;
					WaveTotalAI += class'ZedternalReborn.Config_ZedInject'.default.Zed_WaveGroupInject[i].ZedClasses.Length;
				}
			}
		}
	}

	// Clear out any leftover spawn squads from last wave
	LeftoverSpawnSquad.Length = 0;

	WaveStartTime = WorldInfo.TimeSeconds;
	TimeUntilNextSpawn = 5.5f;

	// Reset the total waves active time on first wave
	if (NextWaveIndex == 0)
		TotalWavesActiveTime = 0;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if (KFGRI != None && (KFGRI.bDebugSpawnManager || KFGRI.bGameConductorGraphingEnabled))
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
	LastAISpawnVolume = None;

	`Log("WaveTotalAI = " $ WaveTotalAI);
}

function ESquadType GetDesiredSquadTypeForZedList(array< class<KFPawn_Monster> > NewSquad)
{
	local ESquadType LargestMonsterSquadType;

	LargestMonsterSquadType = super.GetDesiredSquadTypeForZedList(NewSquad);

	if (LargestMonsterSquadType == EST_Boss)
		return EST_Large;

	return LargestMonsterSquadType;
}

function int GetMaxMonsters()
{
	return class'ZedternalReborn.Config_WaveOptions'.static.GetMaxSpawnedZedsOnLevel(GameDifficultyZedternal);
}

function Update()
{
	local array<class<KFPawn_Monster> > SpawnList;
	local byte remainAllowedSpawn;

	if (IsWaveActive())
	{
		TotalWavesActiveTime += 1.0f;
		TimeUntilNextSpawn -= 1.0f * GetSineMod();

		if (bAllowTurboSpawn)
			remainAllowedSpawn = 8;
		else
			remainAllowedSpawn = 1;

		while (ShouldAddAI() && remainAllowedSpawn > 0)
		{
			SpawnList = GetNextSpawnList();
			NumAISpawnsQueued += SpawnSquad(SpawnList);
			--remainAllowedSpawn;
			UpdateAIRemaining();
		}
	}

	if (groupList.Length == 0 && GetAIAliveCount() <= class'ZedternalReborn.Config_Map'.static.GetZedStuckThreshold(WorldInfo.GetMapName(True)))
		CheckStuckZed();
}

/** Should we? */
function bool ShouldAddAI()
{
	local int AliveCount;

	AliveCount = GetAIAliveCount();
	if (!IsFinishedSpawning() && TotalWavesActiveTime > 3
		&& (TimeUntilNextSpawn <= 0 || AliveCount == 0)
		&& (groupList.Length > 0 || LeftoverSpawnSquad.Length > 0)
		&& AliveCount < GetMaxMonsters())
	{
		return True;
	}

	return False;
}

function CheckStuckZed()
{
	local KFPawn_Monster KFM;
	local int i;
	local bool bFound;

	// remove dead tracked zedClass
	for (i = 0; i < lastZedInfo.length; ++i)
	{
		if (lastZedInfo[i].pawn == None || lastZedInfo[i].pawn.Health <= 0)
		{
			lastZedInfo.Remove(i, 1);
			--i;
		}
	}

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		bFound = False;
		// check if we are currently tracking this monster
		for (i = 0; i < lastZedInfo.length; ++i)
		{
			if (lastZedInfo[i].pawn == KFM)
			{
				bFound = True;	// yes, we are currently tracking this monster
				--lastZedInfo[i].countDown;
				// run this section if this monster is in the world for more than X seconds (when countdown reach 0)
				if (lastZedInfo[i].countDown <= 0)
				{
					// if stuck and near full health, teleport it
					if (KFM.Health >= (KFM.HealthMax * 0.9f))
					{
						groupList.Insert(0,1);
						groupList[0].MClass.AddItem(KFM.default.class);
						groupList[0].Delay = 1.0f;
						++WaveTotalAI;
						++KFGameReplicationInfo(WorldInfo.GRI).AIRemaining;

						// kill zed
						KFM.Died(None, None, KFM.Location);
					}
				}
				else
					--lastZedInfo[i].countDown;
			}
		}

		// if new zed
		if (!bFound)
		{
			lastZedInfo.Insert(0, 1);
			lastZedInfo[0].pawn = KFM;
			lastZedInfo[0].countDown = class'ZedternalReborn.Config_Map'.static.GetZedStuckTimeout(WorldInfo.GetMapName(True)); // will be teleported after 2.5 minutes or user defined time
		}
	}
}

function bool IsFinishedSpawning()
{
	if (ActiveSpawner != None && ActiveSpawner.bIsSpawning && ActiveSpawner.PendingSpawns.Length > 0)
		return False;

	if (NumAISpawnsQueued >= WaveTotalAI)
		return True;

	if (groupList.Length == 0 && LeftoverSpawnSquad.Length == 0 && GetAIAliveCount() <= 0)
	{
		`log("WMAISpawnManager.IsFinishedSpawning() emergency breakout. NumAISpawnsQueued: " $ NumAISpawnsQueued $ " WaveTotalAI: " $ WaveTotalAI);
		return True;
	}

	return False;
}

function float GetSineMod()
{
	return 1.5f - Abs(Sin(TotalWavesActiveTime * GetSineWaveFreq())); // 0.5 to 1.5
}

/** Returns a random AIGroup from the "waiting" list */
function array< class<KFPawn_Monster> > GetNextSpawnList()
{
	local array< class<KFPawn_Monster> > NewSquad;

	if (LeftoverSpawnSquad.Length > 0)
	{
		TimeUntilNextSpawn = 0.0f;
		NewSquad = LeftoverSpawnSquad;
		LeftoverSpawnSquad.Remove(0, NewSquad.Length);
	}
	else
	{
		TimeUntilNextSpawn += groupList[0].Delay;
		NewSquad = groupList[0].MClass;
		groupList.Remove(0, 1);
	}

	// Make sure we properly initialize the DesiredSquadType for the leftover squads, otherwise they will just use whatever size data was left in the system
	SetDesiredSquadTypeForZedList(NewSquad);
	return NewSquad;
}

function float GetNextSpawnTimeMod()
{
	return 0.0f;
}

function SummonBossMinions(array<KFAISpawnSquad> NewMinionSquad, int NewMaxBossMinions, optional bool bUseLivingPlayerScale = True)
{
	//Do nothing
}

function StopSummoningBossMinions()
{
	//Do nothing
}

defaultproperties
{
	bAllowTurboSpawn=True
	GameDifficultyZedternal=0.0f
	SMonster_Temp=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher',Value=5)

	Name="Default__WMAISpawnManager"
}
