class WMGameInfo_Endless extends KFGameInfo_Survival;

var WMGameInfo_ConfigData ConfigData;

var KFGFxObject_TraderItems DefaultTraderItems;
var WMGFxObject_TraderItems TraderItems;
var float doshNewPlayer;

var int TimeBetweenWavesDefault, TimeBetweenWavesExtend;
var bool bUseExtendedTraderTime, bUseStartingTraderTime, bUseAllTraders;
var int startingWave, finalWave, startingTraderTime, startingDosh;
var byte startingMaxPlayerCount, TraderVoiceIndex;

var float GameDifficultyZedternal;

//Perks
var array<byte> StaticPerks;

//Weapons
var array<name> KFWeaponName;
var array<string> KFWeaponDefPath, StartingWeaponPath;
var array< class<KFWeaponDefinition> > StartingWeapons;

struct S_Weapon_Data
{
	var class<KFWeaponDefinition> KFWeapDefSingle;
	var class<KFWeapon> KFWeapSingle;

	var class<KFWeaponDefinition> KFWeapDefDual;
	var class<KFWeap_DualBase> KFWeapDual;

	var class<KFWeaponDefinition> KFWeapDefSingleReplace;
	var class<KFWeaponDefinition> KFWeapDefDualReplace;

	var bool bVariant;
	var bool bOverride;
};

struct S_Weapon_Upgrade
{
	var class<KFWeapon> KFWeapon;
	var class<WMUpgrade_Weapon> KFWeaponUpgrade;
	var int Price;
};
var array<S_Weapon_Upgrade> WeaponUpgradeArch;

//Special Waves
var int LastSpecialWaveID_First, LastSpecialWaveID_Second;
var array< class<WMSpecialWave> > SpecialWaveList;

struct S_Special_Wave
{
	var int ID;
	var int MinWave, MaxWave;
};
var array<S_Special_Wave> SpecialWaveObjects;

struct S_Special_Wave_Override
{
	var int Wave;
	var int FirstID, SecondID;
	var float Probability;
};
var array<S_Special_Wave_Override> SpecialWaveOverrides;

//Zed Buffs
struct S_Zed_Buff
{
	var int ID;
	var int MinWave, MaxWave;
	var bool bActivated;
};
var array<S_Zed_Buff> ZedBuffSettings;


event InitGame(string Options, out string ErrorMessage)
{
	// starting wave can be set through the console while launching the mod (by adding : ?wave=XXX)
	startingWave = Min(class'GameInfo'.static.GetIntOption(Options, "wave", 0) - 1, 254);

	// final wave can be set through the console while launching the mod (by adding : ?final=XXX)
	finalWave = Min(class'GameInfo'.static.GetIntOption(Options, "final", 255), 255);

	// starting trader time can be set through the console while launching the mod only with starting wave as well (by adding : ?tradertime=XXX)
	startingTraderTime = class'GameInfo'.static.GetIntOption(Options, "tradertime", 0);

	// starting dosh can be set through the console while launching the mod (by adding : ?dosh=XXX)
	startingDosh = class'GameInfo'.static.GetIntOption(Options, "dosh", -1);

	// starting player count can be set through the console while launching the mod (by adding : ?players=XXX)
	startingMaxPlayerCount = class'GameInfo'.static.GetIntOption(Options, "players", 6);

	Super.InitGame(Options, ErrorMessage);

	GameLength = 2;
	MaxPlayers = Clamp(startingMaxPlayerCount, 1, MaxPlayersAllowed);
	MaxPlayersAllowed = MaxPlayers;
}

static function PreloadGlobalContentClasses()
{
	local int i;

	super.PreloadGlobalContentClasses();

	for (i = 0; i < class'ZedternalReborn.WMZedPreload'.default.ZedternalZeds.Length; ++i)
	{
		class'ZedternalReborn.WMZedPreload'.default.ZedternalZeds[i].static.PreloadContent();
	}
}

event PreBeginPlay()
{
	class'ZedternalReborn.Config_Base'.static.PrintVersion();

	super.PreBeginPlay();

	// Update and check default values
	class'ZedternalReborn.Config_Base'.static.LoadConfigs();

	// Create config data holder and load all valid values
	ConfigData = new class'WMGameInfo_ConfigData';
	ConfigData.InitializeConfigData();

	// Create and process config data for spawn manager
	if (WMAISpawnManager(SpawnManager) != None)
		WMAISpawnManager(SpawnManager).InitializeZedSpawnData();

	if (WMGameDifficulty_Endless(DifficultyInfo) != None)
		WMGameDifficulty_Endless(DifficultyInfo).InitializeCustomDiffGroupData();
}

event PostBeginPlay()
{
	super.PostBeginPlay();

	// Set all traders toggle
	bUseAllTraders = class'ZedternalReborn.Config_Map'.static.GetAllTraders(WorldInfo.GetMapName(True));

	// Store which perks are static (always selected first) for future use
	InitializeStaticPerkList();

	// Available weapon are random each wave. Need to build the list
	BuildWeaponList();

	// Initialize special wave and overrides
	InitializeSpecialWave();

	// Initialize zed buffs
	InitializeZedBuff();

	// Set item pickups
	SetupPickupItems();

	// Set objective zones
	if (IsMapObjectiveEnabled())
		SetupObjectiveZones();

	// Select Trader voice
	SelectRandomTraderVoice();

	// Replicate new information from this game mode (weapon list, skill, monster...)
	RepGameInfoHighPriority();

	if (startingDosh >= 0)
		doshNewPlayer = startingDosh;
	else if (class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(True)) >= 0)
		doshNewPlayer = class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(True));
	else
		doshNewPlayer = class'ZedternalReborn.Config_Dosh'.static.GetStartingDosh(GameDifficultyZedternal);

	LastSpecialWaveID_First = INDEX_NONE;
	LastSpecialWaveID_Second = INDEX_NONE;

	TimeBetweenWaves = class'ZedternalReborn.Config_GameOptions'.static.GetTimeBetweenWave(GameDifficultyZedternal);
	TimeBetweenWavesDefault = TimeBetweenWaves;

	TimeBetweenWavesExtend = class'ZedternalReborn.Config_GameOptions'.static.GetTimeBetweenWaveHumanDied(GameDifficultyZedternal);
	bUseExtendedTraderTime = False;
	bUseStartingTraderTime = False;
}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage)
{
	local bool bSpectator;
	local bool bPerfTesting;

	// Check for an arbitrated match in progress and kick if needed
	if (WorldInfo.NetMode != NM_Standalone && bUsingArbitration && bHasArbitratedHandshakeBegun)
	{
		ErrorMessage = PathName(WorldInfo.Game.GameMessageClass) $ ".ArbitrationMessage";
		return;
	}

	// If this player is banned, reject him
	if (AccessControl != None && AccessControl.IsIDBanned(UniqueId))
	{
		`Log("ZR Info:"@Address@"is banned, rejecting...");
		ErrorMessage = "<Strings:KFGame.KFLocalMessage.BannedFromServerString>";
		return;
	}


	bPerfTesting = (ParseOption(Options, "AutomatedPerfTesting") ~= "1");
	bSpectator = bPerfTesting || (ParseOption(Options, "SpectatorOnly") ~= "1") || (ParseOption(Options, "CauseEvent") ~= "FlyThrough");

	if (AccessControl != None)
	{
		AccessControl.PreLogin(Options, Address, UniqueId, bSupportsAuth, ErrorMessage, bSpectator);
	}
}

event PostLogin(PlayerController NewPlayer)
{
	local WMPlayerController WMPC;
	local WMPlayerReplicationInfo WMPRI;

	super.PostLogin(NewPlayer);

	WMPC = WMPlayerController(NewPlayer);
	WMPRI = WMPlayerReplicationInfo(WMPC.PlayerReplicationInfo);

	if (MyKFGRI != None && MyKFGRI.AIRemaining > 0)
		bUseExtendedTraderTime = True;

	if (WMPRI != None)
		RepPlayerInfo(WMPRI);

	if (WMPC != None)
		WMPC.SetPreferredGrenadeTimer();
}

/** Set up the spawning */
function InitSpawnManager()
{
	SpawnManager = new(self) SpawnManagerClasses[GameLength];
	SpawnManager.Initialize();

	`log("ZedternalReborn GameDifficulty:" @ GameDifficulty);

	if (GameDifficulty > `DIFFICULTY_HELLONEARTH)
	{
		GameDifficultyZedternal = `DIFFICULTY_ZEDTERNALCUSTOM;
		GameDifficulty = `DIFFICULTY_HELLONEARTH;
	}
	else
		GameDifficultyZedternal = GameDifficulty;

	InitWaveNumbers();
}

function InitWaveNumbers()
{
	if (startingWave >= 0)
		WaveNum = startingWave;
	else
		WaveNum = class'ZedternalReborn.Config_Map'.static.GetStartingWave(WorldInfo.GetMapName(True));

	if (finalWave < 255 && finalWave > 0)
		WaveMax = finalWave;
	else
		WaveMax = class'ZedternalReborn.Config_Map'.static.GetFinalWave(WorldInfo.GetMapName(True));

	if (WaveMax <= WaveNum)
	{
		`log("ZR Warning: Final wave was set to wave"@WaveMax@"but start wave is set to wave"@(WaveNum + 1)@". Moving final wave to wave"@(WaveNum + 1));
		WaveMax = WaveNum + 1;
	}

	MyKFGRI.WaveMax = WaveMax;
}

function StartMatch()
{
	local KFPlayerController KFPC;
	local WMGameReplicationInfo WMGRI;

	MyKFGRI.WaveNum = WaveNum;

	super(KFGameInfo).StartMatch();

	if (WorldInfo.NetMode != NM_Standalone)
	{
		WMGRI = WMGameReplicationInfo(MyKFGRI);
		if (WMGRI != None)
		{
			WMGRI.UpdateSkins = True;
		}
	}
	else
	{
		class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsStandalone(KFWeaponDefPath);
	}

	if (class'KFGameEngine'.static.CheckNoAutoStart() || class'KFGameEngine'.static.IsEditor())
	{
		GotoState('DebugSuspendWave');
	}
	else if (WaveNum == 0)
	{
		GotoState('PlayingWave');
	}
	else
	{
		MyKFGRI.UpdateHUDWaveCount();
		if (startingTraderTime > 0 || class'ZedternalReborn.Config_Map'.static.GetStartingTraderTime(WorldInfo.GetMapName(True)) > 0)
			bUseStartingTraderTime = True;
		else
			bUseExtendedTraderTime = True;

		SetupNextTrader();
		GotoState('TraderOpen', 'Begin');

		// update wave modificators
		SetTimer(4.5f, False, NameOf(CheckForPreviousZedBuff));

		// Set next wave objective
		MyKFGRI.DeactivateObjective();
	}

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		KFPC.ClientMatchStarted();
		if (startingDosh >= 0)
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score = startingDosh;
		else if (class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(True)) >= 0)
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score = class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(True));
		else
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score = class'ZedternalReborn.Config_Dosh'.static.GetStartingDosh(GameDifficultyZedternal);
	}
}

