class WMGameInfo_Endless extends KFGameInfo_Survival;

var KFGFxObject_TraderItems DefaultTraderItems;
var WMGFxObject_TraderItems TraderItems;
var array<name> KFWeaponName;
var array<string> KFWeaponDefPath;
var array<string> KFStartingWeaponPath;
var array< class<KFWeaponDefinition> > PerkStartingWeapon;
var array< class<KFWeaponDefinition> > StaticWeaponList, StartingWeaponList;
var float doshNewPlayer;
var int lastSpecialWaveID_First, lastSpecialWaveID_Second;
var int TimeBetweenWavesDefault, TimeBetweenWavesExtend;
var bool bUseExtendedTraderTime, bUseStartingTraderTime, bUseAllTraders;
var int startingWave, startingTraderTime, startingDosh;
var byte startingMaxPlayerCount, TraderVoiceIndex;

var float GameDifficultyZedternal;

struct S_Weapon_Upgrade
{
	var class<KFWeapon> KFWeapon;
	var class<WMUpgrade_Weapon> KFWeaponUpgrade;
	var int Price;
};
var array<S_Weapon_Upgrade> weaponUpgradeArch;

struct S_Special_Wave
{
	var class<WMSpecialWave> SWave;
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


event InitGame(string Options, out string ErrorMessage)
{
	// starting wave can be set through the console while launching the mod (by adding : ?wave=XXX)
	startingWave = Min(class'GameInfo'.static.GetIntOption(Options, "wave", 0) - 1, 254);

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
	local class<KFPawn_Monster> PawnClass;
	local array< class<KFPawn_Monster> > NewClassList;
	local class<KFPawn_Monster> tempClass;
	local int i;

	super.PreloadGlobalContentClasses();

	// find all custom pawnclasses
	NewClassList[0] = default.AIClassList[0];
	for (i = 0; i < class'ZedternalReborn.Config_Zed'.default.Zed_Monsters.length; ++i)
	{
		tempClass = class'ZedternalReborn.Config_Zed'.default.Zed_Monsters[i].MClass;
		if (default.AIClassList.Find(tempClass) == INDEX_NONE && NewClassList.Find(tempClass) == INDEX_NONE)
			NewClassList.AddItem(tempClass);
	}

	for (i = 0; i < class'ZedternalReborn.Config_Zed'.default.Zed_Value.length; ++i)
	{
		tempClass = class'ZedternalReborn.Config_Zed'.default.Zed_Value[i].ZedClass;
		if (default.AIClassList.Find(tempClass) == INDEX_NONE && NewClassList.Find(tempClass) == INDEX_NONE)
			NewClassList.AddItem(tempClass);
	}

	for (i = 0; i < class'ZedternalReborn.Config_Zed'.default.Zed_ZedVariant.length; ++i)
	{
		tempClass = class'ZedternalReborn.Config_Zed'.default.Zed_ZedVariant[i].variantClass;
		if (default.AIClassList.Find(tempClass) == INDEX_NONE && NewClassList.Find(tempClass) == INDEX_NONE)
			NewClassList.AddItem(tempClass);
	}

	// Preload content of custom PawnClass
	foreach NewClassList(PawnClass)
	{
		PawnClass.static.PreloadContent();
	}
}

event PostBeginPlay()
{
	super.PostBeginPlay();

	// Update Default Value
	class'ZedternalReborn.Config_Base'.static.CheckDefaultValue();

	//Set all traders toggle
	bUseAllTraders = class'ZedternalReborn.Config_Map'.static.GetAllTraders(WorldInfo.GetMapName(True));

	// Available weapon are random each wave. Need to build the list
	BuildWeaponList();

	// Setup special wave and overrides
	if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_bAllowed || class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_bAllowed)
		CheckAndSetupSpecialWave();

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
	else
		doshNewPlayer = class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(True));

	lastSpecialWaveID_First = INDEX_NONE;
	lastSpecialWaveID_Second = INDEX_NONE;

	TimeBetweenWaves = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWave(GameDifficultyZedternal);
	TimeBetweenWavesDefault = TimeBetweenWaves;

	TimeBetweenWavesExtend = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWaveHumanDied(GameDifficultyZedternal);
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

	if (GameDifficulty > `DIFFICULTY_HELLONEARTH)
	{
		GameDifficultyZedternal = `DIFFICULTY_ZEDTERNALCUSTOM;
		GameDifficulty = `DIFFICULTY_HELLONEARTH;
	}
	else
		GameDifficultyZedternal = GameDifficulty;

	WaveMax = INDEX_NONE;
	MyKFGRI.WaveMax = WaveMax;
}

function StartMatch()
{
	local KFPlayerController KFPC;
	local WMGameReplicationInfo WMGRI;

	if (startingWave >= 0)
		WaveNum = startingWave;
	else
		WaveNum = class'ZedternalReborn.Config_Map'.static.GetStartingWave(WorldInfo.GetMapName(True));

	MyKFGRI.WaveNum = WaveNum;

	super(KFGameInfo).StartMatch();

	if (WorldInfo.NetMode != NM_Standalone)
	{
		WMGRI = WMGameReplicationInfo(MyKFGRI);
		if (WMGRI != None)
		{
			WMGRI.updateSkins = True;
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
		else
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score = class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(True));
	}
}

function StartWave()
{
	//Closes trader on server
	MyKFGRI.CloseTrader();
	NotifyTraderClosed();

	//Check and set special wave
	SetupSpecialWave();

	//Increment wave
	++WaveNum;
	MyKFGRI.WaveNum = WaveNum;

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
	SetTimer(5.0f, False, NameOf(PlayWaveStartDialog));
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
	local KFPickupFactory_Item KFPFID;
	local array<ItemPickup> StartingItemPickups;
	local class<KFWeapon> startingWeaponClass;
	local class<KFWeap_DualBase> startingWeaponClassDual;
	local ItemPickup newPickup;

	// Set Weapon PickupFactory

	//Add armor
	if (class'ZedternalReborn.Config_Game'.default.Game_bArmorSpawnOnMap)
	{
		newPickup.ItemClass = Class'KFGameContent.KFInventory_Armor';
		StartingItemPickups.AddItem(newPickup);
	}

	//Add 9mm
	newPickup.ItemClass = class'KFGameContent.KFWeap_Pistol_9mm';
	StartingItemPickups.AddItem(newPickup);

	//Add starting weapons
	for (i = 0; i < PerkStartingWeapon.length; ++i)
	{
		startingWeaponClass = class<KFWeapon>(DynamicLoadObject(PerkStartingWeapon[i].default.WeaponClassPath, class'Class'));

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
			if (class'ZedternalReborn.Config_Game'.default.Game_bArmorSpawnOnMap && KFPFID.ItemPickups.length == 1
				&& KFPFID.ItemPickups[0].ItemClass == Class'KFGameContent.KFInventory_Armor')
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
			if (class'ZedternalReborn.Config_Game'.default.Game_bArmorSpawnOnMap && KFPFID.ItemPickups.length == 1
				&& KFPFID.ItemPickups[0].ItemClass == Class'KFGameContent.KFInventory_Armor')
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
			NewObjective.ActivatePctChance = FClamp(class'ZedternalReborn.Config_Objective'.default.Objective_Probability, 0.01f, 1.0f);
			NewObjective.DoshRewardsZedternal = Max(0, class'ZedternalReborn.Config_Objective'.default.Objective_BaseMoney);
			NewObjective.PctOfWaveZedsKilledForMaxRewardZedternal = FClamp(class'ZedternalReborn.Config_Objective'.static.GetPctOfWaveKilledForMaxReward(GameDifficultyZedternal), 0.01f, 1.0f);
			NewObjective.DoshDifficultyScalarZedternal = FMax(0.0f, class'ZedternalReborn.Config_Objective'.static.GetDoshDifficultyModifier(GameDifficultyZedternal));
			NewObjective.DoshDifficultyScalarIncPerWaveZedternal = FMax(0.0f, class'ZedternalReborn.Config_Objective'.static.GetDoshDifficultyModifierIncPerWave(GameDifficultyZedternal));

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

function CheckZedBuff()
{
	local byte count;

	if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum + 1, count))
		ApplyRandomZedBuff(WaveNum + 1, True, count);
}

// Used when starting match at higher wave
function CheckForPreviousZedBuff()
{
	local int testedWave;
	local byte count;

	for (testedWave = 1; testedWave <= WaveNum + 1; ++testedWave)
	{
		if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(testedWave, count))
			ApplyRandomZedBuff(testedWave, False, count);
	}
}

function ApplyRandomZedBuff(int Wave, bool bRewardPlayer, byte count)
{
	local WMGameReplicationInfo WMGRI;
	local KFPlayerController KFPC;
	local array<byte> buffIndex;
	local byte i, index, doshMultiplier, countOriginal;

	WMGRI = WMGameReplicationInfo(MyKFGRI);

	if (WMGRI != None)
	{
		// build available buff list
		for (i = 0; i < Min(255, WMGRI.zedBuffs.length); ++i)
		{
			if (WMGRI.bZedBuffs[i] == 0 && class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[i].minWave <= Wave && class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[i].maxWave >= Wave)
				buffIndex.AddItem(i);
		}

		// select random buff
		if (buffIndex.length > 0)
		{
			countOriginal = count;
			do
			{
				i = Rand(buffIndex.length);
				index = buffIndex[i];
				WMGRI.bZedBuffs[index] = 1;
				buffIndex.Remove(i, 1);
				--count;

				// spawn zedbuff object in world
				Spawn(WMGRI.zedBuffs[index]);
			} until (count <= 0 || buffIndex.Length <= 0);

			// warning players about new buff
			WMGRI.bNewZedBuff = True;
			if (WorldInfo.NetMode != NM_DedicatedServer)
				WMGRI.PlayZedBuffSoundAndEffect();

			// reward players, well, for being good :]
			if (bRewardPlayer)
			{
				if (class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_bBonusDoshGivenPerBuff)
					doshMultiplier = Max(1, countOriginal - Max(0, count));
				else
					doshMultiplier = 1;

				foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
				{
					if (KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo) != None)
					{
						KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh(class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(GameDifficultyZedternal) * doshMultiplier, True);
					}
				}

				doshNewPlayer += class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(GameDifficultyZedternal) * doshMultiplier;
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
		WMGRI.bRepairDoor = !WMGRI.bRepairDoor;
}

function OpenTrader()
{
	local WMGameReplicationInfo WMGRI;
	local byte i, count, timeMultiplier;

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

	if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum + 1, count))
	{
		WMGRI = WMGameReplicationInfo(MyKFGRI);

		if (WMGRI != None)
		{
			//Check to see if any Zed buffs are available
			timeMultiplier = 0;
			for (i = 0; i < Min(255, WMGRI.zedBuffs.length); ++i)
			{
				if (WMGRI.bZedBuffs[i] == 0 && class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[i].minWave <= WaveNum + 1 && class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[i].maxWave >= WaveNum + 1)
					++timeMultiplier;
			}
		}
		else
			timeMultiplier = 1; //If WMGRI is not available, default to 1

		if (class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_bBonusTraderTimeGivenPerBuff)
			timeMultiplier = Min(timeMultiplier, count);
		else
			timeMultiplier = 1;

		TimeBetweenWaves += class'ZedternalReborn.Config_ZedBuff'.static.GetTraderTimeBonus(GameDifficultyZedternal) * timeMultiplier;
	}

	MyKFGRI.OpenTrader(TimeBetweenWaves);
	NotifyTraderOpened();
}

function BossDied(Controller Killer, optional bool bCheckWaveEnded = True)
{
	CheckWaveEnd();
}

function CheckAndSetupSpecialWave()
{
	local int i, j;
	local S_Special_Wave_Override SWO;
	local S_Special_Wave SW;
	local class<WMSpecialWave> WMSW;

	for (i = 0; i < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves.length; ++i)
	{
		WMSW = class<WMSpecialWave>(DynamicLoadObject(class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].Path, class'Class'));

		if (WMSW != None)
		{
			SW.SWave = WMSW;
			SW.MinWave = class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].MinWave;
			SW.MaxWave = class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].MaxWave;

			SpecialWaveObjects.AddItem(SW);
		}
		else
			`log("ZR Warning: Special wave on line"@i + 1@"has an invalid special wave pathname for Path:"@class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].Path);
	}

	for (i = 0; i < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_SpecialWaves.length; ++i)
	{
		SWO.FirstID = INDEX_NONE;
		SWO.SecondID = INDEX_NONE;

		for (j = 0; j < SpecialWaveObjects.length; ++j)
		{
			if (PathName(SpecialWaveObjects[j].SWave) ~= class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_SpecialWaves[i].FirstPath)
				SWO.FirstID = j;

			if (PathName(SpecialWaveObjects[j].SWave) ~= class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_SpecialWaves[i].SecondPath)
				SWO.SecondID = j;

			if (SWO.FirstID != INDEX_NONE && SWO.SecondID != INDEX_NONE)
				break;
		}

		if (SWO.FirstID == INDEX_NONE)
			`log("ZR Warning: Special wave override on line"@i + 1@"has an invalid special wave pathname for FirstPath:"@class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_SpecialWaves[i].FirstPath);

		if (SWO.SecondID == INDEX_NONE)
			`log("ZR Warning: Special wave override on line"@i + 1@"has an invalid special wave pathname for SecondPath:"@class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_SpecialWaves[i].SecondPath);

		if (SWO.FirstID == INDEX_NONE && SWO.SecondID == INDEX_NONE)
			continue;

		SWO.Wave = class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_SpecialWaves[i].Wave;
		SWO.Probability = class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_SpecialWaves[i].Probability;
		SpecialWaveOverrides.AddItem(SWO);
	}
}

