class WMAISpawnManager extends KFAISpawnManager;

var WMAISpawnManager_ConfigData ConfigData;

var array< class<KFPawn_Monster> > ZedList;

struct S_Zed_Wave
{
	var int ZedID;
	var byte MinWave, MaxWave;
	var byte MinGr, MaxGr;
};
var array<S_Zed_Wave> WaveList;

struct S_Zed_Value
{
	var int Value;
	var int ValuePerExtraPlayer;
};
var array<S_Zed_Value> ValueList;

struct S_Zed_Inject
{
	var int ZedID;
	var byte Wave;
	var byte Position;
	var byte Count;
	var float Probability;
	var byte MinDiff, MaxDiff;
};
var array<S_Zed_Inject> InjectList;

struct S_Zed_Variant
{
	var int ZedID, VariantID;
	var float Probability;
	var byte MinDiff, MaxDiff;
};
var array<S_Zed_Variant> VariantList;

struct S_Spawn_Group
{
	var array < class<KFPawn_Monster> > ZedClasses;
	var float Delay;
};
var array<S_Spawn_Group> GroupList;

struct S_Stuck_Zed
{
	var KFPawn_Monster Zed;
	var vector LastLoc;
	var int CountDown;
};
var array<S_Stuck_Zed> LastZedInfo;

struct S_Wave_Temp
{
	var class<KFPawn_Monster> ZedClass;
	var byte MinGr, MaxGr;
	var int Value;
};

var bool bAllowTurboSpawn;
var float GameDifficultyZedternal;