function StartWave()
{
	local KFPlayerController KFPC;

	//Closes trader on server
	MyKFGRI.CloseTrader();
	NotifyTraderClosed();

	//Increment wave
	++WaveNum;
	MyKFGRI.WaveNum = WaveNum;

	//Check and set special wave
	SetupSpecialWave();

	//Check and set objectives
	if (IsMapObjectiveEnabled())
	{
		MyKFGRI.ClearPreviousObjective();
		MyKFGRI.StartNextObjective();
	}

	//Reset zed wave counters
	NumAIFinishedSpawning = 0;
	NumAISpawnsQueued = 0;
	AIAliveCount = 0;
	MyKFGRI.bForceNextObjective = False;

	//Set up spawns for next wave
	SpawnManager.SetupNextWave(WaveNum);

	//Set the HUD for standalone
	if (WorldInfo.NetMode != NM_DedicatedServer && Role == ROLE_Authority)
	{
		MyKFGRI.UpdateHUDWaveCount();
	}

	//Start the wave
	WaveStarted();
	MyKFGRI.NotifyWaveStart();
	MyKFGRI.AIRemaining = SpawnManager.WaveTotalAI;
	MyKFGRI.WaveTotalAICount = SpawnManager.WaveTotalAI;

	//Announce the start
	BroadcastLocalizedMessage(class'KFLocalMessage_Priority', GMT_WaveStart);

	//Setup the next trader
	SetupNextTrader();

	//Reset all ammo and item pickups
	ResetAllPickups();

	//Reset the zed buff indicator
	if (WMGameReplicationInfo(MyKFGRI) != None)
		WMGameReplicationInfo(MyKFGRI).bNewZedBuff = False;

	//Disable trader dialog
	if (Role == ROLE_Authority && KFGameInfo(WorldInfo.Game) != None && KFGameInfo(WorldInfo.Game).DialogManager != None)
		KFGameInfo(WorldInfo.Game).DialogManager.SetTraderTime(False);

	// first spawn and music are delayed 5 seconds (KFAISpawnManager.TimeUntilNextSpawn == 5 initially), so line up dialog with them;
	// fixes problem of clients not being ready to receive dialog at the instant the match starts;
	// Do not play for Patriarch and Hans endless dialog
	if (TraderVoiceIndex != 0 && TraderVoiceIndex != 1)
		SetTimer(5.0f, False, NameOf(PlayWaveStartDialog));

	//Reset Supplier ability here
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC.GetPerk() != None)
			KFPC.GetPerk().OnWaveStart();
	}
}

function WaveStarted()
{
	super.WaveStarted();

	//For Patriarch and Hans endless dialog only
	if (TraderVoiceIndex == 0 || TraderVoiceIndex == 1)
		SetTimer(1.0f, false, 'WaveStartedEndlessDialog', WMGameReplicationInfo(GameReplicationInfo));
}

function WaveEnded(EWaveEndCondition WinCondition)
{
	local WMPlayerController WMPC;

	if (!bWaveStarted && !MyKFGRI.bTraderIsOpen)
		return;

	super.WaveEnded(WinCondition);

	ClearSpecialWave();

	foreach DynamicActors(class'WMPlayerController', WMPC)
	{
		if (WMPerk(WMPC.CurrentPerk) != None)
			WMPerk(WMPC.CurrentPerk).WaveEnd(WMPC);
	}

	if (WinCondition == WEC_WaveWon)
		SetTimer(4.5f, False, NameOf(CheckZedBuff));
}

function RestartPlayer(Controller NewPlayer)
{
	local WMPlayerController WMPC;
	local WMPlayerReplicationInfo WMPRI;
	local float TimeOffset;
	local bool bWasWaitingForClientPerkData;

	WMPC = WMPlayerController(NewPlayer);
	WMPRI = WMPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);

	if (WMPC != None && WMPRI != None)
	{
		if (IsPlayerReady(WMPRI))
		{
			bWasWaitingForClientPerkData = WMPC.bWaitingForClientPerkData;

			// If we have rejoined the match more than once, delay our respawn by some amount of time
			if (MyKFGRI.bMatchHasBegun && WMPRI.NumTimesReconnected > 1 && `TimeSince(WMPRI.LastQuitTime) < ReconnectRespawnTime)
			{
				WMPC.StartSpectate();
				WMPC.SetTimer(ReconnectRespawnTime - `TimeSince(WMPRI.LastQuitTime), False, NameOf(WMPC.SpawnReconnectedPlayer));
			}
			// If a wave is active, we spectate until the end of the wave
			else if (IsWaveActive() && !bWasWaitingForClientPerkData)
			{
				WMPC.StartSpectate();
			}
			else
			{
				// Skip over KFGameInfo_Survival
				super(KFGameInfo).RestartPlayer(NewPlayer);

				// Already gone through one RestartPlayer() cycle, don't process again
				if (bWasWaitingForClientPerkData)
					return;

				WMPC.UpdateWeaponMagAndCap();

				// Perk Update for rejoining players
				if (!isWaveActive() && WMPRI.NumTimesReconnected > 0)
				{
					TimeOffset = 0;

					if (WMPRI.NumTimesReconnected > 1 && `TimeSince(WMPRI.LastQuitTime) < ReconnectRespawnTime)
						TimeOffset = ReconnectRespawnTime - `TimeSince(WMPRI.LastQuitTime);

					WMPC.DelayedPerkUpdate(TimeOffset);
				}

				// Late joiner dosh
				if (!WMPRI.bHasPlayed && WMPC.Pawn != None && WMPC.Pawn.IsAliveAndWell())
				{
					if (MyKFGRI.bMatchHasBegun)
						WMPRI.Score = GetAdjustedDeathPenalty(WMPRI, True);

					WMPRI.bHasPlayed = True;
				}
			}
		}
	}
}

function SetupNextTrader()
{
	if (!bUseAllTraders)
		super.SetupNextTrader();
}

function SetupPickupItems()
{
	local int i;
	local bool bShouldArmorSpawn;
	local KFPickupFactory_Item KFPFID;
	local array<ItemPickup> StartingItemPickups;
	local class<KFWeapon> startingWeaponClass;
	local class<KFWeap_DualBase> startingWeaponClassDual;
	local ItemPickup newPickup;

	// Set Weapon PickupFactory

	//Add armor
	bShouldArmorSpawn = class'ZedternalReborn.Config_GameOptions'.static.GetShouldArmorSpawnOnMap(GameDifficultyZedternal);
	if (bShouldArmorSpawn)
	{
		newPickup.ItemClass = class'KFGameContent.KFInventory_Armor';
		StartingItemPickups.AddItem(newPickup);
	}

	//Add 9mm
	newPickup.ItemClass = class'KFGameContent.KFWeap_Pistol_9mm';
	StartingItemPickups.AddItem(newPickup);

	//Add starting weapons
	for (i = 0; i < StartingWeapons.Length; ++i)
	{
		startingWeaponClass = class<KFWeapon>(DynamicLoadObject(StartingWeapons[i].default.WeaponClassPath, class'Class'));

		//Test for dual weapon
		startingWeaponClassDual = class<KFWeap_DualBase>(startingWeaponClass);
		if (startingWeaponClassDual != None)
		{
			//Only allow single to spawn
			startingWeaponClass = startingWeaponClassDual.default.SingleClass;
		}

		newPickup.ItemClass = startingWeaponClass;
		StartingItemPickups.AddItem(newPickup);
	}

	//Set KFPickupFactory objects
	for (i = 0; i < ItemPickups.length; ++i)
	{
		ItemPickups[i].StartSleeping();
		KFPFID = KFPickupFactory_Item(ItemPickups[i]);
		if (KFPFID != None)
		{
			if (bShouldArmorSpawn && KFPFID.ItemPickups.length == 1 && KFPFID.ItemPickups[0].ItemClass == class'KFGameContent.KFInventory_Armor')
				continue; //Do not replace an armor only spawn, unless armor is disabled from pickups

			KFPFID.ItemPickups.length = 0;
			KFPFID.ItemPickups = StartingItemPickups;
			ItemPickups[i] = KFPFID;
			ItemPickups[i].Reset();
		}
	}

	//Set KFPickupFactory objects on map to override Kismet
	foreach DynamicActors(class'KFPickupFactory_Item', KFPFID)
	{
		if (KFPFID != None)
		{
			if (bShouldArmorSpawn && KFPFID.ItemPickups.length == 1 && KFPFID.ItemPickups[0].ItemClass == class'KFGameContent.KFInventory_Armor')
				continue; //Do not replace an armor only spawn, unless armor is disabled from pickups

			KFPFID.StartSleeping();
			KFPFID.ItemPickups.length = 0;
			KFPFID.ItemPickups = StartingItemPickups;
			KFPFID.Reset();
		}
	}

	//Cleanup and reset everything
	ResetAllPickups();
}

function SetupObjectiveZones()
{
	local byte b;
	local WMMapObjective_DoshHold NewObjective;
	local KFMapObjective_DoshHold OldObjective;
	local array<KFMapObjective_DoshHold> OldObjectiveZones;
	local array<KFInterface_MapObjective> NewObjectiveZones;
	local KFMapInfo KFMI;

	//Get all the Dosh Hold objectives on the map
	foreach DynamicActors(class'KFMapObjective_DoshHold', OldObjective)
	{
		if (OldObjective != None)
		{
			OldObjectiveZones.AddItem(OldObjective);
		}
	}

	//Create new objectives
	for (b = 0; b < OldObjectiveZones.Length; ++b)
	{
		NewObjective = Spawn(class'WMMapObjective_DoshHold');
		if (NewObjective != None)
		{
			NewObjective.ActivatePctChance = class'ZedternalReborn.Config_Objective'.static.GetObjectiveProbability(GameDifficultyZedternal);
			NewObjective.DoshRewardsZedternal = class'ZedternalReborn.Config_Objective'.static.GetObjectiveBaseDoshReward(GameDifficultyZedternal);
			NewObjective.PctOfWaveZedsKilledForMaxRewardZedternal = class'ZedternalReborn.Config_Objective'.static.GetPctOfWaveKilledForMaxReward(GameDifficultyZedternal);
			NewObjective.DoshScalarIncPerWaveZedternal = class'ZedternalReborn.Config_Objective'.static.GetDoshIncreaseModifierPerWave(GameDifficultyZedternal);

			NewObjective.Parent = OldObjectiveZones[b];
			NewObjective.ParentName = OldObjectiveZones[b].Name;
			NewObjectiveZones.AddItem(NewObjective);
		}
		else
		{
			`log("ZR Warning: Failed to override objective"@OldObjectiveZones[b].Name@"due to failure to spawn in new objective actor");
		}
	}

	KFMI = KFMapInfo(WorldInfo.GetMapInfo());
	if (KFMI != None)
	{
		if (KFMI.bUseRandomObjectives)
		{
			KFMI.bUsePresetObjectives = False; //Just in case
			KFMI.RandomWaveObjectives.Length = 0;
			KFMI.RandomWaveObjectives = NewObjectiveZones;
		}
		else if (KFMI.bUsePresetObjectives)
		{
			`log("ZR Warning: Not random objectives, currently not supported for ZedternalReborn");
			KFMI.bUsePresetObjectives = False;
		}
		else
		{
			`log("ZR Info: Map does not have any objectives or objective zones to activate");
		}
	}
}

function InitializeZedBuff()
{
	local int i;
	local S_Zed_Buff ZB;

	if (class'ZedternalReborn.Config_ZedBuff'.static.GetZedBuffEnable(GameDifficultyZedternal))
	{
		for (i = 0; i < ConfigData.ValidZedBuffs.Length; ++i)
		{
			ZB.ID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ConfigData.ZedBuffObjects, ConfigData.ValidZedBuffs[i].Path);
			ZB.MinWave = ConfigData.ValidZedBuffs[i].MinWave;
			ZB.MaxWave = ConfigData.ValidZedBuffs[i].MaxWave;
			ZB.bActivated = False;
			ZedBuffSettings.AddItem(ZB);
		}
	}

	if (ConfigData.ZedBuffObjects.Length > 255)
	{
		`log("ZR Warning: Zed buffs list exceed 255 elements which is not valid for replication."
			@"Trimmed the list down to 255 elements, some zed buffs defined in the config will never"
			@"execute because of this change.");
	}
}

function CheckZedBuff()
{
	local int Count;

	if (class'ZedternalReborn.Config_ZedBuff'.static.GetZedBuffEnable(GameDifficultyZedternal)
		&& class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum, Count))
		ApplyRandomZedBuff(WaveNum, True, Count);
}