function SetupSpecialWave()
{
	local int index;
	local array< int > SWList;
	local int i;

	SWList.length = 0;

	// Check if it is a special wave override. If True, check all available special wave overrides
	if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWaveOverride_bAllowed && WaveNum > 0)
	{
		for (i = 0; i < SpecialWaveOverrides.length; ++i)
		{
			if (SpecialWaveOverrides[i].Wave == (WaveNum + 1) && FRand() < SpecialWaveOverrides[i].Probability)
			{
				if (SpecialWaveOverrides[i].FirstID != INDEX_NONE)
					SWList.AddItem(SpecialWaveOverrides[i].FirstID);

				if (SpecialWaveOverrides[i].SecondID != INDEX_NONE && SpecialWaveOverrides[i].SecondID != SpecialWaveOverrides[i].FirstID)
					SWList.AddItem(SpecialWaveOverrides[i].SecondID);

				break;
			}
		}

		if (SWList.length != 0)
		{
			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] = SWList[0];
			lastSpecialWaveID_First = SWList[0];

			if (SWList.length > 1)
			{
				WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = SWList[1];
				lastSpecialWaveID_Second = SWList[1];
			}
			else
				lastSpecialWaveID_Second = INDEX_NONE;

			// if playing solo, trigger special wave visual effect
			if (WorldInfo.NetMode != NM_DedicatedServer)
				WMGameReplicationInfo(MyKFGRI).TriggerSpecialWaveMessage();

			SetTimer(5.f, False, NameOf(SetSpecialWaveActor));
			return;
		}
	}

	// Check if it is a special wave. If True, build available special wave list (SWList)
	if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_bAllowed && WaveNum > 0 && FRand() < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_Probability)
	{
		for (i = 0; i < SpecialWaveObjects.length; ++i)
		{
			if (SpecialWaveObjects[i].MinWave <= (WaveNum + 1) && SpecialWaveObjects[i].MaxWave >= (WaveNum + 1))
				SWList.AddItem(i);
		}
	}

	// Select a Special Wave from SWList
	if (SWList.length != 0)
	{
		index = Rand(SWList.Length);
		if (lastSpecialWaveID_First == SWList[index] || lastSpecialWaveID_Second == SWList[index])
			index = Rand(SWList.Length); //Re-roll the special wave if it was used recently

		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] = SWList[index];
		lastSpecialWaveID_First = SWList[index];
		SWList.Remove(index, 1);

		// check for a double special wave
		if (SWList.length != 0 && FRand() < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_DoubleProbability)
		{
			index = Rand(SWList.Length);
			if (lastSpecialWaveID_Second == SWList[index] || lastSpecialWaveID_First == SWList[index])
				index = Rand(SWList.Length); //Re-roll the special wave if it was used recently

			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = SWList[index];
			lastSpecialWaveID_Second = SWList[index];
		}
		else
		{
			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = INDEX_NONE;
			lastSpecialWaveID_Second = INDEX_NONE;
		}

		// if playing solo, trigger special wave visual effect
		if (WorldInfo.NetMode != NM_DedicatedServer)
			WMGameReplicationInfo(MyKFGRI).TriggerSpecialWaveMessage();

		SetTimer(5.f, False, NameOf(SetSpecialWaveActor));
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
		Spawn(WMGameReplicationInfo(MyKFGRI).specialWaves[WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0]]);
	if (WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] != INDEX_NONE)
		Spawn(WMGameReplicationInfo(MyKFGRI).specialWaves[WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1]]);

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