function Initialize()
{
	if (GameDifficulty > `DIFFICULTY_HELLONEARTH)
		GameDifficultyZedternal = `DIFFICULTY_ZEDTERNALCUSTOM;
	else
		GameDifficultyZedternal = GameDifficulty;

	RegisterSpawnVolumes();
}

function InitializeZedSpawnData()
{
	ConfigData = new class'WMAISpawnManager_ConfigData';
	ConfigData.InitializeConfigData();

	InitializeZedArrays();

	bAllowTurboSpawn = class'ZedternalReborn.Config_WaveOptions'.static.GetAllowFastSpawning(GameDifficultyZedternal);

	// Reset the total waves active time when starting a new match
	TotalWavesActiveTime = 0;
}

function InitializeZedArrays()
{
	local int i, x;

	//Zed Waves
	for (i = 0; i < ConfigData.ZedWaveObjects.Length; ++i)
	{
		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedList, PathName(ConfigData.ZedWaveObjects[i]), x))
			ZedList.InsertItem(x, ConfigData.ZedWaveObjects[i]);
	}

	//Zed Injects
	for (i = 0; i < ConfigData.ZedInjectObjects.Length; ++i)
	{
		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedList, PathName(ConfigData.ZedInjectObjects[i]), x))
			ZedList.InsertItem(x, ConfigData.ZedInjectObjects[i]);
	}

	//Zed Values
	for (i = 0; i < ConfigData.ZedValueObjects.Length; ++i)
	{
		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedList, PathName(ConfigData.ZedValueObjects[i]), x))
			ZedList.InsertItem(x, ConfigData.ZedValueObjects[i]);
	}

	//Zed Variants
	for (i = 0; i < ConfigData.ZedVariantObjects.Length; ++i)
	{
		if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(ZedList, PathName(ConfigData.ZedVariantObjects[i]), x))
			ZedList.InsertItem(x, ConfigData.ZedVariantObjects[i]);
	}

	//Make Zed Wave array
	for (i = 0; i < ConfigData.ValidZedWaves.Length; ++i)
	{
		if (ConfigData.ValidZedWaves[i].MinWave < 256 && ConfigData.ValidZedWaves[i].MaxGr > 0)
		{
			WaveList.Add(1);

			WaveList[WaveList.Length - 1].ZedID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ZedList, ConfigData.ValidZedWaves[i].ZedPath);
			WaveList[WaveList.Length - 1].MinWave = ConfigData.ValidZedWaves[i].MinWave;
			WaveList[WaveList.Length - 1].MaxWave = Min(ConfigData.ValidZedWaves[i].MaxWave, 255);
			WaveList[WaveList.Length - 1].MinGr = ConfigData.ValidZedWaves[i].MinGr;
			WaveList[WaveList.Length - 1].MaxGr = ConfigData.ValidZedWaves[i].MaxGr;
		}
	}

	//Make Zed Inject array
	for (i = 0; i < ConfigData.ValidZedInjects.Length; ++i)
	{
		if (ConfigData.ValidZedInjects[i].Wave < 256 && ConfigData.ValidZedInjects[i].Count > 0 && ConfigData.ValidZedInjects[i].Probability > 0.0f)
		{
			InjectList.Add(1);

			InjectList[InjectList.Length - 1].ZedID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ZedList, ConfigData.ValidZedInjects[i].ZedPath);
			InjectList[InjectList.Length - 1].Wave = ConfigData.ValidZedInjects[i].Wave;
			if (ConfigData.ValidZedInjects[i].Position ~= "BEG")
				InjectList[InjectList.Length - 1].Position = 0;
			else if (ConfigData.ValidZedInjects[i].Position ~= "MID")
				InjectList[InjectList.Length - 1].Position = 1;
			else //END
				InjectList[InjectList.Length - 1].Position = 2;
			InjectList[InjectList.Length - 1].Count = ConfigData.ValidZedInjects[i].Count;
			InjectList[InjectList.Length - 1].Probability = ConfigData.ValidZedInjects[i].Probability;
			InjectList[InjectList.Length - 1].MinDiff = ConfigData.ValidZedInjects[i].MinDiff;
			InjectList[InjectList.Length - 1].MaxDiff = ConfigData.ValidZedInjects[i].MaxDiff;
		}
	}

	//Make Zed Value array
	for (i = 0; i < ZedList.Length; ++i)
	{
		ValueList.Add(1);

		x = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ConfigData.ZedValueObjects, PathName(ZedList[i]));
		if (x != INDEX_NONE)
		{
			ValueList[ValueList.Length - 1].Value = ConfigData.ValidZedValues[x].Value;
			ValueList[ValueList.Length - 1].ValuePerExtraPlayer = ConfigData.ValidZedValues[x].ValuePerExtraPlayer;
		}
		else
		{
			ValueList[ValueList.Length - 1].Value = ZedList[i].static.GetDoshValue();
			ValueList[ValueList.Length - 1].ValuePerExtraPlayer = 0;
		}
	}

	//Make Zed Variant array
	for (i = 0; i < ConfigData.ValidZedVariants.Length; ++i)
	{
		if (ConfigData.ValidZedVariants[i].Probability > 0.0f)
		{
			VariantList.Add(1);

			VariantList[VariantList.Length - 1].ZedID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ZedList, ConfigData.ValidZedVariants[i].ZedPath);
			VariantList[VariantList.Length - 1].ZedID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ZedList, ConfigData.ValidZedVariants[i].VariantPath);
			VariantList[VariantList.Length - 1].Probability = ConfigData.ValidZedVariants[i].Probability;
			VariantList[VariantList.Length - 1].MinDiff = ConfigData.ValidZedVariants[i].MinDiff;
			VariantList[VariantList.Length - 1].MaxDiff = ConfigData.ValidZedVariants[i].MaxDiff;
		}
	}
}

function int GetZedValue(const class<KFPawn_Monster> KFPM, int NbPlayer)
{
	local int i;

	i = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ZedList, PathName(KFPM));
	if (i != INDEX_NONE)
		return ValueList[i].Value + ValueList[i].ValuePerExtraPlayer * (Max(1, NbPlayer) - 1);
	else
		return KFPM.static.GetDoshValue();
}