// Used when starting match at higher wave
function CheckForPreviousZedBuff()
{
	local int TestedWave, Count;

	if (class'ZedternalReborn.Config_ZedBuff'.static.GetZedBuffEnable(GameDifficultyZedternal))
	{
		for (TestedWave = 1; TestedWave <= WaveNum; ++TestedWave)
		{
			if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(TestedWave, Count))
				ApplyRandomZedBuff(TestedWave, False, Count);
		}
	}
}

function ApplyRandomZedBuff(int Wave, bool bRewardPlayer, int Count)
{
	local int i, DoshMultiplier, CountOriginal;
	local array<int> ActivateIndex, BuffIndex;
	local WMGameReplicationInfo WMGRI;
	local KFPlayerController KFPC;

	WMGRI = WMGameReplicationInfo(MyKFGRI);

	if (WMGRI != None)
	{
		// build available buff list
		for (i = 0; i < ZedBuffSettings.Length; ++i)
		{
			if (!ZedBuffSettings[i].bActivated && ZedBuffSettings[i].ID != INDEX_NONE && ZedBuffSettings[i].ID < 255
				&& ZedBuffSettings[i].MinWave <= Wave && ZedBuffSettings[i].MaxWave >= Wave
				&& WMGRI.ActiveZedBuffs[ZedBuffSettings[i].ID] < 50)
			{
				ActivateIndex.AddItem(i);
				BuffIndex.AddItem(ZedBuffSettings[i].ID);
			}
		}

		// select random buff
		if (BuffIndex.Length > 0)
		{
			CountOriginal = Count;
			do
			{
				i = Rand(BuffIndex.Length);

				// spawn zedbuff object in world
				Spawn(WMGRI.ZedBuffsList[BuffIndex[i]].ZedBuff);

				++WMGRI.ActiveZedBuffs[BuffIndex[i]];
				ZedBuffSettings[ActivateIndex[i]].bActivated = True;
				BuffIndex.Remove(i, 1);
				ActivateIndex.Remove(i, 1);
				--Count;
			} until (Count <= 0 || BuffIndex.Length <= 0);

			// warn players about new buff
			WMGRI.bNewZedBuff = True;
			if (WorldInfo.NetMode != NM_DedicatedServer)
				WMGRI.PlayZedBuffSoundAndEffect();

			// reward players for zed buffs
			if (bRewardPlayer)
			{
				if (class'ZedternalReborn.Config_ZedBuff'.static.GetBonusDoshGivenPerBuff(GameDifficultyZedternal))
					DoshMultiplier = Max(1, CountOriginal - Max(0, Count));
				else
					DoshMultiplier = 1;

				foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
				{
					if (KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo) != None)
					{
						KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh(class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(GameDifficultyZedternal) * DoshMultiplier, True);
					}
				}

				doshNewPlayer += class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(GameDifficultyZedternal) * DoshMultiplier;
			}

			// play bosses music to stress players
			WMGRI.ForceNewMusicZedBuff();
		}

		RepairDoor();
	}
}

function RepairDoor()
{
	local KFDoorActor KFD;

	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		if (!KFD.bIsDestroyed)
			KFD.WeldableComponent.Weld(-KFD.MaxWeldIntegrity);
		else
			KFD.WeldableComponent.Repair(1.0f);
	}

	SetTimer(2.0f, False, NameOf(RepairDoorDelay));
}

function RepairDoorDelay()
{
	local KFDoorActor KFD;
	local WMGameReplicationInfo WMGRI;

	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		KFD.ResetDoor();
	}

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI != None);
		WMGRI.bRepairDoorTrigger = !WMGRI.bRepairDoorTrigger;
}

function OpenTrader()
{
	local WMGameReplicationInfo WMGRI;
	local int i, Count, TimeMultiplier;

	if (bUseStartingTraderTime)
	{
		if (startingTraderTime > 0)
			TimeBetweenWaves = startingTraderTime;
		else
			TimeBetweenWaves = class'ZedternalReborn.Config_Map'.static.GetStartingTraderTime(WorldInfo.GetMapName(True));

		bUseStartingTraderTime = False;
	}
	else if (bUseExtendedTraderTime)
	{
		TimeBetweenWaves = TimeBetweenWavesExtend;
		bUseExtendedTraderTime = False;
	}
	else
		TimeBetweenWaves = TimeBetweenWavesDefault;

	if (class'ZedternalReborn.Config_ZedBuff'.static.GetZedBuffEnable(GameDifficultyZedternal)
		&& class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum, Count))
	{
		WMGRI = WMGameReplicationInfo(MyKFGRI);

		if (WMGRI != None)
		{
			//Check to see if any Zed buffs are available
			TimeMultiplier = 0;
			for (i = 0; i < ZedBuffSettings.Length; ++i)
			{
				if (!ZedBuffSettings[i].bActivated && ZedBuffSettings[i].ID != INDEX_NONE && ZedBuffSettings[i].ID < 255
					&& ZedBuffSettings[i].MinWave <= WaveNum && ZedBuffSettings[i].MaxWave >= WaveNum
					&& WMGRI.ActiveZedBuffs[ZedBuffSettings[i].ID] < 50)
					++TimeMultiplier;
			}
		}
		else
			TimeMultiplier = 1; //If WMGRI is not available, default to 1

		if (class'ZedternalReborn.Config_ZedBuff'.static.GetBonusTraderTimeGivenPerBuff(GameDifficultyZedternal))
			TimeMultiplier = Min(TimeMultiplier, Count);
		else
			TimeMultiplier = 1;

		TimeBetweenWaves += class'ZedternalReborn.Config_ZedBuff'.static.GetTraderTimeBonus(GameDifficultyZedternal) * TimeMultiplier;
	}

	MyKFGRI.OpenTrader(TimeBetweenWaves);
	NotifyTraderOpened();
}

function BossDied(Controller Killer, optional bool bCheckWaveEnded = True)
{
	CheckWaveEnd();
}