function array<int> InitializeTraderItems()
{
	local int count, i;
	local STraderItem newWeapon;
	local class<KFWeaponDefinition> CustomWeaponDef;
	local array<int> weaponIndex;

	//Initialize TraderItems
	TraderItems = new class'WMGFxObject_TraderItems';

	/////////////////////////////
	// Armor and Grenade Price //
	/////////////////////////////
	TraderItems.ArmorPrice = class'ZedternalReborn.Config_Game'.static.GetArmorPrice(GameDifficultyZedternal);
	TraderItems.GrenadePrice = class'ZedternalReborn.Config_Game'.static.GetGrenadePrice(GameDifficultyZedternal);

	if (WMGameReplicationInfo(MyKFGRI) != None)
	{
		WMGameReplicationInfo(MyKFGRI).ArmorPrice = TraderItems.ArmorPrice;
		WMGameReplicationInfo(MyKFGRI).GrenadePrice = TraderItems.GrenadePrice;
	}

	//////////////////////
	// Register Weapons //
	//////////////////////

	//Scan and register all default weapons from the game
	count = 0;
	for (i = 0; i < DefaultTraderItems.SaleItems.Length; ++i)
	{
		newWeapon.WeaponDef = DefaultTraderItems.SaleItems[i].WeaponDef;
		newWeapon.ItemID = count;
		++count;
		TraderItems.SaleItems.AddItem(newWeapon);
		KFWeaponDefPath.AddItem(PathName(newWeapon.WeaponDef)); //for client

		// Add weapons to the list of possible weapons
		if (IsWeaponDefCanBeRandom(DefaultTraderItems.SaleItems[i].WeaponDef))
			weaponIndex[weaponIndex.Length] = count - 1;
	}

	//Add and register custom weapons
	if (class'ZedternalReborn.Config_Weapon'.default.Weapon_bUseCustomWeaponList)
	{
		for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef.length; ++i)
		{
			CustomWeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i], class'Class'));
			if (CustomWeaponDef != None)
			{
				newWeapon.WeaponDef = CustomWeaponDef;
				newWeapon.ItemID = count;
				++count;
				TraderItems.SaleItems.AddItem(newWeapon);
				KFWeaponDefPath.AddItem(PathName(newWeapon.WeaponDef)); //for client

				// Add weapons to the list of possible weapons
				if (IsWeaponDefCanBeRandom(CustomWeaponDef))
					weaponIndex[weaponIndex.Length] = count - 1;

				`log("ZR Info: Custom weapon added:"@class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i]);
			}
			else
			{
				`log("ZR Warning: Custom weapon"@class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i]@
					"does not exist, please check spelling or make sure the workshop item is correctly installed");
			}
		}
	}

	return weaponIndex;
}