function SetupNextWave(byte NextWaveIndex, int TimeToNextWaveBuffer = 0)
{
	local bool bNewSquad, bVariantApplied;
	local byte GrSize, NbPlayer, NoLargeZedCountDown;
	local int i, k, Choice, MaxNumberOfZeds, WaveValue;
	local float TempWaveValue, CustomSpawnRate;
	local int SWID[2];
	local array<S_Wave_Temp> WaveSpawns;
	local array<int> TempVarList, TrimmedVariantList, ZedWaveIDList;
	local WMGameReplicationInfo WMGRI;
	local KFPlayerController KFPC;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	LastZedInfo.Length = 0; // Clear the LastZedInfo array just in case

	`log("Generating ZED list for wave " $ NextWaveIndex $ "...");

	/////////////////////////////////////////////////////////////////////
	// Create the list of all zeds that will spawn in the current wave //
	/////////////////////////////////////////////////////////////////////

	NbPlayer = 0;

	// Number of players:
	foreach DynamicActors(class'KFPlayerController', KFPC)
	{
		if (KFPC.GetTeamNum() != 255)
			++NbPlayer;
	}
	if (NbPlayer == 0)
		NbPlayer = 1;

	//First, to randomize waves, we use a certain number of different wave configs
	//Lets select only zeds that can spawn in the current wave:

	for (i = 0; i < WaveList.Length; ++i)
	{
		if (NextWaveIndex >= WaveList[i].MinWave && NextWaveIndex <= WaveList[i].MaxWave)
			ZedWaveIDList.AddItem(i);
	}

	//Remove exceeded elements
	while (ZedWaveIDList.Length > class'ZedternalReborn.Config_WaveOptions'.static.GetMaxUniqueZedsInWave(GameDifficultyZedternal)
		&& ZedWaveIDList.Length > 1)
	{
		Choice = Rand(ZedWaveIDList.Length);
		ZedWaveIDList.Remove(Choice, 1);
	}

	//Special wave spawns
	SWID[0] = WMGRI.SpecialWaveID[0];
	SWID[1] = WMGRI.SpecialWaveID[1];

	//Check for bReplaceMonstertoAdd
	for (i = 0; i < 2; ++i)
	{
		if (SWID[i] != INDEX_NONE && WMGRI.specialWaves[SWID[i]].default.MonsterToAdd.Length > 0
			&& WMGRI.specialWaves[SWID[i]].default.bReplaceMonstertoAdd)
			ZedWaveIDList.Length = 0;
	}

	//Start generating WaveSpawns
	for (i = 0; i < ZedWaveIDList.Length; ++i)
	{
		WaveSpawns.Add(1);
		WaveSpawns[WaveSpawns.Length - 1].ZedClass = ZedList[WaveList[ZedWaveIDList[i]].ZedID];
		WaveSpawns[WaveSpawns.Length - 1].MinGr = WaveList[ZedWaveIDList[i]].MinGr;
		WaveSpawns[WaveSpawns.Length - 1].MaxGr = WaveList[ZedWaveIDList[i]].MaxGr;
		WaveSpawns[WaveSpawns.Length - 1].Value = ValueList[WaveList[ZedWaveIDList[i]].ZedID].Value +
			ValueList[WaveList[ZedWaveIDList[i]].ZedID].ValuePerExtraPlayer * (Max(1, NbPlayer) - 1);
	}

	//Add special wave zeds if they exist
	for (i = 0; i < 2; ++i)
	{
		if (SWID[i] == INDEX_NONE || WMGRI.specialWaves[SWID[i]].default.MonsterToAdd.Length == 0)
			continue;

		for (k = 0; k < WMGRI.specialWaves[SWID[i]].default.MonsterToAdd.Length; ++k)
		{
			if (NextWaveIndex >= WMGRI.specialWaves[SWID[i]].default.MonsterToAdd[k].MinWave
				&& NextWaveIndex <= WMGRI.specialWaves[SWID[i]].default.MonsterToAdd[k].MaxWave)
			{
				WaveSpawns.Add(1);
				WaveSpawns[WaveSpawns.Length - 1].ZedClass = WMGRI.specialWaves[SWID[i]].default.MonsterToAdd[k].MClass;
				WaveSpawns[WaveSpawns.Length - 1].MinGr = WMGRI.specialWaves[SWID[i]].default.MonsterToAdd[k].MinGr;
				WaveSpawns[WaveSpawns.Length - 1].MaxGr = WMGRI.specialWaves[SWID[i]].default.MonsterToAdd[k].MaxGr;
				WaveSpawns[WaveSpawns.Length - 1].Value = GetZedValue(WaveSpawns[WaveSpawns.Length - 1].ZedClass, NbPlayer);
			}
		}
	}

	//Next, we need to calculate the value for the current wave.
	//Points are used to spawn ZEDs (where big ZEDs cost more points).
	//Value of the wave are depend on the number of players, the wave number and the difficulty

	// Number of points for this wave :
	// 1) wave points at current wave
	TempWaveValue = float(class'ZedternalReborn.Config_WaveValue'.static.GetBaseValue(GameDifficultyZedternal)) +
		float(class'ZedternalReborn.Config_WaveValue'.static.GetValueIncPerwave(GameDifficultyZedternal)) * float(NextWaveIndex - 1);

	// 2) wave points factor at current wave (so wave value vs wave number is not linear)
	TempWaveValue *= 1.0f + class'ZedternalReborn.Config_WaveValue'.static.GetValueFactorPerWave(GameDifficultyZedternal) * float(NextWaveIndex - 1);

	// 3) wave points power at current wave (greatly increase wave value at high waves)
	TempWaveValue = TempWaveValue ** (1.0f + class'ZedternalReborn.Config_WaveValue'.static.GetValuePowerPerWave(GameDifficultyZedternal) * float(NextWaveIndex - 1));

	// 4) increase wave points based on number of players
	TempWaveValue *= class'ZedternalReborn.Config_WaveValue'.static.GetValueFactor(NbPlayer);

	// 5) change wave points from current specialWaves
	for (i = 0; i < 2; ++i)
	{
		if (SWID[i] != INDEX_NONE)
			TempWaveValue *= WMGRI.specialWaves[SWID[i]].default.waveValueFactor;
	}

	// 6) change wave points from custom map settings
	TempWaveValue *= class'ZedternalReborn.Config_Map'.static.GetZedNumberScale(WorldInfo.GetMapName(True));

	// 7) round result
	WaveValue = Round(TempWaveValue);

	//Check for integer overflow
	if (WaveValue < 0)
		WaveValue = MaxInt;

	`Log("Wave's Value = "$WaveValue);

	// we are now ready to build the list
	// we use two arrays : One for the Zed's Class and one for the delay between each spawn
	GroupList.Length = 0;
	WaveTotalAI = 0;

	// we need to compute the spawn rate
	// 1) spawn rate factor at current wave
	CustomSpawnRate = 1.0f / (class'ZedternalReborn.Config_WaveSpawnRate'.static.GetZedSpawnRate(GameDifficultyZedternal) + class'ZedternalReborn.Config_WaveSpawnRate'.static.GetZedSpawnRateIncPerWave(GameDifficultyZedternal) * float(NextWaveIndex - 1));

	// 2) spawn rate power to greatly increase spawn rate at late waves
	CustomSpawnRate = CustomSpawnRate ** (1.0f + class'ZedternalReborn.Config_WaveSpawnRate'.static.GetZedSpawnRatePowerPerWave(GameDifficultyZedternal) * float(NextWaveIndex - 1));

	// 3) spawn rate factor based on number of players
	CustomSpawnRate = CustomSpawnRate / class'ZedternalReborn.Config_WaveSpawnRate'.static.ZedSpawnRateFactor(NbPlayer);
	for (i = 0; i < 2; ++i)
	{
		if (SWID[i] != INDEX_NONE)
			CustomSpawnRate = CustomSpawnRate / (WMGRI.specialWaves[SWID[i]].default.zedSpawnRateFactor);
	}

	// 4) reduce spawn rate by 35% only for wave 1
	if (NextWaveIndex == 1)
		CustomSpawnRate *= 1.35f;

	// 5) change spawn rate from custom map settings
	CustomSpawnRate *= 1.0f / class'ZedternalReborn.Config_Map'.static.GetZedSpawnRate(WorldInfo.GetMapName(True));

	`log("SpawnRateFactor = "$CustomSpawnRate);

	// We know what zeds will spawn, so shorten the ZedVariant list to make it more efficient and reduce loop counts
	for (i = 0; i < VariantList.Length; ++i)
	{
		for (k = 0; k < WaveSpawns.Length; ++k)
		{
			if (WaveSpawns[k].ZedClass == ZedList[VariantList[i].ZedID])
			{
				if (VariantList[i].MinDiff <= GameDifficultyZedternal && VariantList[i].MaxDiff >= GameDifficultyZedternal)
					TrimmedVariantList.AddItem(i);
			}
		}
	}

	// now, we can create the list of ZEDs (meaning that at the beginning of the wave, we already know which ZEDs and when they will spawn)
	bNewSquad = True;
	NoLargeZedCountDown = 0; // this script will try to avoid spamming large zeds using this variable
	MaxNumberOfZeds = class'ZedternalReborn.Config_WaveOptions'.static.GetMaxNumberOfZedsToSpawn(GameDifficultyZedternal);
	while (WaveValue > 0 && WaveTotalAI < MaxNumberOfZeds && WaveSpawns.Length > 0)
	{
		Choice = Rand(WaveSpawns.Length);

		// check if we have enough value to spawn this monster
		// if not, we remove it from the list
		if (WaveValue < (WaveSpawns[Choice].Value * Max(1, WaveSpawns[Choice].MinGr)))
			WaveSpawns.Remove(Choice, 1);
		else if (NoLargeZedCountDown > 0 && (WaveSpawns[Choice].ZedClass.default.bLargeZed || class<KFPawn_MonsterBoss>(WaveSpawns[Choice].ZedClass) != None))
			--NoLargeZedCountDown;
		else
		{
			GrSize = Min(8, WaveSpawns[Choice].MinGr + Rand(Abs(WaveSpawns[Choice].MaxGr - WaveSpawns[Choice].MinGr)));
			if (GrSize == 0)
				continue;

			if (bNewSquad)
			{
				GroupList.Add(1);
				if ((GrSize < 6 && FRand() < 0.5f) || (GrSize < 4 && FRand() < 0.75f))
					bNewSquad = False;
			}
			else
			{
				GrSize = Min(GrSize, 8 - GroupList[GroupList.Length - 1].ZedClasses.Length);
				bNewSquad = True;
			}

			GroupList[GroupList.Length - 1].Delay += WaveSpawns[Choice].Value * CustomSpawnRate * GrSize / 10;

			// Check for zed variants
			TempVarList.Length = 0;
			for (i = 0; i < TrimmedVariantList.Length; ++i)
			{
				if (WaveSpawns[Choice].ZedClass == ZedList[VariantList[TrimmedVariantList[i]].ZedID])
				{
					TempVarList.AddItem(TrimmedVariantList[i]);
				}
			}

			for (i = 0; i < GrSize; ++i)
			{
				bVariantApplied = False;
				for (k = 0; k < TempVarList.Length; ++k)
				{
					if (VariantList[TempVarList[k]].Probability >= FRand())
					{
						GroupList[GroupList.Length - 1].ZedClasses.AddItem(ZedList[VariantList[TempVarList[k]].VariantID]);
						bVariantApplied = True;
						break;
					}
				}

				if (!bVariantApplied)
					GroupList[GroupList.Length - 1].ZedClasses.AddItem(WaveSpawns[Choice].ZedClass);

				if (WaveSpawns[Choice].ZedClass.default.bLargeZed || class<KFPawn_MonsterBoss>(WaveSpawns[Choice].ZedClass) != None)
					NoLargeZedCountDown = 1;
			}

			WaveTotalAI += GrSize;
			WaveValue -= WaveSpawns[Choice].Value * GrSize;
		}
	}

	// Inject additional zeds into the group list
	if (class'ZedternalReborn.Config_ZedInject'.default.Zed_bEnableWaveGroupInjection)
	{
		for (i = 0; i < InjectList.Length; ++i)
		{
			if (InjectList[i].Wave == NextWaveIndex && InjectList[i].Probability >= FRand()
				&& InjectList[i].MinDiff <= GameDifficultyZedternal && InjectList[i].MaxDiff >= GameDifficultyZedternal)
			{
				switch (InjectList[i].Position)
				{
					case 0:
						k = 0;
						GroupList.Insert(k, 1);
						break;
					case 1:
						k = GroupList.Length / 2;
						GroupList.Insert(k, 1);
						break;
					default:
						k = GroupList.Length;
						GroupList.Add(1);
						break;
				}

				for (GrSize = 0; GrSize < InjectList[i].Count; ++GrSize)
				{
					GroupList[k].ZedClasses.AddItem(ZedList[InjectList[i].ZedID]);
				}
				GroupList[k].Delay = InjectList[i].Count * CustomSpawnRate;
				WaveTotalAI += InjectList[i].Count;
			}
		}
	}

	// Clear out any leftover spawn squads from last wave
	LeftoverSpawnSquad.Length = 0;

	WaveStartTime = WorldInfo.TimeSeconds;
	TimeUntilNextSpawn = 5.5f;

	if (WMGRI != None && (WMGRI.bDebugSpawnManager || WMGRI.bGameConductorGraphingEnabled))
	{
		WMGRI.CurrentSineMod = GetSineMod();
		WMGRI.CurrentNextSpawnTime = TimeUntilNextSpawn;
		WMGRI.CurrentSineWavFreq = GetSineWaveFreq();
		WMGRI.CurrentNextSpawnTimeMod = GetNextSpawnTimeMod();
		WMGRI.CurrentTotalWavesActiveTime = TotalWavesActiveTime;
		WMGRI.CurrentMaxMonsters = GetMaxMonsters();
		WMGRI.CurrentTimeTilNextSpawn = TimeUntilNextSpawn;
	}

	WMGRI.AIRemaining = WaveTotalAI;
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

	if (GroupList.Length == 0 && GetAIAliveCount() <= class'ZedternalReborn.Config_Map'.static.GetZedStuckThreshold(WorldInfo.GetMapName(True)))
		CheckStuckZed();
}

/** Should we? */
function bool ShouldAddAI()
{
	local int AliveCount;

	AliveCount = GetAIAliveCount();
	if (!IsFinishedSpawning() && TotalWavesActiveTime > 3
		&& (TimeUntilNextSpawn <= 0 || AliveCount == 0)
		&& (GroupList.Length > 0 || LeftoverSpawnSquad.Length > 0)
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
	for (i = 0; i < LastZedInfo.Length; ++i)
	{
		if (LastZedInfo[i].Zed == None || LastZedInfo[i].Zed.Health <= 0)
		{
			LastZedInfo.Remove(i, 1);
			--i;
		}
	}

	foreach DynamicActors(class'KFPawn_Monster', KFM)
	{
		bFound = False;
		// check if we are currently tracking this monster
		for (i = 0; i < LastZedInfo.Length; ++i)
		{
			if (LastZedInfo[i].Zed == KFM)
			{
				bFound = True;	// yes, we are currently tracking this monster
				--LastZedInfo[i].CountDown;
				// run this section if this monster is in the world for more than X seconds (when countdown reach 0)
				if (LastZedInfo[i].CountDown <= 0)
				{
					// if stuck and near full health, teleport it
					if (KFM.Health >= (KFM.HealthMax * 0.9f))
					{
						GroupList.Insert(0,1);
						GroupList[0].ZedClasses.AddItem(KFM.default.class);
						GroupList[0].Delay = 1.0f;
						++WaveTotalAI;
						++KFGameReplicationInfo(WorldInfo.GRI).AIRemaining;

						// kill zed
						KFM.Died(None, None, KFM.Location);
					}
				}
				else
					--LastZedInfo[i].CountDown;
			}
		}

		// if new zed
		if (!bFound)
		{
			LastZedInfo.Insert(0, 1);
			LastZedInfo[0].Zed = KFM;
			LastZedInfo[0].CountDown = class'ZedternalReborn.Config_Map'.static.GetZedStuckTimeout(WorldInfo.GetMapName(True)); // will be teleported after 2.5 minutes or user defined time
		}
	}
}

function bool IsFinishedSpawning()
{
	if (ActiveSpawner != None && ActiveSpawner.bIsSpawning && ActiveSpawner.PendingSpawns.Length > 0)
		return False;

	if (NumAISpawnsQueued >= WaveTotalAI)
		return True;

	if (GroupList.Length == 0 && LeftoverSpawnSquad.Length == 0 && GetAIAliveCount() <= 0)
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
		TimeUntilNextSpawn += GroupList[0].Delay;
		NewSquad = GroupList[0].ZedClasses;
		GroupList.Remove(0, 1);
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

	Name="Default__WMAISpawnManager"
}