function InitializeSpecialWave()
{
	local int i, Ins;
	local S_Special_Wave SW;
	local S_Special_Wave_Override SWO;

	if (class'ZedternalReborn.Config_SpecialWave'.static.GetSpecialWaveAllowed(GameDifficultyZedternal)
		&& class'ZedternalReborn.Config_SpecialWaveOverride'.static.GetSpecialWaveOverrideAllowed(GameDifficultyZedternal))
	{
		//Combine the lists
		SpecialWaveList = ConfigData.SpecialWaveObjects;
		for (i = 0; i < ConfigData.SWOverrideObjects.Length; ++i)
		{
			if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(SpecialWaveList, PathName(ConfigData.SWOverrideObjects[i]), Ins))
					SpecialWaveList.InsertItem(Ins, ConfigData.SWOverrideObjects[i]);
		}
	}
	else if (class'ZedternalReborn.Config_SpecialWave'.static.GetSpecialWaveAllowed(GameDifficultyZedternal))
		SpecialWaveList = ConfigData.SpecialWaveObjects;
	else if (class'ZedternalReborn.Config_SpecialWaveOverride'.static.GetSpecialWaveOverrideAllowed(GameDifficultyZedternal))
		SpecialWaveList = ConfigData.SWOverrideObjects;

	if (class'ZedternalReborn.Config_SpecialWave'.static.GetSpecialWaveAllowed(GameDifficultyZedternal))
	{
		for (i = 0; i < ConfigData.ValidSpecialWaves.Length; ++i)
		{
			SW.ID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(SpecialWaveList, ConfigData.ValidSpecialWaves[i].Path);
			SW.MinWave = ConfigData.ValidSpecialWaves[i].MinWave;
			SW.MaxWave = ConfigData.ValidSpecialWaves[i].MaxWave;
			SpecialWaveObjects.AddItem(SW);
		}
	}

	if (class'ZedternalReborn.Config_SpecialWaveOverride'.static.GetSpecialWaveOverrideAllowed(GameDifficultyZedternal))
	{
		for (i = 0; i < ConfigData.ValidSpecialWaveOverrides.Length; ++i)
		{
			SWO.Wave = ConfigData.ValidSpecialWaveOverrides[i].Wave;
			SWO.FirstID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(SpecialWaveList, ConfigData.ValidSpecialWaveOverrides[i].FirstPath);
			SWO.SecondID = class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(SpecialWaveList, ConfigData.ValidSpecialWaveOverrides[i].SecondPath);
			SWO.Probability = ConfigData.ValidSpecialWaveOverrides[i].Probability;
			SpecialWaveOverrides.AddItem(SWO);
		}
	}

	if (SpecialWaveList.Length > 255)
	{
		SpecialWaveList.Length = 255;
		`log("ZR Warning: Special waves list exceed 255 elements which is not valid for replication."
			@"Trimmed the list down to 255 elements, some special waves defined in the config will never"
			@"execute because of this change.");
	}
}

function SetupSpecialWave()
{
	local int index;
	local array<int> SWList;
	local int i;

	SWList.length = 0;

	// Check if it is a special wave override. If True, check all available special wave overrides
	if (class'ZedternalReborn.Config_SpecialWaveOverride'.static.GetSpecialWaveOverrideAllowed(GameDifficultyZedternal))
	{
		for (i = 0; i < SpecialWaveOverrides.length; ++i)
		{
			if (SpecialWaveOverrides[i].Wave == WaveNum && FRand() < SpecialWaveOverrides[i].Probability)
			{
				if (SpecialWaveOverrides[i].FirstID != INDEX_NONE && SpecialWaveOverrides[i].FirstID < 255)
					SWList.AddItem(SpecialWaveOverrides[i].FirstID);

				if (SpecialWaveOverrides[i].SecondID != INDEX_NONE && SpecialWaveOverrides[i].SecondID < 255)
					SWList.AddItem(SpecialWaveOverrides[i].SecondID);

				break;
			}
		}

		if (SWList.length != 0)
		{
			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] = SWList[0];
			LastSpecialWaveID_First = SWList[0];

			if (SWList.length > 1)
			{
				WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = SWList[1];
				LastSpecialWaveID_Second = SWList[1];
			}
			else
				LastSpecialWaveID_Second = INDEX_NONE;

			// if playing solo, trigger special wave visual effect
			if (WorldInfo.NetMode != NM_DedicatedServer)
				WMGameReplicationInfo(MyKFGRI).TriggerSpecialWaveMessage();

			SetTimer(5.0f, False, NameOf(SetSpecialWaveActor));
			return;
		}
	}

	// Check if it is a special wave. If True, build available special wave list (SWList)
	if (class'ZedternalReborn.Config_SpecialWave'.static.GetSpecialWaveAllowed(GameDifficultyZedternal)
		&& FRand() < class'ZedternalReborn.Config_SpecialWave'.static.GetSpecialWaveProbability(GameDifficultyZedternal))
	{
		for (i = 0; i < SpecialWaveObjects.Length; ++i)
		{
			if (SpecialWaveObjects[i].ID != INDEX_NONE && SpecialWaveObjects[i].ID < 255
				&& SpecialWaveObjects[i].MinWave <= WaveNum && SpecialWaveObjects[i].MaxWave >= WaveNum)
				SWList.AddItem(SpecialWaveObjects[i].ID);
		}
	}

	// Select a Special Wave from SWList
	if (SWList.length != 0)
	{
		index = Rand(SWList.Length);
		if (LastSpecialWaveID_First == SWList[index] || LastSpecialWaveID_Second == SWList[index])
			index = Rand(SWList.Length); //Re-roll the special wave if it was used recently

		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] = SWList[index];
		LastSpecialWaveID_First = SWList[index];
		SWList.Remove(index, 1);

		// check for a double special wave
		if (SWList.length != 0 && FRand() < class'ZedternalReborn.Config_SpecialWave'.static.GetSpecialWaveDoubleProbability(GameDifficultyZedternal))
		{
			index = Rand(SWList.Length);
			if (LastSpecialWaveID_Second == SWList[index] || LastSpecialWaveID_First == SWList[index])
				index = Rand(SWList.Length); //Re-roll the special wave if it was used recently

			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = SWList[index];
			LastSpecialWaveID_Second = SWList[index];
		}
		else
		{
			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = INDEX_NONE;
			LastSpecialWaveID_Second = INDEX_NONE;
		}

		// if playing solo, trigger special wave visual effect
		if (WorldInfo.NetMode != NM_DedicatedServer)
			WMGameReplicationInfo(MyKFGRI).TriggerSpecialWaveMessage();

		SetTimer(5.0f, False, NameOf(SetSpecialWaveActor));
	}
	else
	{
		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] = INDEX_NONE;
		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = INDEX_NONE;
	}
}

function SetSpecialWaveActor()
{
	local WMPlayerController WMPC;

	if (WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] != INDEX_NONE)
		Spawn(WMGameReplicationInfo(MyKFGRI).SpecialWavesList[WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0]].SpecialWave);
	if (WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] != INDEX_NONE)
		Spawn(WMGameReplicationInfo(MyKFGRI).SpecialWavesList[WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1]].SpecialWave);

	foreach DynamicActors(class'WMPlayerController', WMPC)
	{
		WMPC.UpdateWeaponMagAndCap();
	}
}

function ClearSpecialWave()
{
	local WMSpecialWave WMSW;
	local WMPlayerController WMPC;
	local byte i;

	for (i = 0; i <= 1; ++i)
	{
		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[i] = INDEX_NONE;
	}
	foreach DynamicActors(class'WMSpecialWave', WMSW)
	{
		WMSW.WaveEnded();
	}
	foreach DynamicActors(class'WMPlayerController', WMPC)
	{
		WMPC.UpdateWeaponMagAndCap();
	}
}

////////
//Weapon Code Start
////////

function BuildWeaponList()
{
	local int i, Begin;
	local array<int> WeaponIndex;

	Begin = InitializeTraderItems(WeaponIndex);

	////////////////////////
	// Create weapon list //
	////////////////////////

	WeaponUpgradeArch.Length = 0;

	//Add static and starting weapons
	for (i = 0; i < Begin; ++i)
	{
		AddWeaponInTrader(TraderItems.SaleItems[i].WeaponDef);
	}

	PickWeapons(WeaponIndex, Begin);

	SetTraderItemsAndPrintWeaponList();
}

function PickWeapons(out array<int> WeaponIndex, int Begin)
{
	local int i, x;

	//Adding randomly other weapons
	for (i = Begin; i < class'ZedternalReborn.Config_Trader'.static.GetMaxWeapon(GameDifficultyZedternal); ++i)
	{
		if (WeaponIndex.Length > 0)
		{
			x = Rand(WeaponIndex.Length);
			AddWeaponInTrader(TraderItems.SaleItems[WeaponIndex[x]].WeaponDef);
			WeaponIndex.Remove(x, 1);
		}
	}
}

function int InitializeTraderItems(out array<int> WeaponIndex)
{
	local int RandStart;
	local array<S_Weapon_Data> CombinedWeaponList;

	WeaponIndex.Length = 0;

	//Initialize TraderItems
	TraderItems = new class'WMGFxObject_TraderItems';

	/////////////////////////////
	// Armor and Grenade Price //
	/////////////////////////////
	TraderItems.ArmorPrice = class'ZedternalReborn.Config_Trader'.static.GetArmorPrice(GameDifficultyZedternal);
	TraderItems.GrenadePrice = class'ZedternalReborn.Config_Trader'.static.GetGrenadePrice(GameDifficultyZedternal);

	if (WMGameReplicationInfo(MyKFGRI) != None)
	{
		WMGameReplicationInfo(MyKFGRI).ArmorPrice = TraderItems.ArmorPrice;
		WMGameReplicationInfo(MyKFGRI).GrenadePrice = TraderItems.GrenadePrice;
	}

	//////////////////////
	// Register Weapons //
	//////////////////////

	RandStart = CombineAllWeapons(CombinedWeaponList);
	CheckWeaponList(CombinedWeaponList);
	ApplyVariantsAndOverrides(CombinedWeaponList);
	SetStartingWeapons(CombinedWeaponList);
	RegisterWeapons(CombinedWeaponList, WeaponIndex, RandStart);

	return RandStart;
}

function int CombineAllWeapons(out array<S_Weapon_Data> CombinedWeaponList)
{
	local int i, x, StartNum;
	local array< class<KFWeaponDefinition> > BaseWepDef;
	local array< class<KFWeapon> > BaseWep;

	//Static Weapons
	CombineWeapons(CombinedWeaponList, ConfigData.StaticWeaponDefObjects, ConfigData.StaticWeaponObjects);

	//Starting Weapons
	StartNum = CombineWeaponsStartingWeapon(CombinedWeaponList, BaseWepDef, BaseWep);

	//Custom Weapons
	if (class'ZedternalReborn.Config_WeaponCustom'.default.Weapon_bUseCustomWeaponList)
		CombineWeapons(CombinedWeaponList, ConfigData.CustomWeaponDefObjects, ConfigData.CustomWeaponObjects);

	//Base Weapons
	BaseWepDef.Length = 0;
	BaseWep.Length = 0;
	for (i = 0; i < DefaultTraderItems.SaleItems.Length; ++i)
	{
		if (DefaultTraderItems.SaleItems[i].WeaponDef != None)
		{
			BaseWepDef.AddItem(DefaultTraderItems.SaleItems[i].WeaponDef);
			BaseWep.AddItem(class<KFWeapon>(DynamicLoadObject(DefaultTraderItems.SaleItems[i].WeaponDef.default.WeaponClassPath, class'Class')));
		}
	}

	//If base weapons are disabled, just add the single weapons for dual weapons that are missing a single weapon
	if (class'ZedternalReborn.Config_WeaponDisable'.default.Weapon_bDisableAllBaseWeapons)
	{
		for (i = 0; i < CombinedWeaponList.Length; ++i)
		{
			if (CombinedWeaponList[i].KFWeapDual != None && CombinedWeaponList[i].KFWeapSingle == None)
			{
				for (x = 0; x < BaseWepDef.Length; ++x)
				{
					if (CombinedWeaponList[i].KFWeapDual.default.SingleClass == BaseWep[x])
					{
						CombinedWeaponList[i].KFWeapDefSingle = BaseWepDef[x];
						CombinedWeaponList[i].KFWeapSingle = BaseWep[x];
						break;
					}
				}
			}
		}
	}
	else
		CombineWeapons(CombinedWeaponList, BaseWepDef, BaseWep);

	//Remove disabled weapons
	if (class'ZedternalReborn.Config_WeaponDisable'.default.Weapon_bUseDisableWeaponList)
	{
		for (i = 0; i < CombinedWeaponList.Length; ++i)
		{
			if (CombinedWeaponList[i].KFWeapDefSingle != None
				&& class'ZedternalReborn.WMBinaryOps'.static.BinarySearch(ConfigData.DisableWeaponDefObjects, PathName(CombinedWeaponList[i].KFWeapDefSingle)) != INDEX_NONE)
			{
				CombinedWeaponList.Remove(i, 1);
				--i;
			}
		}
	}

	return ConfigData.StaticWeaponDefObjects.Length + StartNum;
}

function CombineWeapons(out array<S_Weapon_Data> CombinedWeaponList, const out array< class<KFWeaponDefinition> > DefArray,
	const out array< class<KFWeapon> > WepArray)
{
	local int i, x;
	local string SearchString;
	local S_Weapon_Data NewWep;
	local class<KFWeap_DualBase> KFWDual;

	for (i = 0; i < DefArray.Length; ++i)
	{
		KFWDual = class<KFWeap_DualBase>(WepArray[i]);
		if (KFWDual != None)
		{
			SearchString = PathName(KFWDual.default.SingleClass);
			for (x = 0; x < CombinedWeaponList.Length; ++x)
			{
				if (PathName(DefArray[i]) ~= PathName(CombinedWeaponList[x].KFWeapDefDual)
					|| SearchString ~= PathName(CombinedWeaponList[x].KFWeapSingle))
				{
					if (CombinedWeaponList[x].KFWeapDefDual == None && CombinedWeaponList[x].KFWeapSingle != None)
					{
						CombinedWeaponList[x].KFWeapDefDual = DefArray[i];
						CombinedWeaponList[x].KFWeapDual = KFWDual;
					}

					break;
				}
			}

			if (x == CombinedWeaponList.Length)
			{
				NewWep.KFWeapDefSingle = None;
				NewWep.KFWeapSingle = None;
				NewWep.KFWeapDefDual = DefArray[i];
				NewWep.KFWeapDual = KFWDual;
				CombinedWeaponList.AddItem(NewWep);
			}
		}
		else
		{
			SearchString = PathName(WepArray[i].default.DualClass);
			for (x = 0; x < CombinedWeaponList.Length; ++x)
			{
				if (PathName(DefArray[i]) ~= PathName(CombinedWeaponList[x].KFWeapDefSingle)
					|| (CombinedWeaponList[x].KFWeapDual != None && SearchString ~= PathName(CombinedWeaponList[x].KFWeapDual)))
				{
					if (CombinedWeaponList[x].KFWeapDefSingle == None && CombinedWeaponList[x].KFWeapDual != None)
					{
						CombinedWeaponList[x].KFWeapDefSingle = DefArray[i];
						CombinedWeaponList[x].KFWeapSingle = WepArray[i];
					}

					break;
				}
			}

			if (x == CombinedWeaponList.Length)
			{
				NewWep.KFWeapDefSingle = DefArray[i];
				NewWep.KFWeapSingle = WepArray[i];
				NewWep.KFWeapDefDual = None;
				NewWep.KFWeapDual = None;
				CombinedWeaponList.AddItem(NewWep);
			}
		}
	}
}

function int CombineWeaponsStartingWeapon(out array<S_Weapon_Data> CombinedWeaponList, out array< class<KFWeaponDefinition> > BaseWepDef,
	out array< class<KFWeapon> > BaseWep)
{
	local int i, Count, Choice;
	local array<int> RandList;

	BaseWepDef.Length = 0;
	BaseWep.Length = 0;

	//Starting Weapons
	for (i = 0; i < ConfigData.StartingWeaponDefObjects.Length; ++i)
	{
		RandList.AddItem(i);
	}
	Count = RandList.Length;
	for (i = 0; i < Min(class'ZedternalReborn.Config_Trader'.static.GetStartingWeaponNumber(GameDifficultyZedternal), Count); ++i)
	{
		Choice = Rand(RandList.Length);
		BaseWepDef.AddItem(ConfigData.StartingWeaponDefObjects[RandList[Choice]]);
		BaseWep.AddItem(ConfigData.StartingWeaponObjects[RandList[Choice]]);
		StartingWeaponPath.AddItem(PathName(BaseWep[i]));
		RandList.Remove(Choice, 1);
	}

	CombineWeapons(CombinedWeaponList, BaseWepDef, BaseWep);

	return BaseWepDef.Length;
}

function CheckWeaponList(out array<S_Weapon_Data> CombinedWeaponList)
{
	local int i;

	if (CombinedWeaponList.Length > 510)
	{
		CombinedWeaponList.Length = 510;
		`log("ZR Warning: Weapon list exceed 510 elements which is not valid for replication."
			@"Trimmed the list down to 510 elements, some weapons defined in the config will never"
			@"be added to the trader because of this change.");
	}

	for (i = 0; i < CombinedWeaponList.Length; ++i)
	{
		if (CombinedWeaponList[i].KFWeapDual != None && CombinedWeaponList[i].KFWeapSingle == None)
		{
			`log("ZR Warning: Dual weapon" @ PathName(CombinedWeaponList[i].KFWeapDual) @ "has no single weapon class tied to it."
				@"Removing the weapon to prevent any issues or any undesirable side effects caused"
				@"by not having the single weapon variant available.");
			CombinedWeaponList.Remove(i, 1);
			--i;
		}
	}
}

function ApplyVariantsAndOverrides(out array<S_Weapon_Data> CombinedWeaponList)
{
	local bool bAllowWeaponVariant;
	local int i;

	bAllowWeaponVariant = class'ZedternalReborn.Config_WeaponVariant'.default.WeaponVariant_bAllowWeaponVariant;

	for (i = 0; i < CombinedWeaponList.Length; ++i)
	{
		if (bAllowWeaponVariant)
			CombinedWeaponList[i] = ApplyRandomWeaponVariant(CombinedWeaponList[i]);

		CombinedWeaponList[i] = CheckForWeaponOverrides(CombinedWeaponList[i]);
	}
}

function S_Weapon_Data ApplyRandomWeaponVariant(S_Weapon_Data WepData)
{
	local int i;
	local string WeapDefinitionPath;

	if (WepData.KFWeapDefSingle == None)
		return WepData;

	WeapDefinitionPath = PathName(WepData.KFWeapDefSingle);
	for (i = 0; i < ConfigData.VariantProbs.Length; ++i)
	{
		if (PathName(ConfigData.VarBaseWeaponDefObjects[i]) ~= WeapDefinitionPath && FRand() <= ConfigData.VariantProbs[i])
		{
			WepData.bVariant = True;
			WepData.KFWeapDefSingleReplace = ConfigData.VarRepWeaponDefObjects[i];
			`log("ZR Info: Replace weapon variant:"@WeapDefinitionPath@"=>"@PathName(WepData.KFWeapDefSingleReplace));

			if (ConfigData.VarDualWeaponDefObjects[i] != None)
			{
				WepData.KFWeapDefDualReplace = ConfigData.VarDualWeaponDefObjects[i];

				if (WepData.KFWeapDefDual != None)
					`log("ZR Info: Replace dual weapon variant:"@PathName(WepData.KFWeapDefDual)@"=>"@PathName(WepData.KFWeapDefDualReplace));
				else
					`log("ZR Info: Added dual weapon variant:"@PathName(WepData.KFWeapDefDualReplace));
			}
		}
	}

	return WepData;
}