function InitializeStaticAndStartingWeapons()
{
	local int i;
	local class<KFWeaponDefinition> KFWeaponDefClass;

	//Optimization: Add static and starting weapons to array for future use, and check if the weapons are valid
	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs.length; ++i)
	{
		KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i], class'Class'));
		if (KFWeaponDefClass != None)
			StaticWeaponList.AddItem(KFWeaponDefClass);
		else
			`log("ZR Warning: Static weapon"@class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i]@"does not exist, please check spelling or make sure the workshop item is correctly installed");
	}

	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList.length; ++i)
	{
		KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[i], class'Class'));
		if (KFWeaponDefClass != None)
			StartingWeaponList.AddItem(KFWeaponDefClass);
		else
			`log("ZR Warning: Starting weapon"@class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[i]@"does not exist, please check spelling or make sure the workshop item is correctly installed");
	}
}

function CheckForStartingWeaponVariants()
{
	local int i;

	for (i = 0; i < StartingWeaponList.Length; ++i)
	{
		StartingWeaponList[i] = ApplyRandomWeaponVariantStartingWeapon(StartingWeaponList[i]);
	}
}

function BuildWeaponList()
{
	local int i, choice, count;
	local bool bAllowWeaponVariant;
	local array<int> weaponIndex;
	local class<KFWeaponDefinition> KFWeaponDefClass;
	local array< int > tempList;

	//get WeaponVariant Probability/Allowed
	bAllowWeaponVariant = class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_bAllowWeaponVariant;

	InitializeStaticAndStartingWeapons();
	weaponIndex = InitializeTraderItems();
	if (bAllowWeaponVariant)
		CheckForStartingWeaponVariants();

	////////////////////////
	// Create weapon list //
	////////////////////////

	weaponUpgradeArch.length = 0;

	//create starting weapon list
	for (i = 0; i < StartingWeaponList.Length; ++i)
	{
		tempList[tempList.length] = i;
	}
	count = tempList.length;
	for (i = 0; i < Min(class'ZedternalReborn.Config_Weapon'.default.Trader_StartingWeaponNumber, count); ++i)
	{
		choice = Rand(tempList.length);
		PerkStartingWeapon[i] = StartingWeaponList[tempList[choice]];
		KFStartingWeaponPath[i] = PerkStartingWeapon[i].default.WeaponClassPath;
		tempList.Remove(choice, 1);
	}

	//adding randomly starting weapon in trader
	for (i = 0; i < PerkStartingWeapon.length; ++i)
	{
		CheckForWeaponOverrides(PerkStartingWeapon[i]);
	}

	//adding static weapon in the trader
	for (i = 0; i < StaticWeaponList.length; ++i)
	{
		if (bAllowWeaponVariant)
			ApplyRandomWeaponVariant(StaticWeaponList[i]);
		else
			CheckForWeaponOverrides(StaticWeaponList[i]);
	}

	//Adding randomly other weapons
	for (i = StaticWeaponList.length + PerkStartingWeapon.Length; i < class'ZedternalReborn.Config_Weapon'.default.Trader_maxWeapon; ++i)
	{
		if (weaponIndex.Length > 0)
		{
			choice = Rand(weaponIndex.Length);
			KFWeaponDefClass = TraderItems.SaleItems[weaponIndex[choice]].WeaponDef;
			if (KFWeaponDefClass != None)
			{
				if (bAllowWeaponVariant)
					ApplyRandomWeaponVariant(TraderItems.SaleItems[weaponIndex[choice]].WeaponDef, weaponIndex[choice]);
				else
					CheckForWeaponOverrides(TraderItems.SaleItems[weaponIndex[choice]].WeaponDef, weaponIndex[choice]);
			}

			weaponIndex.Remove(choice, 1);
		}
	}

	SetTraderItemsAndPrintWeaponList();
}

function SetTraderItemsAndPrintWeaponList()
{
	local int i;

	//Finishing WeaponList
	TraderItems.SetItemsInfo(TraderItems.SaleItems);
	MyKFGRI.TraderItems = TraderItems;

	`log("ZR Weapon List:");
	for (i = 0; i < KFWeaponName.length; ++i)
	{
		`log(KFWeaponName[i] $ "(" $ i $ ")");
	}
}

function AddWeaponInTrader(const out class<KFWeaponDefinition> KFWD)
{
	local string str;
	local int i, choice;
	local class<WMUpgrade_Weapon> WMUW;
	local class<KFWeapon> KFW;
	local array< class<WMUpgrade_Weapon> > AllowedUpgrades, StaticUpgrades;
	local WMGameReplicationInfo WMGRI;
	local S_Weapon_Upgrade tempWUA;

	// Add this weapon in KFWeaponName (will be replicated)
	str = KFWD.default.WeaponClassPath;
	KFWeaponName.AddItem(name(Right(str, Len(str) - InStr(str, ".") - 1)));

	// select weapon upgrades
	WMGRI = WMGameReplicationInfo(MyKFGRI);
	KFW = class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'));
	if (WMGRI != None && KFW != None)
	{
		AllowedUpgrades.length = 0;
		for (i = 0; i < class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_WeaponUpgrades.length; ++i)
		{
			WMUW = class<WMUpgrade_Weapon>(DynamicLoadObject(class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_WeaponUpgrades[i], class'Class'));
			if (WMUW != None && WMUW.static.IsUpgradeCompatible(KFW))
				AllowedUpgrades.AddItem(WMUW);
		}
		for (i = 0; i < class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_StaticWeaponUpgrades.length; ++i)
		{
			WMUW = class<WMUpgrade_Weapon>(DynamicLoadObject(class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_StaticWeaponUpgrades[i], class'Class'));
			if (WMUW != None && WMUW.static.IsUpgradeCompatible(KFW))
				StaticUpgrades.AddItem(WMUW);
		}

		for (i = 0; i < class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_NumberUpgradePerWeapon; ++i)
		{
			if (StaticUpgrades.length > 0)
			{
				tempWUA.KFWeapon = KFW;
				tempWUA.KFWeaponUpgrade = StaticUpgrades[0];
				tempWUA.Price = GetWeaponUpgradePrice(KFWD);

				weaponUpgradeArch.AddItem(tempWUA);
				StaticUpgrades.Remove(0, 1);
			}
			else if (AllowedUpgrades.length > 0)
			{
				choice = Rand(AllowedUpgrades.length);

				tempWUA.KFWeapon = KFW;
				tempWUA.KFWeaponUpgrade = AllowedUpgrades[Choice];
				tempWUA.Price = GetWeaponUpgradePrice(KFWD);

				// add upgrade info into the list
				weaponUpgradeArch.AddItem(tempWUA);
				AllowedUpgrades.Remove(choice, 1);
			}
		}
	}
}