// To fix broken weapons using our own overrides, like nailguns
function S_Weapon_Data CheckForWeaponOverrides(S_Weapon_Data WepData)
{
	local byte b;
	local string WeapDefinitionPath;
	local array< class<KFWeaponDefinition> > WeapDefPath;

	if (WepData.bVariant)
	{
		WeapDefPath[0] = WepData.KFWeapDefSingleReplace;
		WeapDefPath[1] = WepData.KFWeapDefDualReplace;
	}
	else
	{
		WeapDefPath[0] = WepData.KFWeapDefSingle;
		WeapDefPath[1] = WepData.KFWeapDefDual;
	}

	for (b = 0; b < 2; ++b)
	{
		if (WeapDefPath[b] == None)
			continue;

		WeapDefinitionPath = PathName(WeapDefPath[b]);

		if (WeapDefinitionPath ~= "KFGame.KFWeapDef_Nailgun")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun", class'Class'));
		else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_Nailgun_HRG")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun_HRG", class'Class'));
		else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_M16M203")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_M16M203", class'Class'));
		else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_HRGIncendiaryRifle")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_HRGIncendiaryRifle", class'Class'));
		else if (WeapDefinitionPath ~= "KFGameContent.KFWeapDef_HRGTeslauncher")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_HRGTeslauncher", class'Class'));
		else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_MedicRifleGrenadeLauncher")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_MedicRifleGrenadeLauncher", class'Class'));
		else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_HRG_BlastBrawlers")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_HRG_BlastBrawlers", class'Class'));
		else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_Doshinegun")
			WeapDefPath[b] = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Doshinegun", class'Class'));

		if (!(WeapDefinitionPath ~= PathName(WeapDefPath[b])))
		{
			`log("ZR Info: Override weapon:"@WeapDefinitionPath@"=>"@PathName(WeapDefPath[b]));
			WepData.bOverride = True;
		}
	}

	if (WepData.bOverride)
	{
		WepData.KFWeapDefSingleReplace = WeapDefPath[0];
		WepData.KFWeapDefDualReplace = WeapDefPath[1];
	}

	return WepData;
}

function SetStartingWeapons(const out array<S_Weapon_Data> CombinedWeaponList)
{
	local int i, x;

	for (i = 0; i < StartingWeaponPath.Length; ++i)
	{
		for (x = 0; x < ConfigData.StaticWeaponDefObjects.Length + StartingWeaponPath.Length; ++x)
		{
			if (StartingWeaponPath[i] ~= PathName(CombinedWeaponList[x].KFWeapSingle))
			{
				if (CombinedWeaponList[x].bVariant || CombinedWeaponList[x].bOverride)
				{
					StartingWeapons.AddItem(CombinedWeaponList[x].KFWeapDefSingleReplace);
					break;
				}
				else
				{
					StartingWeapons.AddItem(CombinedWeaponList[x].KFWeapDefSingle);
					break;
				}
			}
			else if (StartingWeaponPath[i] ~= PathName(CombinedWeaponList[x].KFWeapDual))
			{
				if (CombinedWeaponList[x].bVariant || CombinedWeaponList[x].bOverride)
				{
					if (CombinedWeaponList[x].KFWeapDefDualReplace != None)
					{
						StartingWeapons.AddItem(CombinedWeaponList[x].KFWeapDefDualReplace);
						break;
					}
					else
					{
						StartingWeapons.AddItem(CombinedWeaponList[x].KFWeapDefSingleReplace);
						break;
					}
				}
				else
				{
					StartingWeapons.AddItem(CombinedWeaponList[x].KFWeapDefDual);
					break;
				}
			}
		}
	}

	StartingWeaponPath.Length = 0;
	for (i = 0; i < StartingWeapons.Length; ++i)
	{
		StartingWeaponPath.AddItem(StartingWeapons[i].default.WeaponClassPath);
	}
}

function RegisterWeapons(const out array<S_Weapon_Data> CombinedWeaponList, out array<int> WeaponIndex, int RandStart)
{
	local int i, IDCount;
	local STraderItem NewWeapon;

	IDCount = 0;
	for (i = 0; i < CombinedWeaponList.Length; ++i)
	{
		if (CombinedWeaponList[i].bVariant || CombinedWeaponList[i].bOverride)
			NewWeapon.WeaponDef = CombinedWeaponList[i].KFWeapDefSingleReplace;
		else
			NewWeapon.WeaponDef = CombinedWeaponList[i].KFWeapDefSingle;

		NewWeapon.ItemID = IDCount;
		TraderItems.SaleItems.AddItem(NewWeapon);
		KFWeaponDefPath.AddItem(PathName(NewWeapon.WeaponDef));

		if (IDCount >= RandStart)
			WeaponIndex.AddItem(i);

		++IDCount;
	}

	//Put dual weapons at the end
	for (i = 0; i < CombinedWeaponList.Length; ++i)
	{
		if (CombinedWeaponList[i].bVariant || CombinedWeaponList[i].bOverride)
		{
			if (CombinedWeaponList[i].KFWeapDefDualReplace != None)
			{
				NewWeapon.WeaponDef = CombinedWeaponList[i].KFWeapDefDualReplace;
				NewWeapon.ItemID = IDCount;
				TraderItems.SaleItems.AddItem(NewWeapon);
				KFWeaponDefPath.AddItem(PathName(NewWeapon.WeaponDef));
				++IDCount;
			}
		}
		else
		{
			if (CombinedWeaponList[i].KFWeapDefDual != None)
			{
				NewWeapon.WeaponDef = CombinedWeaponList[i].KFWeapDefDual;
				NewWeapon.ItemID = IDCount;
				TraderItems.SaleItems.AddItem(NewWeapon);
				KFWeaponDefPath.AddItem(PathName(NewWeapon.WeaponDef));
				++IDCount;
			}
		}
	}
}

function AddWeaponInTrader(const class<KFWeaponDefinition> KFWD)
{
	local string str;
	local int i, choice;
	local class<WMUpgrade_Weapon> WMUW;
	local class<KFWeapon> KFW;
	local array< class<WMUpgrade_Weapon> > AllowedUpgrades, StaticUpgrades;
	local WMGameReplicationInfo WMGRI;
	local S_Weapon_Upgrade WepUpg;

	// Add this weapon in KFWeaponName (will be replicated)
	str = KFWD.default.WeaponClassPath;
	KFWeaponName.AddItem(name(Right(str, Len(str) - InStr(str, ".") - 1)));

	// select weapon upgrades
	WMGRI = WMGameReplicationInfo(MyKFGRI);
	KFW = class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'));
	if (WMGRI != None && KFW != None)
	{
		AllowedUpgrades.Length = 0;
		for (i = 0; i < ConfigData.ValidWeaponUpgrades.Length; ++i)
		{
			WMUW = ConfigData.WeaponUpgObjects[i];
			if (WMUW != None && WMUW.static.IsUpgradeCompatible(KFW))
			{
				if (ConfigData.ValidWeaponUpgrades[i].bIsStatic)
					StaticUpgrades.AddItem(WMUW);
				else
					AllowedUpgrades.AddItem(WMUW);
			}
		}

		for (i = 0; i < class'ZedternalReborn.Config_WeaponUpgradeOptions'.default.WeaponUpgrade_NumberUpgradePerWeapon; ++i)
		{
			if (StaticUpgrades.Length > 0)
			{
				WepUpg.KFWeapon = KFW;
				WepUpg.KFWeaponUpgrade = StaticUpgrades[0];
				WepUpg.Price = GetWeaponUpgradePrice(KFWD);

				WeaponUpgradeArch.AddItem(WepUpg);
				StaticUpgrades.Remove(0, 1);
			}
			else if (AllowedUpgrades.Length > 0)
			{
				choice = Rand(AllowedUpgrades.Length);

				WepUpg.KFWeapon = KFW;
				WepUpg.KFWeaponUpgrade = AllowedUpgrades[Choice];
				WepUpg.Price = GetWeaponUpgradePrice(KFWD);

				// add upgrade info into the list
				WeaponUpgradeArch.AddItem(WepUpg);
				AllowedUpgrades.Remove(choice, 1);
			}
		}
	}
}

function int GetWeaponUpgradePrice(const out class<KFWeaponDefinition> KFWD)
{
	local class<KFWeapon> KFW;
	local int unit;

	KFW = class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'));
	unit = class'ZedternalReborn.Config_WeaponUpgradeOptions'.default.WeaponUpgrade_PriceUnit;

	if (KFW.default.DualClass != None) // is a dual weapons
		return Max(unit, Round(float(KFWD.default.BuyPrice) * 2 * class'ZedternalReborn.Config_WeaponUpgradeOptions'.default.WeaponUpgrade_PriceMultiplier / float(unit)) * unit);
	else
		return Max(unit, Round(float(KFWD.default.BuyPrice) * class'ZedternalReborn.Config_WeaponUpgradeOptions'.default.WeaponUpgrade_PriceMultiplier / float(unit)) * unit);
}

function SetTraderItemsAndPrintWeaponList()
{
	local int i;

	//Finishing WeaponList
	TraderItems.SetItemsInfo(TraderItems.SaleItems);
	MyKFGRI.TraderItems = TraderItems;

	`log("ZR Weapon List:");
	for (i = 0; i < KFWeaponName.Length; ++i)
	{
		`log(KFWeaponName[i] $ "(" $ i $ ")");
	}
}

////////
//Weapon Code End
////////

function SelectRandomTraderVoice()
{
	local array<byte> TraderVoiceList;

	//TraderVoiceGroup
	TraderVoiceList.Length = 0;
	if (class'ZedternalReborn.Config_TraderVoice'.default.TraderVoice_bUsePatriarchTrader)
		TraderVoiceList.AddItem(0);
	if (class'ZedternalReborn.Config_TraderVoice'.default.TraderVoice_bUseHansTrader)
		TraderVoiceList.AddItem(1);
	if (class'ZedternalReborn.Config_TraderVoice'.default.TraderVoice_bUseDefaultTrader)
		TraderVoiceList.AddItem(2);
	if (class'ZedternalReborn.Config_TraderVoice'.default.TraderVoice_bUseObjectiveTrader)
		TraderVoiceList.AddItem(3);
	if (class'ZedternalReborn.Config_TraderVoice'.default.TraderVoice_bUseLockheartTrader)
		TraderVoiceList.AddItem(4);
	if (class'ZedternalReborn.Config_TraderVoice'.default.TraderVoice_bUseSantaTrader)
		TraderVoiceList.AddItem(5);

	if (TraderVoiceList.Length > 0)
		TraderVoiceIndex = TraderVoiceList[Rand(TraderVoiceList.Length)];
	else
		TraderVoiceIndex = default.TraderVoiceIndex;
}

function RepGameInfoHighPriority()
{
	local WMGameReplicationInfo WMGRI;
	local int i;

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == None)
		return;

	//Trader voice
	WMGRI.TraderVoiceGroupIndex = TraderVoiceIndex;
	if (WorldInfo.NetMode != NM_DedicatedServer)
		WMGRI.TraderDialogManager.TraderVoiceGroupClass = WMGRI.default.TraderVoiceGroupClasses[TraderVoiceIndex];

	//All traders
	WMGRI.bAllTraders = bUseAllTraders ? 2 : 1; //2 is True, 1 is False;
	if (WorldInfo.NetMode != NM_DedicatedServer && bUseAllTraders)
		WMGRI.SetAllTradersTimer();

	//Optimization
	WMGRI.NumberOfTraderWeapons = Min(510, TraderItems.SaleItems.Length);
	WMGRI.NumberOfPerkUpgrades = Min(255, ConfigData.ValidPerkUpgrades.Length);
	WMGRI.NumberOfStartingWeapons = Min(255, StartingWeaponPath.Length);
	WMGRI.NumberOfSkillUpgrades = Min(255, ConfigData.ValidSkillUpgrades.Length);
	WMGRI.NumberOfWeaponUpgrades = Min(`MAXWEAPONUPGRADES, WeaponUpgradeArch.Length);
	WMGRI.NumberOfEquipmentUpgrades = Min(255, ConfigData.ValidEquipmentUpgrades.Length);
	WMGRI.NumberOfGrenadeItems = Min(255, ConfigData.GrenadeWeaponDefObjects.Length);
	WMGRI.NumberOfSpecialWaves = Min(255, SpecialWaveList.Length);
	WMGRI.NumberOfZedBuffs = Min(255, ConfigData.ZedBuffObjects.Length);

	//Pre-initialize the array size for the sever/standalone
	WMGRI.PerkUpgradesList.Length = WMGRI.NumberOfPerkUpgrades;
	WMGRI.SkillUpgradesList.Length = WMGRI.NumberOfSkillUpgrades;
	WMGRI.WeaponUpgradesList.Length = WMGRI.NumberOfWeaponUpgrades;
	WMGRI.EquipmentUpgradesList.Length = WMGRI.NumberOfEquipmentUpgrades;
	WMGRI.GrenadesList.Length = WMGRI.NumberOfGrenadeItems;
	WMGRI.SpecialWavesList.Length = WMGRI.NumberOfSpecialWaves;
	WMGRI.ZedBuffsList.Length = WMGRI.NumberOfZedBuffs;

	//Get deluxe skill unlocks for perk level purchases
	for (i = 0; i < class'ZedternalReborn.Config_SkillUpgradeOptions'.default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels.Length; ++i)
	{
		WMGRI.bDeluxeSkillUnlock[class'ZedternalReborn.Config_SkillUpgradeOptions'.default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] - 1] = 1;
	}

	//Skill reroll
	WMGRI.bAllowSkillReroll = class'Config_SkillReroll'.default.SkillReroll_bEnable;
	WMGRI.RerollCost = class'Config_SkillReroll'.default.SkillReroll_BasePrice;
	WMGRI.RerollMultiplier = class'Config_SkillReroll'.default.SkillReroll_NextRerollPriceMultiplier;
	WMGRI.RerollSkillSellPercent = class'Config_SkillReroll'.default.SkillReroll_SkillRerollSellPercentage;

	SetTimer(3.0f, False, NameOf(RepGameInfoNormalPriority));
}