function class<KFWeaponDefinition> FindSingleWeaponFromDual(const out class<KFWeaponDefinition> KFDW)
{
	local int i;
	local string SingleWeaponDef;
	local class<KFWeaponDefinition> WeaponVariantDefClass;
	local class<KFWeap_DualBase> KFWeapDual;

	KFWeapDual = class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFDW.default.WeaponClassPath, class'Class')));
	if (KFWeapDual != None)
		SingleWeaponDef = PathName(KFWeapDual.default.SingleClass);
	else
		return KFDW;

	for (i = 0; i < TraderItems.SaleItems.Length; ++i)
	{
		if (SingleWeaponDef ~= TraderItems.SaleItems[i].WeaponDef.default.WeaponClassPath)
			return TraderItems.SaleItems[i].WeaponDef;
	}

	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList.length; ++i)
	{
		if (PathName(KFDW) ~= class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].DualWeaponDefVariant)
		{
			WeaponVariantDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDefVariant, class'Class'));
			if (WeaponVariantDefClass != None)
				return WeaponVariantDefClass;
		}
	}

	return KFDW;
}

// To fix broken weapons using our own overrides, like nailguns
function CheckForWeaponOverrides(class<KFWeaponDefinition> KFWD, optional int index = INDEX_NONE)
{
	local string WeapDefinitionPath;
	local class<KFWeaponDefinition> OverrideWeapon;

	if (class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'))) != None)
		KFWD = FindSingleWeaponFromDual(KFWD);

	WeapDefinitionPath = PathName(KFWD);

	if (WeapDefinitionPath ~= "KFGame.KFWeapDef_Nailgun")
		OverrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun", class'Class'));
	else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_Nailgun_HRG")
		OverrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun_HRG", class'Class'));
	else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_M16M203")
		OverrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_M16M203", class'Class'));
	else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_HRGIncendiaryRifle")
		OverrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_HRGIncendiaryRifle", class'Class'));
	else if (WeapDefinitionPath ~= "KFGameContent.KFWeapDef_HRGTeslauncher")
		OverrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_HRGTeslauncher", class'Class'));
	else if (WeapDefinitionPath ~= "KFGame.KFWeapDef_MedicRifleGrenadeLauncher")
		OverrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_MedicRifleGrenadeLauncher", class'Class'));

	if (OverrideWeapon != None)
	{
		TraderItemsReplacementHelper(KFWD, OverrideWeapon, index);
		return;
	}

	AddWeaponInTrader(KFWD);
}

function int GetWeaponUpgradePrice(const out class<KFWeaponDefinition> KFWD)
{
	local class<KFWeapon> KFW;
	local int unit;

	KFW = class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'));
	unit = class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_PriceUnit;

	if (KFW.default.DualClass != None) // is a dual weapons
		return Max(unit, Round(float(KFWD.default.BuyPrice) * 2 * class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_PriceFactor / unit) * unit);
	else
		return Max(unit, Round(float(KFWD.default.BuyPrice) * class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_PriceFactor / unit) * unit);
}

function bool IsWeaponDefCanBeRandom(const Class<KFWeaponDefinition> KFWepDef)
{
	local int i;
	local class<KFWeap_DualBase> KFDualWeaponTemp;
	// check if this weapon can be randomly added in the trader during the game

	// Exclude dualWeapon. DualWeapon will be available with singleWeapon
	if (class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWepDef.default.WeaponClassPath, class'Class'))) != None)
		return False;

	// Exclude static weapon (because they are already in the trader)
	for (i = 0; i < StaticWeaponList.length; ++i)
	{
		if (KFWepDef == StaticWeaponList[i])
			return False;

		KFDualWeaponTemp = class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(StaticWeaponList[i].default.WeaponClassPath, class'Class')));
		if (KFDualWeaponTemp != None && KFWepDef.default.WeaponClassPath ~= PathName(KFDualWeaponTemp.default.SingleClass))
			return False;
	}

	// Exclude starting weapons (because they are already in the trader)
	for (i = 0; i < StartingWeaponList.length; ++i)
	{
		if (KFWepDef == StartingWeaponList[i])
			return False;

		KFDualWeaponTemp = class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(StartingWeaponList[i].default.WeaponClassPath, class'Class')));
		if (KFDualWeaponTemp != None && KFWepDef.default.WeaponClassPath ~= PathName(KFDualWeaponTemp.default.SingleClass))
			return False;
	}

	return True;
}

function class<KFWeaponDefinition> ApplyRandomWeaponVariantStartingWeapon(const class<KFWeaponDefinition> KFWD)
{
	local int i, x;
	local bool bIsDual;
	local string WeapDefinitionPath;
	local class<KFWeaponDefinition> WeaponVariantDef, WeaponVariantDualDef, BaseWeaponDef, BaseWeaponDualDef;
	local class<KFWeapon> BaseWeaponClass;
	local STraderItem NewVariantDualWeapon;

	if (class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'))) != None)
	{
		bIsDual = True;
		BaseWeaponDef = FindSingleWeaponFromDual(KFWD);
	}
	else
	{
		bIsDual = False;
		BaseWeaponDef = KFWD;
	}

	WeapDefinitionPath = PathName(BaseWeaponDef);

	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList.length; ++i)
	{
		if (class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDef ~= WeapDefinitionPath && FRand() <= class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].Probability)
		{
			WeaponVariantDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDefVariant, class'Class'));
			if (WeaponVariantDef != None)
			{
				TraderItemsReplacementHelper(BaseWeaponDef, WeaponVariantDef, INDEX_NONE, False);

				//Adding dual weapon class to the trader
				if (class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].DualWeaponDefVariant != "")
				{
					WeaponVariantDualDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].DualWeaponDefVariant, class'Class'));
					if (WeaponVariantDualDef != None)
					{
						//Check the base weapon to see if it has a dual class, if it does then replace the original dual with the variant dual
						BaseWeaponClass = class<KFWeapon>(DynamicLoadObject(BaseWeaponDef.default.WeaponClassPath, class'Class'));
						if (BaseWeaponClass != None && BaseWeaponClass.default.DualClass != None)
						{
							for (x = 0; x < TraderItems.SaleItems.length; ++x)
							{
								if (PathName(BaseWeaponClass.default.DualClass) ~= TraderItems.SaleItems[x].WeaponDef.default.WeaponClassPath)
								{
									BaseWeaponDualDef = TraderItems.SaleItems[x].WeaponDef;
									break;
								}
							}
						}

						if (BaseWeaponDualDef != None)
							TraderItemsReplacementHelper(BaseWeaponDualDef, WeaponVariantDualDef, x, False);
						else
						{
							//Add the dual weapon variant to the end of the TraderItems list
							NewVariantDualWeapon.WeaponDef = WeaponVariantDualDef;
							NewVariantDualWeapon.ItemID = TraderItems.SaleItems.Length;
							TraderItems.SaleItems.AddItem(NewVariantDualWeapon);

							KFWeaponDefPath.AddItem(PathName(NewVariantDualWeapon.WeaponDef)); //for clients

							`log("ZR Info: Added dual weapon variant:"@PathName(WeaponVariantDualDef)@"to the TraderItems");
						}

						if (bIsDual)
							return WeaponVariantDualDef;
					}
				}

				return WeaponVariantDef;
			}
		}
	}

	return KFWD;
}

function ApplyRandomWeaponVariant(class<KFWeaponDefinition> KFWD, optional int index = INDEX_NONE)
{
	local int i, x;
	local string WeapDefinitionPath;
	local class<KFWeaponDefinition> WeaponVariantDef, BaseWeaponDualDef;
	local class<KFWeapon> BaseWeaponClass;
	local STraderItem NewVariantDualWeapon;

	if (class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'))) != None)
		KFWD = FindSingleWeaponFromDual(KFWD);

	WeapDefinitionPath = PathName(KFWD);

	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList.length; ++i)
	{
		if (class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDef ~= WeapDefinitionPath && FRand() <= class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].Probability)
		{
			WeaponVariantDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDefVariant, class'Class'));
			if (WeaponVariantDef != None)
			{
				TraderItemsReplacementHelper(KFWD, WeaponVariantDef, index);

				//Adding dual weapon class to the trader
				if (class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].DualWeaponDefVariant != "")
				{
					WeaponVariantDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].DualWeaponDefVariant, class'Class'));
					if (WeaponVariantDef != None)
					{
						//Check the base weapon to see if it has a dual class, if it does then replace the original dual with the variant dual
						BaseWeaponClass = class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class'));
						if (BaseWeaponClass != None && BaseWeaponClass.default.DualClass != None)
						{
							for (x = 0; x < TraderItems.SaleItems.length; ++x)
							{
								if (PathName(BaseWeaponClass.default.DualClass) ~= TraderItems.SaleItems[x].WeaponDef.default.WeaponClassPath)
								{
									BaseWeaponDualDef = TraderItems.SaleItems[x].WeaponDef;
									break;
								}
							}
						}

						if (BaseWeaponDualDef != None)
							TraderItemsReplacementHelper(BaseWeaponDualDef, WeaponVariantDef, x, False);
						else
						{
							//Add the dual weapon variant to the end of the TraderItems list
							NewVariantDualWeapon.WeaponDef = WeaponVariantDef;
							NewVariantDualWeapon.ItemID = TraderItems.SaleItems.Length;
							TraderItems.SaleItems.AddItem(NewVariantDualWeapon);

							KFWeaponDefPath.AddItem(PathName(NewVariantDualWeapon.WeaponDef)); //for clients

							`log("ZR Info: Added dual weapon variant:"@PathName(WeaponVariantDef)@"to the TraderItems");
						}
					}
				}

				return;
			}
		}
	}

	CheckForWeaponOverrides(KFWD, index);
}

function TraderItemsReplacementHelper(const out class<KFWeaponDefinition> OldWeaponDefClass, const out class<KFWeaponDefinition> NewWeaponDefClass, optional int index = INDEX_NONE, optional bool putInTrader = True)
{
	local int i;
	local STraderItem newWeapon;

	if (index < 0)
	{
		for (i = 0; i < TraderItems.SaleItems.length; ++i)
		{
			if (PathName(TraderItems.SaleItems[i].WeaponDef) ~= PathName(OldWeaponDefClass))
				break;
		}
	}
	else
		i = index;

	newWeapon.WeaponDef = NewWeaponDefClass;
	newWeapon.ItemID = i;
	TraderItems.SaleItems[i] = newWeapon;

	if (putInTrader)
		AddWeaponInTrader(NewWeaponDefClass);

	KFWeaponDefPath[i] = PathName(newWeapon.WeaponDef); //for clients

	// log
	`log("ZR Info: Replace weapon variant:"@PathName(OldWeaponDefClass)@"=>"@PathName(NewWeaponDefClass));
}

function SelectRandomTraderVoice()
{
	local array< byte > traderVoiceList;

	//TraderVoiceGroup
	traderVoiceList.length = 0;
	if (class'ZedternalReborn.Config_Game'.default.Game_bUseDefaultTraderVoice)
		traderVoiceList.AddItem(0);
	if (class'ZedternalReborn.Config_Game'.default.Game_bUsePatriarchTraderVoice)
		traderVoiceList.AddItem(1);
	if (class'ZedternalReborn.Config_Game'.default.Game_bUseHansTraderVoice)
		traderVoiceList.AddItem(2);
	if (class'ZedternalReborn.Config_Game'.default.Game_bUseLockheartTraderVoice)
		traderVoiceList.AddItem(3);
	if (class'ZedternalReborn.Config_Game'.default.Game_bUseSantaTraderVoice)
		traderVoiceList.AddItem(4);

	if (traderVoiceList.length > 0)
		TraderVoiceIndex = traderVoiceList[Rand(traderVoiceList.length)];
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
	WMGRI.NumberOfStartingWeapons = Min(255, KFStartingWeaponPath.Length);
	WMGRI.NumberOfSkillUpgrades = Min(255, class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades.length);
	WMGRI.NumberOfWeaponUpgrades = Min(`MAXWEAPONUPGRADES, weaponUpgradeArch.Length);
	WMGRI.NumberOfEquipmentUpgrades = Min(255, class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades.length);

	//Pre-initialize the array size for the sever/standalone
	WMGRI.skillUpgrades.Length = WMGRI.NumberOfSkillUpgrades;
	WMGRI.weaponUpgradeList.Length = WMGRI.NumberOfWeaponUpgrades;
	WMGRI.equipmentUpgrades.Length = WMGRI.NumberOfEquipmentUpgrades;

	//Get deluxe skill unlocks for perk level purchases
	for (i = 0; i < class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels.length; ++i)
	{
		if (class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] > 0 &&
			class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] < 256)
			WMGRI.bDeluxeSkillUnlock[class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_DeluxeSkillUnlock.PerkLevels[i] - 1] = 1;
	}

	//Skill reroll
	WMGRI.bAllowSkillReroll = class'Config_PerkUpgrade'.default.PerkUpgrade_bAllowSkillReroll;
	WMGRI.RerollCost = class'Config_PerkUpgrade'.default.PerkUpgrade_SkillRerollCost.BasePrice;
	WMGRI.RerollMultiplier = FMax(class'Config_PerkUpgrade'.default.PerkUpgrade_SkillRerollCost.NextRerollMultiplier, 1.0f);
	WMGRI.RerollSkillSellPercent = FClamp(class'Config_PerkUpgrade'.default.PerkUpgrade_SkillRerollSellPercentage, 0.0f, 1.0f);

	SetTimer(3.0f, False, NameOf(RepGameInfoNormalPriority));
}