function RepGameInfoNormalPriority()
{
	local WMGameReplicationInfo WMGRI;
	local byte b;

	//AmmoPriceFactor
	MyKFGRI.GameAmmoCostScale = class'ZedternalReborn.Config_Trader'.static.GetAmmoPriceMultiplier(GameDifficultyZedternal);

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == None)
		return;

	//Grenades
	for (b = 0; b < Min(255, ConfigData.GrenadeWeaponDefObjects.Length); ++b)
	{
		WMGRI.GrenadesRepArray[b].GrenadePathName = PathName(ConfigData.GrenadeWeaponDefObjects[b]);
		WMGRI.GrenadesRepArray[b].bValid = True;

		WMGRI.GrenadesList[b].Grenade = ConfigData.GrenadeWeaponDefObjects[b];
		WMGRI.GrenadesList[b].bDone = True;
	}

	//Armor pickup enable
	WMGRI.bArmorPickup = class'ZedternalReborn.Config_GameOptions'.static.GetShouldArmorSpawnOnMap(GameDifficultyZedternal) ? 2 : 1; //2 is True, 1 is False

	//Starting/itempickup Weapon
	for (b = 0; b < Min(255, StartingWeaponPath.Length); ++b)
	{
		WMGRI.KFStartingWeaponRepArray[b].WeaponPathName = StartingWeaponPath[b];
		WMGRI.KFStartingWeaponRepArray[b].bValid = True;
	}

	//ZedBuff
	for (b = 0; b < Min(255, ConfigData.ZedBuffObjects.Length); ++b)
	{
		WMGRI.ZedBuffsRepArray[b].ZedBuffPathName = PathName(ConfigData.ZedBuffObjects[b]);
		WMGRI.ZedBuffsRepArray[b].bValid = True;

		WMGRI.ZedBuffsList[b].ZedBuff = ConfigData.ZedBuffObjects[b];
		WMGRI.ZedBuffsList[b].bDone = True;
	}

	//Special Waves
	for (b = 0; b < Min(255, SpecialWaveList.Length); ++b)
	{
		WMGRI.SpecialWavesRepArray[b].SpecialWavePathName = PathName(SpecialWaveList[b]);
		WMGRI.SpecialWavesRepArray[b].bValid = True;

		WMGRI.SpecialWavesList[b].SpecialWave = SpecialWaveList[b];
		WMGRI.SpecialWavesList[b].bDone = True;
	}

	SetTimer(3.0f, False, NameOf(RepGameInfoLowPriority));
}

function RepGameInfoLowPriority()
{
	local WMGameReplicationInfo WMGRI;
	local byte b;
	local int i;

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == None)
		return;

	//Weapons
	for (i = 0; i < Min(255, KFWeaponName.Length); ++i)
	{
		WMGRI.KFWeaponName_A[i] = KFWeaponName[i];
	}
	for (i = 0; i < Min(255, KFWeaponName.Length - 255); ++i)
	{
		WMGRI.KFWeaponName_B[i] = KFWeaponName[i + 255];
	}
	for (i = 0; i < Min(255, KFWeaponDefPath.Length); ++i)
	{
		WMGRI.KFWeaponDefPath_A[i] = KFWeaponDefPath[i];
	}
	for (i = 0; i < Min(255, KFWeaponDefPath.Length - 255); ++i)
	{
		WMGRI.KFWeaponDefPath_B[i] = KFWeaponDefPath[i + 255];
	}

	//Perk Upgrades
	for (b = 0; b < Min(255, ConfigData.ValidPerkUpgrades.Length); ++b)
	{
		WMGRI.PerkUpgradesRepArray[b].PerkPathName = ConfigData.ValidPerkUpgrades[b].PerkPath;
		WMGRI.PerkUpgradesRepArray[b].bValid = True;

		WMGRI.PerkUpgradesList[b].PerkUpgrade = ConfigData.PerkUpgObjects[b];
		WMGRI.PerkUpgradesList[b].bDone = True;
	}

	//Weapon Upgrades for the local standalone/server
	for (i = 0; i < Min(`MAXWEAPONUPGRADES, WeaponUpgradeArch.Length); ++i)
	{
		WMGRI.WeaponUpgradesList[i].KFWeapon = WeaponUpgradeArch[i].KFWeapon;
		WMGRI.WeaponUpgradesList[i].KFWeaponUpgrade = WeaponUpgradeArch[i].KFWeaponUpgrade;
		WMGRI.WeaponUpgradesList[i].BasePrice = WeaponUpgradeArch[i].Price;
		WMGRI.WeaponUpgradesList[i].bDone = True;
	}

	//Weapon Upgrades
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_1, 0);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_2, 1);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_3, 2);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_4, 3);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_5, 4);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_6, 5);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_7, 6);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_8, 7);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_9, 8);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_10, 9);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_11, 10);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_12, 11);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_13, 12);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_14, 13);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_15, 14);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.WeaponUpgradeRepArray_16, 15);

	//Skill Upgrades
	for (b = 0; b < Min(255, ConfigData.ValidSkillUpgrades.Length); ++b)
	{
		WMGRI.SkillUpgradesRepArray[b].SkillPathName = ConfigData.ValidSkillUpgrades[b].SkillPath;
		WMGRI.SkillUpgradesRepArray[b].PerkPathName = ConfigData.ValidSkillUpgrades[b].PerkPath;
		WMGRI.SkillUpgradesRepArray[b].bValid = True;

		WMGRI.SkillUpgradesList[b].SkillUpgrade = ConfigData.SkillUpgObjects[b];
		WMGRI.SkillUpgradesList[b].PerkPathName = ConfigData.ValidSkillUpgrades[b].PerkPath;
		WMGRI.SkillUpgradesList[b].bDone = True;
	}

	//Equipment Upgrades
	for (b = 0; b < Min(255, ConfigData.ValidEquipmentUpgrades.Length); ++b)
	{
		if (ConfigData.ValidEquipmentUpgrades[b].MaxLevel > 0)
		{
			WMGRI.EquipmentUpgradesRepArray[b].EquipmentPathName = ConfigData.ValidEquipmentUpgrades[b].EquipmentPath;
			WMGRI.EquipmentUpgradesRepArray[b].BasePrice = ConfigData.ValidEquipmentUpgrades[b].BasePrice;
			WMGRI.EquipmentUpgradesRepArray[b].MaxPrice = ConfigData.ValidEquipmentUpgrades[b].MaxPrice;
			WMGRI.EquipmentUpgradesRepArray[b].MaxLevel = ConfigData.ValidEquipmentUpgrades[b].MaxLevel;
			WMGRI.EquipmentUpgradesRepArray[b].bValid = True;

			WMGRI.EquipmentUpgradesList[b].EquipmentUpgrade = ConfigData.EquipmentUpgObjects[b];
			WMGRI.EquipmentUpgradesList[b].BasePrice = ConfigData.ValidEquipmentUpgrades[b].BasePrice;
			WMGRI.EquipmentUpgradesList[b].MaxPrice = ConfigData.ValidEquipmentUpgrades[b].MaxPrice;
			WMGRI.EquipmentUpgradesList[b].MaxLevel = ConfigData.ValidEquipmentUpgrades[b].MaxLevel;
			WMGRI.EquipmentUpgradesList[b].bDone = True;
		}
		else
			`log("ZR Info: Equipment upgrade disabled because max level is zero:"@ConfigData.ValidEquipmentUpgrades[b].EquipmentPath);
	}

	//Weapon unlocks
	WMGRI.TraderNewWeaponEachWave = class'ZedternalReborn.Config_Trader'.static.GetNewWeaponEachWave(GameDifficultyZedternal);
	WMGRI.TraderMaxWeaponCount = class'ZedternalReborn.Config_Trader'.static.GetMaxWeapon(GameDifficultyZedternal);
	WMGRI.TraderStaticWeaponCount = ConfigData.StaticWeaponDefObjects.Length;

	//Perks, Skills and Weapons upgrades custom prices
	WMGRI.PerkUpgMaxLevel = class'ZedternalReborn.Config_PerkUpgradeOptions'.default.PerkUpgrade_Price.Length;
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_PerkUpgradeOptions'.default.PerkUpgrade_Price.Length); ++b)
	{
		WMGRI.PerkUpgPrice[b] = class'ZedternalReborn.Config_PerkUpgradeOptions'.default.PerkUpgrade_Price[b];
	}

	WMGRI.SkillUpgPrice = class'ZedternalReborn.Config_SkillUpgradeOptions'.default.SkillUpgrade_Price;
	WMGRI.SkillUpgDeluxePrice = class'ZedternalReborn.Config_SkillUpgradeOptions'.default.SkillUpgrade_DeluxePrice;
	WMGRI.WeaponUpgMaxLevel = class'ZedternalReborn.Config_WeaponUpgradeOptions'.default.WeaponUpgrade_MaxLevel;

	WMGRI.bZRUMenuCommand = class'ZedternalReborn.Config_GameOptions'.static.GetAllowUpgradeCommand(GameDifficultyZedternal);
	WMGRI.bZRUMenuAllWave = class'ZedternalReborn.Config_GameOptions'.static.GetAllowUpgradeCommandAllWave(GameDifficultyZedternal);

	SetTimer(3.0f, False, NameOf(FreeConfigDataMemory));
}

function FreeConfigDataMemory()
{
	// Free memory
	ConfigData = None;
}

function InitializeStaticPerkList()
{
	local byte i;

	StaticPerks.Length = 0;

	for (i = 0; i < Min(255, ConfigData.ValidPerkUpgrades.Length); ++i)
	{
		if (ConfigData.ValidPerkUpgrades[i].bIsStatic)
			StaticPerks.AddItem(1);
		else
			StaticPerks.AddItem(0);
	}
}

function RepPlayerInfo(WMPlayerReplicationInfo WMPRI)
{
	local array<byte> PerkIndex;
	local byte i, Count, Choice;

	`log("ZR Info: Reconnect Player"@WMPRI.PlayerName$":"@WMPRI.NumTimesReconnected);

	if (WMPRI.NumTimesReconnected < 1 && class'ZedternalReborn.Config_PerkUpgradeOptions'.default.PerkUpgrade_AvailablePerks > 0)
	{
		PerkIndex.Length = 0;
		Count = 0;
		for (i = 0; i < StaticPerks.Length; ++i)
		{
			// check if the perk i should be in the trader (static perk)
			if (StaticPerks[i] == 1)
			{
				WMPRI.bPerkUpgradeAvailable[i] = 1;
				++Count;
			}
			else
			{
				PerkIndex.AddItem(i);
				WMPRI.bPerkUpgradeAvailable[i] = 0;
			}

			if (Count > class'ZedternalReborn.Config_PerkUpgradeOptions'.default.PerkUpgrade_AvailablePerks)
			{
				break;
			}
		}

		for (i = 0; i < class'ZedternalReborn.Config_PerkUpgradeOptions'.default.PerkUpgrade_AvailablePerks - Count; ++i)
		{
			if (PerkIndex.Length > 0)
			{
				Choice = Rand(PerkIndex.Length);
				WMPRI.bPerkUpgradeAvailable[PerkIndex[Choice]] = 1;
				PerkIndex.Remove(Choice, 1);
			}
		}
	}
	else if (WMPRI.NumTimesReconnected >= 1)
	{
		WMPRI.UpdateServerPurchase();
		WMPRI.UpdateClientPurchase();
	}
}

function int GetAdjustedDeathPenalty(KFPlayerReplicationInfo KilledPlayerPRI, optional bool bLateJoiner=False)
{
	local int PlayerBase, PlayerWave, PlayerCount, PlayerPerkBonus;
	local KFPlayerController KFPC;

	// new player (dosh is based on what team won during the game)
	if (bLateJoiner)
	{
		PlayerBase = Round(doshNewPlayer * class'ZedternalReborn.Config_Dosh'.static.GetLateJoinerDoshPct(GameDifficultyZedternal));
		`log("ZR Info: Player"@KilledPlayerPRI.PlayerName@"is late joiner, received"@PlayerBase@"dosh");

		return PlayerBase;
	}

	// count current number of players
	PlayerCount = 0;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC.Pawn != None)
			++PlayerCount;
	}

	PlayerBase = class'ZedternalReborn.Config_Dosh'.static.GetBaseWaveDoshReward(GameDifficultyZedternal, PlayerCount);
	PlayerWave = class'ZedternalReborn.Config_Dosh'.static.GetBonusWaveDoshReward(GameDifficultyZedternal, WaveNum);
	PlayerPerkBonus = class'ZedternalReborn.Config_Dosh'.static.GetBonusPlayerLevelDoshReward(GameDifficultyZedternal, WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo).PlayerLevel);

	return Round(float(PlayerBase + PlayerWave + PlayerPerkBonus) * (1.0f - FClamp(class'ZedternalReborn.Config_Dosh'.static.GetDeathPenaltyDoshPct(GameDifficultyZedternal), 0.0f, 1.0f)));
}

function float GetAdjustedAIDoshValue(class<KFPawn_Monster> MonsterClass)
{
	local float TempValue;
	local int PlayerCount;
	local KFPlayerController KFPC;
	local byte i;

	PlayerCount = 0;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC.Pawn != None)
			++PlayerCount;
	}

	TempValue = float(MonsterClass.static.GetDoshValue());
	TempValue *= DifficultyInfo.GetKillCashModifier();

	for (i = 0; i <= 1; ++i)
	{
		if (WMGameReplicationInfo(MyKFGRI).SpecialWaveID[i] != INDEX_NONE)
			TempValue *= WMGameReplicationInfo(MyKFGRI).SpecialWavesList[WMGameReplicationInfo(MyKFGRI).SpecialWaveID[i]].SpecialWave.default.doshFactor;
	}

	if (MonsterClass.default.bLargeZed)
		TempValue *= class'ZedternalReborn.Config_Dosh'.static.GetLargeZedDoshMultiplier(GameDifficultyZedternal, PlayerCount);
	else
		TempValue *= class'ZedternalReborn.Config_Dosh'.static.GetNormalZedDoshMultiplier(GameDifficultyZedternal, PlayerCount);

	return TempValue;
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local byte i, x;
	local int PlayerCount;
	local WMPlayerReplicationInfo KilledPRI;
	local KFPlayerController KFPC;
	local WMSpecialWave WMSW;
	local WMGameReplicationInfo WMGRI;

	super.Killed(Killer, KilledPlayer, KilledPawn, DT);

	if (KilledPlayer != None && KilledPlayer.bIsPlayer)
	{
		KilledPRI = WMPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);
		if (KilledPRI != None)
		{
			KilledPRI.PlayerHealthInt = 0;
			KilledPRI.PlayerHealth = 0;
			KilledPRI.PlayerHealthPercent = 0;
		}
	}

	if (KilledPawn.IsA('KFPawn_Human'))
		bUseExtendedTraderTime = True;

	WMGRI = WMGameReplicationInfo(MyKFGRI);

	if (WMGRI.SpecialWaveID[0] != INDEX_NONE)
	{
		foreach DynamicActors(class'WMSpecialWave', WMSW)
		{
			WMSW.Killed(Killer, KilledPlayer, KilledPawn, DT);
		}
	}

	for (i = 0; i < WMGRI.ZedBuffsList.length; ++i)
	{
		if (WMGRI.ActiveZedBuffs[i] > 0)
		{
			for (x = 0; x < WMGRI.ActiveZedBuffs[i]; ++x)
			{
				WMGRI.ZedBuffsList[i].ZedBuff.static.KilledPawn(KilledPawn);
			}
		}
	}

	PlayerCount = 0;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC.Pawn != None)
			++PlayerCount;
	}

	if (KFPawn_Monster(KilledPawn) != None && PlayerCount != 0)
		doshNewPlayer += GameLengthDoshScale[GameLength] * KFPawn_Monster(KilledPawn).static.GetDoshValue() / PlayerCount;
}