function RepGameInfoNormalPriority()
{
	local WMGameReplicationInfo WMGRI;
	local byte b;

	//AmmoPriceFactor
	MyKFGRI.GameAmmoCostScale = class'ZedternalReborn.Config_Game'.static.GetAmmoPriceFactor(GameDifficultyZedternal);

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == None)
		return;

	//Grenades
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef.length); ++b)
	{
		WMGRI.grenadesStr[b] = class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef[b];
		WMGRI.Grenades[b] = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef[b], class'Class'));
	}

	//Armor pickup enable
	WMGRI.bArmorPickup = class'ZedternalReborn.Config_Game'.default.Game_bArmorSpawnOnMap ? 2 : 1; //2 is True, 1 is False

	//Starting/itempickup Weapon
	for (b = 0; b < Min(255, KFStartingWeaponPath.Length); ++b)
	{
		WMGRI.KFStartingWeaponPath[b] = KFStartingWeaponPath[b];
	}

	//ZedBuff
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath.length); ++b)
	{
		WMGRI.zedBuffStr[b] = class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[b].Path;
		WMGRI.zedBuffs[b] = class<WMZedBuff>(DynamicLoadObject(class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[b].Path, class'Class'));
	}

	//Special Waves
	for (b = 0; b < Min(255, SpecialWaveObjects.length); ++b)
	{
		WMGRI.specialWavesStr[b] = PathName(SpecialWaveObjects[b].SWave);
		WMGRI.specialWaves[b] = SpecialWaveObjects[b].SWave;
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
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_perkUpgrades.length); ++b)
	{
		WMGRI.perkUpgradesStr[b] = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[b];
		WMGRI.perkUpgrades[b] = class<WMUpgrade_Perk>(DynamicLoadObject(class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[b], class'Class'));
	}

	//Weapon Upgrades for the local standalone/server
	for (i = 0; i < Min(`MAXWEAPONUPGRADES, weaponUpgradeArch.Length); ++i)
	{
		WMGRI.weaponUpgradeList[i].KFWeapon = weaponUpgradeArch[i].KFWeapon;
		WMGRI.weaponUpgradeList[i].KFWeaponUpgrade = weaponUpgradeArch[i].KFWeaponUpgrade;
		WMGRI.weaponUpgradeList[i].BasePrice = weaponUpgradeArch[i].Price;
		WMGRI.weaponUpgradeList[i].bDone = True;
	}

	//Weapon Upgrades
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_1, 0);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_2, 1);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_3, 2);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_4, 3);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_5, 4);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_6, 5);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_7, 6);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_8, 7);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_9, 8);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_10, 9);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_11, 10);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_12, 11);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_13, 12);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_14, 13);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_15, 14);
	WMGRI.RepGameInfoWeaponUpgrades(WMGRI.weaponUpgradeRepArray_16, 15);

	//Skill Upgrades
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades.length); ++b)
	{
		WMGRI.skillUpgradesRepArray[b].SkillPathName = class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].SkillPath;
		WMGRI.skillUpgradesRepArray[b].PerkPathName = class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].PerkPath;
		WMGRI.skillUpgradesRepArray[b].bValid = True;

		WMGRI.skillUpgrades[b].SkillUpgrade = class<WMUpgrade_Skill>(DynamicLoadObject(class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].SkillPath, class'Class'));
		WMGRI.skillUpgrades[b].PerkPathName = class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].PerkPath;
		WMGRI.skillUpgrades[b].bDone = True;
	}

	//Equipment Upgrades
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades.length); ++b)
	{
		if (class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].MaxLevel > 0)
		{
			WMGRI.equipmentUpgradesRepArray[b].EquipmentPathName = class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].EquipmentPath;
			WMGRI.equipmentUpgradesRepArray[b].BasePrice = class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].BasePrice;
			WMGRI.equipmentUpgradesRepArray[b].MaxPrice = class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].MaxPrice;
			WMGRI.equipmentUpgradesRepArray[b].MaxLevel = Clamp(class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].MaxLevel, 0, 255);
			WMGRI.equipmentUpgradesRepArray[b].bValid = True;

			WMGRI.equipmentUpgrades[b].EquipmentUpgrade = class<WMUpgrade_Equipment>(DynamicLoadObject(class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].EquipmentPath, class'Class'));
			WMGRI.equipmentUpgrades[b].BasePrice = class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].BasePrice;
			WMGRI.equipmentUpgrades[b].MaxPrice = class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].MaxPrice;
			WMGRI.equipmentUpgrades[b].MaxLevel = Clamp(class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].MaxLevel, 0, 255);
			WMGRI.equipmentUpgrades[b].bDone = True;
		}
		else
			`log("ZR Info: Equipment upgrade disabled because max level is zero:"@class'ZedternalReborn.Config_EquipmentUpgrade'.default.EquipmentUpgrade_EquipmentUpgrades[b].EquipmentPath);
	}

	//Weapon unlocks
	WMGRI.newWeaponEachWave = class'ZedternalReborn.Config_Weapon'.default.Trader_NewWeaponEachWave;
	WMGRI.maxWeapon = class'ZedternalReborn.Config_Weapon'.default.Trader_MaxWeapon;
	WMGRI.staticWeapon = StaticWeaponList.length;

	//Perks, Skills and Weapons upgrades custom prices
	WMGRI.perkMaxLevel = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price.Length;
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price.length); ++b)
	{
		WMGRI.perkPrice[b] = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price[b];
	}

	WMGRI.skillPrice = class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_Price;
	WMGRI.skillDeluxePrice = class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_DeluxePrice;
	WMGRI.weaponMaxLevel = class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_MaxLevel;

	WMGRI.bZRUMenuCommand = class'ZedternalReborn.Config_Game'.default.Game_bAllowZedternalUpgradeMenuCommand;
	WMGRI.bZRUMenuAllWave = class'ZedternalReborn.Config_Game'.default.Game_bZedternalUpgradeMenuCommandAllWave;
}

function RepPlayerInfo(WMPlayerReplicationInfo WMPRI)
{
	local array<byte> PerkIndex;
	local byte i, j, choice;
	local bool bFound;

	`log("ZR Info: Reconnect Player"@WMPRI.PlayerName$":"@WMPRI.NumTimesReconnected);

	if (WMPRI.NumTimesReconnected < 1 && class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_NbAvailablePerks > 0)
	{
		PerkIndex.Length = 0;
		for (i = 0; i < class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades.length; ++i)
		{
			// check if the perk i should be in the trader (fixedPerk)
			bFound = False;
			for (j = 0; j < class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_FixedperkUpgrades.Length; ++j)
			{
				if (class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_FixedperkUpgrades[j] ~= class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[i])
				{
					bFound = True;
					WMPRI.bPerkUpgradeAvailable[i] = 1;
					j = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_FixedperkUpgrades.Length;
				}
			}
			if (!bFound)
			{
				PerkIndex[PerkIndex.Length] = i;
				WMPRI.bPerkUpgradeAvailable[i] = 0;
			}
		}

		for (i = 0; i < class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_NbAvailablePerks - class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_FixedperkUpgrades.Length; ++i)
		{
			if (PerkIndex.Length > 0)
			{
				choice = Rand(PerkIndex.Length);
				WMPRI.bPerkUpgradeAvailable[PerkIndex[choice]] = 1;
				PerkIndex.remove(choice, 1);
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
		PlayerBase = Round(doshNewPlayer * class'ZedternalReborn.Config_Game'.default.Game_LateJoinerTotalDoshFactor);
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

	PlayerBase = class'ZedternalReborn.Config_Game'.default.Game_DoshPerWavePerPlayer + (class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerWavePerPlayer * PlayerCount);
	PlayerWave = WaveNum * class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshWaveBonusMultiplier;

	PlayerPerkBonus = 0;
	if (class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusDivider > 0 && class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusMaxThreshold > 0)
	{
		PlayerPerkBonus = Min(WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo).PlayerLevel, class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusMaxThreshold)
		* class'ZedternalReborn.Config_Game'.default.Game_DoshPerWavePerPlayer
		/ (class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusDivider * class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusMaxThreshold);
	}

	return Round(float(PlayerBase + PlayerWave + PlayerPerkBonus) * (1.0f - FClamp(class'ZedternalReborn.Config_Game'.static.GetDeathPenaltyDoshPct(GameDifficultyZedternal), 0.0f, 1.0f)));
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
			TempValue *= WMGameReplicationInfo(MyKFGRI).specialWaves[WMGameReplicationInfo(MyKFGRI).SpecialWaveID[i]].default.doshFactor;
	}

	if (MonsterClass.default.bLargeZed)
	{
		TempValue *= class'ZedternalReborn.Config_Game'.static.GetLargeZedDoshFactor(GameDifficultyZedternal);
		if (PlayerCount > 1)
			tempValue *= (1.f + (PlayerCount - 1) * class'ZedternalReborn.Config_Game'.default.Game_ExtraLargeZedDoshFactorPerPlayer);
	}
	else
	{
		TempValue *= class'ZedternalReborn.Config_Game'.static.GetNormalZedDoshFactor(GameDifficultyZedternal);
		if (PlayerCount > 1)
			tempValue *= (1.f + (PlayerCount - 1) * class'ZedternalReborn.Config_Game'.default.Game_ExtraNormalZedDoshFactorPerPlayer);
	}

	return TempValue;
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DT)
{
	local WMPlayerReplicationInfo KilledPRI;
	local KFPlayerController KFPC;
	local WMSpecialWave WMSW;
	local WMGameReplicationInfo WMGRI;
	local int i, PlayerCount;

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

	for (i = 0; i < WMGRI.zedBuffs.length; ++i)
	{
		if (WMGRI.bZedBuffs[i] > 0)
		{
			WMGRI.zedBuffs[i].static.KilledPawn(KilledPawn);
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

	PlayerBase = class'ZedternalReborn.Config_Game'.default.Game_DoshPerWavePerPlayer + (class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerWavePerPlayer * PlayerCount);
	PlayerWave = WaveNum * class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshWaveBonusMultiplier;

	`log("ZR Info: SCORING: Number of surviving players:" @ PlayerCount);
	`log("ZR Info: SCORING: Base Dosh/survivng player:" @ PlayerBase);
	`log("ZR Info: SCORING: Wave Dosh/survivng player:" @ PlayerWave);

	// Add dosh for new players
	doshNewPlayer += PlayerBase + class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerWavePerPlayer + PlayerWave;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if (KFPC.Pawn != None && KFPC.Pawn.IsAliveAndWell())
		{
			PlayerPerkBonus = 0;
			if (class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusDivider > 0 && class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusMaxThreshold > 0)
			{
				PlayerPerkBonus = Min(WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo).PlayerLevel, class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusMaxThreshold)
				* class'ZedternalReborn.Config_Game'.default.Game_DoshPerWavePerPlayer
				/ (class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusDivider * class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerkBonusMaxThreshold);
			}

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
	return class'ZedternalReborn.Config_Objective'.default.Objective_bEnable;
}

/** Adjusts AI pawn default settings by game difficulty and player count */
function SetMonsterDefaults(KFPawn_Monster P)
{
	local float HeadHealthMod, HealthMod, StartingSpeedMod, TotalSpeedMod;
	local int i, LivingPlayerCount;

	LivingPlayerCount = GetLivingPlayerCount();

	HealthMod = 1.0f;
	HeadHealthMod = 1.0f;

	// Scale speed back for omega/special zeds
	if (P.bVersusZed)
		StartingSpeedMod = DifficultyInfo.GetAISpeedMod(P, GameDifficulty) * 0.7f;
	else
		StartingSpeedMod = DifficultyInfo.GetAISpeedMod(P, GameDifficulty);

	// Scale health, damage, and speed
	DifficultyInfo.GetAIHealthModifier(P, GameDifficulty, LivingPlayerCount, HealthMod, HeadHealthMod);
	P.DifficultyDamageMod = DifficultyInfo.GetAIDamageModifier(P, GameDifficulty, bOnePlayerAtStart);
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

defaultproperties
{
	bForceMapSorting=False
	bIsEndlessGame=True
	GameDifficultyZedternal=0.0f
	MaxGameDifficulty=4
	MaxPlayersAllowed=128
	ReservationTimeout=120
	TraderVoiceIndex=0

	DefaultPawnClass=Class'ZedternalReborn.WMPawn_Human'
	DefaultTraderItems=KFGFxObject_TraderItems'GP_Trader_ARCH.DefaultTraderItems'
	DifficultyInfoClass=Class'ZedternalReborn.WMGameDifficulty_Endless'
	DifficultyInfoConsoleClass=Class'ZedternalReborn.WMGameDifficulty_Endless_Console'
	GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo'
	HUDType=Class'ZedternalReborn.WMGFxScoreBoardWrapper'
	KFGFxManagerClass=Class'ZedternalReborn.WMGFxMoviePlayer_Manager'
	PlayerControllerClass=Class'ZedternalReborn.WMPlayerController'
	PlayerReplicationInfoClass=Class'ZedternalReborn.WMPlayerReplicationInfo'
	SpawnManagerClasses(0)=Class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(1)=Class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(2)=Class'ZedternalReborn.WMAISpawnManager'

	Name="Default__WMGameInfo_Endless"
}