function RewardSurvivingPlayers()
{
	local int PlayerBase, PlayerWave, PlayerCount, PlayerPerkBonus;
	local KFPlayerController KFPC;
	Local KFTeamInfo_Human T;

	PlayerCount = 0;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC.Pawn != None && KFPC.Pawn.IsAliveAndWell())
		{
			++PlayerCount;

			// Find the player's team
			if (T == None && KFPC.PlayerReplicationInfo != None && KFPC.PlayerReplicationInfo.Team != None)
			{
				T = KFTeamInfo_Human(KFPC.PlayerReplicationInfo.Team);
			}
		}
	}

	if (T != None)
	{
		// Reset team score even though we do not use it
		T.AddScore(0, True);
	}

	PlayerBase = class'ZedternalReborn.Config_Dosh'.static.GetBaseWaveDoshReward(GameDifficultyZedternal, PlayerCount);
	PlayerWave = class'ZedternalReborn.Config_Dosh'.static.GetBonusWaveDoshReward(GameDifficultyZedternal, WaveNum);

	`log("ZR Info: SCORING: Number of surviving players:" @ PlayerCount);
	`log("ZR Info: SCORING: Base Dosh/surviving player:" @ PlayerBase);
	`log("ZR Info: SCORING: Wave Dosh/surviving player:" @ PlayerWave);

	// Add dosh for new players
	doshNewPlayer += class'ZedternalReborn.Config_Dosh'.static.GetBaseWaveDoshReward(GameDifficultyZedternal, PlayerCount + 1) + PlayerWave;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC.Pawn != None && KFPC.Pawn.IsAliveAndWell())
		{
			PlayerPerkBonus = class'ZedternalReborn.Config_Dosh'.static.GetBonusPlayerLevelDoshReward(GameDifficultyZedternal, WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo).PlayerLevel);

			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh(PlayerBase + PlayerWave + PlayerPerkBonus, True);

			`log("ZR Info: Player" @ KFPC.PlayerReplicationInfo.PlayerName @ "got" @ PlayerBase + PlayerWave + PlayerPerkBonus @ "dosh for surviving the wave. Player perk level:" @ WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo).PlayerLevel);
		}
	}
}

function CheckZedTimeOnKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	local bool bIsHuman;
	local KFPlayerController KFPC;
	local WMPerk KillersPerk;
	local class<KFDamageType> KFDT;

	KFDT = class<KFDamageType>(DamageType);
	if (KFDT != None && KFDT.default.DoT_Type != DOT_None)
		return;

	if (IsZedTimeActive())
	{
		KFPC = KFPlayerController(Killer);
		if (KFPC != None)
		{
			KillersPerk = WMPerk(KFPC.GetPerk());

			if (ZedTimeRemaining > 0.0f && KillersPerk != None && KillersPerk.GetZedTimeExtensionMax(KFPC.GetLevel()) > ZedTimeExtensionsUsed)
			{
				DramaticEvent(1.0f);
				++ZedTimeExtensionsUsed;
			}
		}
	}
	else
	{
		if (bNVAlwaysDramatic)
			DramaticEvent(1.0f);

		bIsHuman = KilledPawn.IsA('KFPawn_Human');
		if (bIsHuman)
		{
			DramaticEvent(0.05f);
			return;
		}

		if (KilledPawn.Controller == None)
			return;

		if (Killer != None && Killer.Pawn != None && VSizeSq(Killer.Pawn.Location - KilledPawn.Location) < 90000)
			DramaticEvent(0.05f);
		else
			DramaticEvent(0.025f);
	}
}

function InitAllPickups()
{
	if (bDisablePickups || DifficultyInfo == None)
	{
		NumWeaponPickups = 0;
		NumAmmoPickups = 0;
	}
	else
	{
		NumWeaponPickups = Min(FCeil(float(ItemPickups.Length) * DifficultyInfo.GetItemPickupModifier()), ItemPickups.Length);
		NumAmmoPickups = Min(FCeil(float(AmmoPickups.Length) * DifficultyInfo.GetAmmoPickupModifier()), AmmoPickups.Length);
	}

	if (BaseMutator != None)
	{
		BaseMutator.ModifyPickupFactories();
	}

	ResetAllPickups();
}

function ResetAllPickups()
{
	//Skip the KFGameInfo_Survival ResetAllPickups function
	super(KFGameInfo).ResetAllPickups();
}

function ResetPickups(array<KFPickupFactory> PickupList, int NumPickups)
{
	local byte i, ChosenIndex;
	local array<KFPickupFactory> PossiblePickups;

	NumPickups = Clamp(Round(float(NumPickups) * (0.5f + float(WaveNum) * 0.1f)), 0, Round(float(PickupList.Length) * 0.75f));

	PossiblePickups = PickupList;
	for (i = 0; i < NumPickups; ++i)
	{
		if (PossiblePickups.Length > 0)
		{
			ChosenIndex = Rand(PossiblePickups.Length);
			PossiblePickups[ChosenIndex].Reset();
			PossiblePickups.Remove(ChosenIndex, 1);
		}
	}

	// Put any pickup factories that weren't enabled to sleep
	for (i = 0; i < PossiblePickups.Length; ++i)
	{
		PossiblePickups[i].StartSleeping();
	}
}

/** Custom logic to determine what the game's current intensity is */
function byte GetGameIntensityForMusic()
{
	return 255;
}

function bool IsMapObjectiveEnabled()
{
	return class'ZedternalReborn.Config_Objective'.static.GetShouldEnableObjective(GameDifficultyZedternal);
}

/** Adjusts AI pawn default settings by game difficulty and player count */
function SetMonsterDefaults(KFPawn_Monster P)
{
	local float HeadHealthMod, HealthMod, StartingSpeedMod, TotalSpeedMod;
	local int i, LivingPlayerCount;

	LivingPlayerCount = GetLivingPlayerCount();

	HealthMod = 1.0f;
	HeadHealthMod = 1.0f;

	// Scale health, damage, and speed
	DifficultyInfo.GetAIHealthModifier(P, GameDifficulty, LivingPlayerCount, HealthMod, HeadHealthMod);
	P.DifficultyDamageMod = DifficultyInfo.GetAIDamageModifier(P, GameDifficulty, bOnePlayerAtStart);
	StartingSpeedMod = DifficultyInfo.GetAISpeedMod(P, GameDifficulty);
	TotalSpeedMod = GameConductor.CurrentAIMovementSpeedMod * StartingSpeedMod;

	// Scale movement speed
	P.GroundSpeed = P.default.GroundSpeed * TotalSpeedMod;
	P.SprintSpeed = P.default.SprintSpeed * TotalSpeedMod;

	// Store the difficulty adjusted ground speed to restore if we change it elsewhere
	P.NormalGroundSpeed = P.GroundSpeed;
	P.NormalSprintSpeed = P.SprintSpeed;
	P.InitialGroundSpeedModifier = StartingSpeedMod;

	// Scale health by difficulty
	P.Health = P.default.Health * HealthMod;
	if (P.default.HealthMax == 0)
		P.HealthMax = P.default.Health * HealthMod;
	else
		P.HealthMax = P.default.HealthMax * HealthMod;

	P.ApplySpecialZoneHealthMod(HeadHealthMod);
	P.GameResistancePct = DifficultyInfo.GetDamageResistanceModifier(LivingPlayerCount);

	// look for special monster properties that have been enabled by the kismet node
	for (i = 0; i < ArrayCount(SpawnedMonsterProperties); ++i)
	{
		// this property is currently enabled
		if (SpawnedMonsterProperties[i] != 0)
		{
			// do the action associated with that property
			switch (EMonsterProperties(i))
			{
				case EMonsterProperties_Enraged:
					P.SetEnraged(True);
					break;
				case EMonsterProperties_Sprinting:
					P.bSprintOverride = True;
					break;
			}
		}
	}
}

function UpdateGameSettings()
{
	local name SessionName;
	local KFOnlineGameSettings KFGameSettings;
	local int NumHumanPlayers, i;
	local KFGameEngine KFEngine;

	if (WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer)
	{
		if (GameInterface != None)
		{
			KFEngine = KFGameEngine(class'Engine'.static.GetEngine());

			SessionName = PlayerReplicationInfoClass.default.SessionName;

			if (PlayfabInter != None && PlayfabInter.GetGameSettings() != None)
			{
				KFGameSettings = KFOnlineGameSettings(PlayfabInter.GetGameSettings());
				KFGameSettings.bAvailableForTakeover = KFEngine.bAvailableForTakeover;
			}
			else
				KFGameSettings = KFOnlineGameSettings(GameInterface.GetGameSettings(SessionName));

			if (KFGameSettings != None)
			{
				KFGameSettings.Mode = GetGameModeNum();
				KFGameSettings.Difficulty = GameDifficulty;

				if (WaveNum == 0)
				{
					KFGameSettings.bInProgress = False;
					KFGameSettings.CurrentWave = 1;
				}
				else
				{
					KFGameSettings.bInProgress = True;
					KFGameSettings.CurrentWave = WaveNum;
				}

				if (MyKFGRI != None)
					KFGameSettings.NumWaves = MyKFGRI.GetFinalWaveNum();
				else
					KFGameSettings.NumWaves = WaveMax - 1;

				KFGameSettings.OwningPlayerName = class'GameReplicationInfo'.default.ServerName;

				KFGameSettings.NumPublicConnections = MaxPlayersAllowed;
				KFGameSettings.bRequiresPassword = RequiresPassword();
				KFGameSettings.bCustom = bIsCustomGame;
				KFGameSettings.bUsesStats = !IsUnrankedGame();
				KFGameSettings.NumSpectators = NumSpectators;
				if (MyKFGRI != None)
					MyKFGRI.bCustom = bIsCustomGame;

				// Set the map name
				if (WorldInfo.IsConsoleDedicatedServer() || WorldInfo.IsEOSDedicatedServer())
				{
					KFGameSettings.MapName = WorldInfo.GetMapName(True);
					if (GameReplicationInfo != None)
					{
						for (i = 0; i < GameReplicationInfo.PRIArray.Length; ++i)
						{
							if (!GameReplicationInfo.PRIArray[i].bBot && !GameReplicationInfo.PRIArray[i].bOnlySpectator && PlayerController(GameReplicationInfo.PRIArray[i].Owner) != None)
								NumHumanPlayers++;
						}
					}

					KFGameSettings.NumOpenPublicConnections = KFGameSettings.NumPublicConnections - NumHumanPlayers;
				}

				if (PlayfabInter != None && PlayfabInter.IsRegisteredWithPlayfab())
				{
					PlayfabInter.ServerUpdateOnlineGame();
					if (WorldInfo.IsEOSDedicatedServer())
						GameInterface.UpdateOnlineGame(SessionName, KFGameSettings, True);
				}
				else
				{
					//Trigger re-broadcast of game settings
					GameInterface.UpdateOnlineGame(SessionName, KFGameSettings, True);
				}
			}
		}
	}
}

defaultproperties
{
	bIsEndlessGame=True
	MaxGameDifficulty=4
	MaxPlayersAllowed=128
	ReservationTimeout=120
	TraderVoiceIndex=0

	DefaultPawnClass=class'ZedternalReborn.WMPawn_Human'
	DefaultTraderItems=KFGFxObject_TraderItems'GP_Trader_ARCH.DefaultTraderItems'
	DifficultyInfoClass=class'ZedternalReborn.WMGameDifficulty_Endless'
	DifficultyInfoConsoleClass=class'ZedternalReborn.WMGameDifficulty_Endless_Console'
	GameReplicationInfoClass=class'ZedternalReborn.WMGameReplicationInfo'
	HUDType=class'ZedternalReborn.WMGFxScoreBoardWrapper'
	KFGFxManagerClass=class'ZedternalReborn.WMGFxMoviePlayer_Manager'
	PlayerControllerClass=class'ZedternalReborn.WMPlayerController'
	PlayerReplicationInfoClass=class'ZedternalReborn.WMPlayerReplicationInfo'
	SpawnManagerClasses(0)=class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(1)=class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(2)=class'ZedternalReborn.WMAISpawnManager'

	Name="Default__WMGameInfo_Endless"
}
