class WMGameInfo_Endless extends KFGameInfo_Survival
	config(GameEndless);

var KFGFxObject_TraderItems DefaultTraderItems;
var WMGFxObject_TraderItems TraderItems;
var array< name > KFWeaponName;
var array< string > KFWeaponDefPath;
var array< string > KFStartingWeaponPath;
var array < class<KFWeaponDefinition> > PerkStartingWeapon;
var array < class<KFWeaponDefinition> > StaticWeaponList, StartingWeaponList;
var float doshNewPlayer;
var int lastSpecialWaveID_First, lastSpecialWaveID_Second;
var int TimeBetweenWavesDefault, TimeBetweenWavesExtend;
var bool bUseExtendedTraderTime, bUseStartingTraderTime, bUseAllTraders;
var int startingWave, startingTraderTime, startingDosh;
var byte startingMaxPlayerCount, traderVoiceIndex;

var float GameDifficultyZedternal;

struct S_Weapon_Upgrade
{
	var class<KFWeapon> KFWeapon;
	var class<WMUpgrade_Weapon> KFWeaponUpgrade;
	var int Price;
};
var array<S_Weapon_Upgrade> weaponUpgradeArch;


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

	// Optimization
	InitializeStaticAndStartingWeapons();

	//Set all traders toggle
	bUseAllTraders = class'ZedternalReborn.Config_Map'.static.GetAllTraders(WorldInfo.GetMapName(true));

	// Available weapon are random each wave. Need to build the list
	BuildWeaponList();

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
		doshNewPlayer = class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(true));

	lastSpecialWaveID_First = -1;
	lastSpecialWaveID_Second = -1;

	TimeBetweenWaves = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWave(GameDifficultyZedternal);
	TimeBetweenWavesDefault = TimeBetweenWaves;

	TimeBetweenWavesExtend = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWaveHumanDied(GameDifficultyZedternal);
	bUseExtendedTraderTime = false;
	bUseStartingTraderTime = false;
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
	if (AccessControl != none && AccessControl.IsIDBanned(UniqueId))
	{
		`Log(Address@"is banned, rejecting...");
		ErrorMessage = "<Strings:KFGame.KFLocalMessage.BannedFromServerString>";
		return;
	}


	bPerfTesting = ( ParseOption( Options, "AutomatedPerfTesting" ) ~= "1" );
	bSpectator = bPerfTesting || ( ParseOption( Options, "SpectatorOnly" ) ~= "1" ) || ( ParseOption( Options, "CauseEvent" ) ~= "FlyThrough" );

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

	if (MyKFGRI != none && MyKFGRI.AIRemaining > 0)
		bUseExtendedTraderTime = true;

	if (WMPRI != none)
		RepPlayerInfo(WMPRI);

	if (WMPC != none)
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
		WaveNum = class'ZedternalReborn.Config_Map'.static.GetStartingWave(WorldInfo.GetMapName(true));

	MyKFGRI.WaveNum = WaveNum;

	super(KFGameInfo).StartMatch();

	if (WorldInfo.NetMode != NM_Standalone)
	{
		WMGRI = WMGameReplicationInfo(MyKFGRI);
		if (WMGRI != none)
		{
			WMGRI.updateSkins = true;
		}
	}
	else
	{
		class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsStandalone(KFWeaponDefPath);
	}

	if( class'KFGameEngine'.static.CheckNoAutoStart() || class'KFGameEngine'.static.IsEditor() )
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
		if (startingTraderTime > 0 || class'ZedternalReborn.Config_Map'.static.GetStartingTraderTime(WorldInfo.GetMapName(true)) > 0)
			bUseStartingTraderTime = true;
		else
			bUseExtendedTraderTime = true;

		SetupNextTrader();
		GotoState( 'TraderOpen', 'Begin' );

		// update wave modificators
		SetTimer(4.5f, false, NameOf(CheckForPreviousZedBuff));

		// Set next wave objective
		MyKFGRI.DeactivateObjective();
	}

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		KFPC.ClientMatchStarted();
		if (startingDosh >= 0)
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score = startingDosh;
		else
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score = class'ZedternalReborn.Config_Map'.static.GetStartingDosh(WorldInfo.GetMapName(true));
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
	MyKFGRI.bForceNextObjective = false;

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
	if (WMGameReplicationInfo(MyKFGRI) != none)
		WMGameReplicationInfo(MyKFGRI).bNewZedBuff = false;

	//Disable trader dialog
	if (Role == ROLE_Authority && KFGameInfo(WorldInfo.Game) != none && KFGameInfo(WorldInfo.Game).DialogManager != none)
		KFGameInfo(WorldInfo.Game).DialogManager.SetTraderTime(false);

	// first spawn and music are delayed 5 seconds (KFAISpawnManager.TimeUntilNextSpawn == 5 initially), so line up dialog with them;
	// fixes problem of clients not being ready to receive dialog at the instant the match starts;
	SetTimer(5.0f, false, nameof(PlayWaveStartDialog));
}

function WaveEnded(EWaveEndCondition WinCondition)
{
	local WMPlayerController WMPC;

	super.WaveEnded(WinCondition);

	ClearSpecialWave();

	foreach DynamicActors(class'WMPlayerController', WMPC)
	{
		if (WMPerk(WMPC.CurrentPerk) != none)
			WMPerk(WMPC.CurrentPerk).WaveEnd(WMPC);
	}

	if (WinCondition == WEC_WaveWon)
		SetTimer(4.5f, false, nameof(CheckZedBuff));
}

function RestartPlayer(Controller NewPlayer)
{
	local WMPlayerController WMPC;
	local WMPlayerReplicationInfo WMPRI;
	local float TimeOffset;

	Super.RestartPlayer(NewPlayer);

	WMPC = WMPlayerController(NewPlayer);
	WMPRI = WMPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);

	if (WMPC != none && WMPRI != none && !isWaveActive() && WMPRI.NumTimesReconnected > 0)
	{
		TimeOffset = 0;
		if (WMPRI.NumTimesReconnected > 1 && `TimeSince(WMPRI.LastQuitTime) < ReconnectRespawnTime)
		{
			TimeOffset = ReconnectRespawnTime - `TimeSince(WMPRI.LastQuitTime);
		}

		WMPC.DelayedPerkUpdate(TimeOffset);
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
		if (startingWeaponClassDual != none)
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
		if (KFPFID != none)
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
		if (KFPFID != none)
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
		if (OldObjective != none)
		{
			OldObjectiveZones.AddItem(OldObjective);
		}
	}

	//Create new objectives
	for (b = 0; b < OldObjectiveZones.Length; ++b)
	{
		NewObjective = Spawn(class'WMMapObjective_DoshHold');
		if (NewObjective != none)
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
			`log("Failed to override objective "$OldObjectiveZones[b].Name$" due to failure to spawn in new objective actor");
		}
	}

	KFMI = KFMapInfo(WorldInfo.GetMapInfo());
	if (KFMI != none)
	{
		if (KFMI.bUseRandomObjectives)
		{
			KFMI.bUsePresetObjectives = false; //Just in case
			KFMI.RandomWaveObjectives.Length = 0;
			KFMI.RandomWaveObjectives = NewObjectiveZones;
		}
		else
		{
			`log("Not random objectives, currently not supported for ZedternalReborn");
			KFMI.bUsePresetObjectives = false;
		}
	}
}

function CheckZedBuff()
{
	local byte count;

	if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum + 1, count))
		ApplyRandomZedBuff(WaveNum + 1, true, count);
}

// Used when starting match at higher wave
function CheckForPreviousZedBuff()
{
	local int testedWave;
	local byte count;

	for (testedWave = 1; testedWave <= WaveNum + 1; ++testedWave)
	{
		if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(testedWave, count))
			ApplyRandomZedBuff(testedWave, false, count);
	}
}

function ApplyRandomZedBuff(int Wave, bool bRewardPlayer, byte count)
{
	local WMGameReplicationInfo WMGRI;
	local KFPlayerController KFPC;
	local array<byte> buffIndex;
	local byte i, index, doshMultiplier, countOriginal;

	WMGRI = WMGameReplicationInfo(MyKFGRI);

	if (WMGRI != none)
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
			WMGRI.bNewZedBuff = true;
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
					if (KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo) != none)
					{
						KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh(class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(GameDifficultyZedternal) * doshMultiplier, true);
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

	ForEach WorldInfo.AllActors(class'KFGame.KFDoorActor',KFD)
	{
		KFD.ResetDoor();
	}
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
			TimeBetweenWaves = class'ZedternalReborn.Config_Map'.static.GetStartingTraderTime(WorldInfo.GetMapName(true));

		bUseStartingTraderTime = false;
	}
	else if (bUseExtendedTraderTime)
	{
		TimeBetweenWaves = TimeBetweenWavesExtend;
		bUseExtendedTraderTime = false;
	}
	else
		TimeBetweenWaves = TimeBetweenWavesDefault;

	if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum + 1, count))
	{
		WMGRI = WMGameReplicationInfo(MyKFGRI);

		if (WMGRI != none)
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

function BossDied(Controller Killer, optional bool bCheckWaveEnded = true)
{
	CheckWaveEnd();
}

function SetupSpecialWave()
{
	local int index;
	local array< int > SWList;
	local int i;

	SWList.length = 0;

	// Check if it is a special wave. If true, build available special wave list (SWList)
	if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_bAllowed && WaveNum > 0 && FRand() < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_Probability)
	{		
		for (i = 0; i < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves.length; ++i)
		{
			if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].MinWave <= (WaveNum + 1) && class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].MaxWave >= (WaveNum + 1))
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
			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = -1;
			lastSpecialWaveID_Second = -1;
		}

		// if playing solo, trigger special wave visual effect
		if (WorldInfo.NetMode != NM_DedicatedServer)
			WMGameReplicationInfo(MyKFGRI).TriggerSpecialWaveMessage();
		
		SetTimer(5.f, false, nameof(SetSpecialWaveActor));
	}
	else
	{
		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] = -1;
		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = -1;
	}
}

function SetSpecialWaveActor()
{
	local WMPlayerController WMPC;

	if (WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] != -1)
		Spawn(WMGameReplicationInfo(MyKFGRI).specialWaves[WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0]]);
	if (WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] != -1)
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

	for(i = 0; i <= 1; ++i)
	{
		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[i] = -1;
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

function InitializeStaticAndStartingWeapons()
{
	local int i;
	local class<KFWeaponDefinition> KFWeaponDefClass;

	//Optimization: Add static and starting weapons to array for future use, and check if the weapons are valid
	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs.length; ++i)
	{
		KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i], class'Class'));
		if (KFWeaponDefClass != none)
			StaticWeaponList.AddItem(KFWeaponDefClass);
		else
			`log("Static weapon "$class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i]$" does not exist, please check spelling or make sure the workshop item is correctly installed");
	}

	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList.length; ++i)
	{
		KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[i], class'Class'));
		if (KFWeaponDefClass != none)
			StartingWeaponList.AddItem(KFWeaponDefClass);
		else
			`log("Starting weapon "$class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[i]$" does not exist, please check spelling or make sure the workshop item is correctly installed");
	}
}

function BuildWeaponList()
{
	local int i, choice, count;
	local bool bAllowWeaponVariant;
	local array<int> weaponIndex;
	local class<KFWeaponDefinition> KFWeaponDefClass, CustomWeaponDef;
	local STraderItem newWeapon;
	local array< int > tempList;

	weaponIndex.Length = 0;

	TraderItems = new class'WMGFxObject_TraderItems';

	/////////////////////////////
	// Armor and Grenade Price //
	/////////////////////////////
	TraderItems.ArmorPrice = class'ZedternalReborn.Config_Game'.static.GetArmorPrice(GameDifficultyZedternal);
	TraderItems.GrenadePrice = class'ZedternalReborn.Config_Game'.static.GetGrenadePrice(GameDifficultyZedternal);

	if (WMGameReplicationInfo(MyKFGRI) != none)
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

				`log("Custom weapon added: "$class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i]);
			}
			else
			{
				`log("Custom weapon "$class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i]$
					" does not exist, please check spelling or make sure the workshop item is correctly installed");
			}
		}
	}

	//get WeaponVariant Probablity/Allowed
	bAllowWeaponVariant = class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_bAllowWeaponVariant;

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
	for (i = 0; i < min(class'ZedternalReborn.Config_Weapon'.default.Trader_StartingWeaponNumber, count); ++i)
	{
		choice = Rand(tempList.length);
		PerkStartingWeapon[i] = StartingWeaponList[tempList[choice]];
		KFStartingWeaponPath[i] = PerkStartingWeapon[i].default.WeaponClassPath;
		tempList.Remove(choice, 1);
	}

	//adding randomly starting weapon in trader
	for (i = 0; i < PerkStartingWeapon.length; ++i)
	{
		if (bAllowWeaponVariant)
			ApplyRandomWeaponVariant(PathName(PerkStartingWeapon[i]), true);
		else
			CheckForWeaponOverrides(PerkStartingWeapon[i]);
	}

	//adding static weapon in the trader
	for (i = 0; i < StaticWeaponList.length; ++i)
	{
		if (bAllowWeaponVariant)
			ApplyRandomWeaponVariant(PathName(StaticWeaponList[i]), true);
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
			if (KFWeaponDefClass != none)
			{
				if (bAllowWeaponVariant)
					ApplyRandomWeaponVariant(PathName(TraderItems.SaleItems[weaponIndex[choice]].WeaponDef), false, weaponIndex[choice]);
				else
					CheckForWeaponOverrides(TraderItems.SaleItems[weaponIndex[choice]].WeaponDef, weaponIndex[choice]);
			}

			weaponIndex.remove(choice, 1);
		}
	}

	//Finishing WeaponList
	TraderItems.SetItemsInfo(TraderItems.SaleItems);
	MyKFGRI.TraderItems = TraderItems;

	`log("Weapon List : ");
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
	if (WMGRI != none && KFW != none)
	{
		AllowedUpgrades.length = 0;
		for (i = 0; i < class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_WeaponUpgrades.length; ++i)
		{
			WMUW = class<WMUpgrade_Weapon>(DynamicLoadObject(class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_WeaponUpgrades[i], class'Class'));
			if (WMUW != none && WMUW.static.IsUpgradeCompatible(KFW))
				AllowedUpgrades.AddItem(WMUW);
		}
		for (i = 0; i < class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_StaticWeaponUpgrades.length; ++i)
		{
			WMUW = class<WMUpgrade_Weapon>(DynamicLoadObject(class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_StaticWeaponUpgrades[i], class'Class'));
			if (WMUW != none && WMUW.static.IsUpgradeCompatible(KFW))
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

function string FindSingleWeaponFromDual(const out class<KFWeap_DualBase> KFDW)
{
	local int i;
	local string SingleWeaponDef;

	SingleWeaponDef = PathName(KFDW.default.SingleClass);

	for (i = 0; i < TraderItems.SaleItems.Length; ++i)
	{
		if (SingleWeaponDef ~= TraderItems.SaleItems[i].WeaponDef.default.WeaponClassPath)
			return PathName(TraderItems.SaleItems[i].WeaponDef);
	}

	return PathName(KFDW);
}

// To fix broken weapons using our own overrides, like nailguns
function CheckForWeaponOverrides(class<KFWeaponDefinition> KFWD, optional int index = -1)
{
	local string weapDefinitionPath;
	local class<KFWeaponDefinition> overrideWeapon;
	local class<KFWeap_DualBase> KFDualWeaponTemp;

	weapDefinitionPath = PathName(KFWD);

	KFDualWeaponTemp = class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath, class'Class')));
	if (KFDualWeaponTemp != none)
	{
		weapDefinitionPath = FindSingleWeaponFromDual(KFDualWeaponTemp);
		KFWD = class<KFWeaponDefinition>(DynamicLoadObject(weapDefinitionPath, class'Class'));
	}

	if (weapDefinitionPath ~= "KFGame.KFWeapDef_Nailgun")
	{
		overrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun", class'Class'));
	}

	else if (weapDefinitionPath ~= "KFGame.KFWeapDef_Nailgun_HRG")
	{
		overrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun_HRG", class'Class'));
	}


	if (overrideWeapon != none)
	{
		TraderItemsReplacementHelper(weapDefinitionPath, overrideWeapon, false, index);
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

	if (KFW.default.DualClass != none) // is a dual weapons
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
	if (class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWepDef.default.WeaponClassPath, class'Class'))) != none)
		return false;

	// Exclude static weapon (because they are already in the trader)
	for (i = 0; i < StaticWeaponList.length; ++i)
	{
		if (KFWepDef == StaticWeaponList[i])
			return false;

		KFDualWeaponTemp = class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(StaticWeaponList[i].default.WeaponClassPath, class'Class')));
		if (KFDualWeaponTemp != none && KFWepDef.default.WeaponClassPath ~= PathName(KFDualWeaponTemp.default.SingleClass))
			return false;
	}

	// Exclude starting weapons (because they are already in the trader)
	for (i = 0; i < StartingWeaponList.length; ++i)
	{
		if (KFWepDef == StartingWeaponList[i])
			return false;

		KFDualWeaponTemp = class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(StartingWeaponList[i].default.WeaponClassPath, class'Class')));
		if (KFDualWeaponTemp != none && KFWepDef.default.WeaponClassPath ~= PathName(KFDualWeaponTemp.default.SingleClass))
			return false;
	}

	return true;
}

function ApplyRandomWeaponVariant(string weapDefinitionPath, bool shouldNotReplace, optional int index = -1)
{
	local int i, x;
	local class<KFWeaponDefinition> KFWeaponDefClass, KFDualWeaponDefClass;
	local class<KFWeap_DualBase> KFDualWeaponTemp;

	KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(weapDefinitionPath, class'Class'));
	KFDualWeaponTemp = class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWeaponDefClass.default.WeaponClassPath, class'Class')));
	if (KFDualWeaponTemp != none)
		weapDefinitionPath = FindSingleWeaponFromDual(KFDualWeaponTemp);

	KFWeaponDefClass = none;

	if (shouldNotReplace)
		CheckForWeaponOverrides(class<KFWeaponDefinition>(DynamicLoadObject(weapDefinitionPath, class'Class')), index);

	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList.length; ++i)
	{
		if (class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDef ~= weapDefinitionPath && FRand() <= class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].Probability)
		{
			KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDefVariant, class'Class'));
			if (KFWeaponDefClass != none)
			{
				TraderItemsReplacementHelper(weapDefinitionPath, KFWeaponDefClass, shouldNotReplace, index);

				// adding dual weapon class in trader
				if (class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].DualWeaponDefVariant != "")
				{
					KFDualWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].DualWeaponDefVariant, class'Class'));
					if (KFDualWeaponDefClass != none)
					{
						for (x = 0; x < TraderItems.SaleItems.length; ++x)
						{
							if (ClassIsChildOf(KFDualWeaponDefClass, TraderItems.SaleItems[x].WeaponDef))
								break;
						}

						TraderItemsReplacementHelper(PathName(TraderItems.SaleItems[x].WeaponDef), KFDualWeaponDefClass, shouldNotReplace, x, false);
					}
				}

				return;
			}
		}
	}

	if (!shouldNotReplace)
		CheckForWeaponOverrides(class<KFWeaponDefinition>(DynamicLoadObject(weapDefinitionPath, class'Class')), index);
}

function TraderItemsReplacementHelper(string OldWeaponDefPath, const out class<KFWeaponDefinition> NewWeaponDefClass, bool shouldNotReplace, optional int index = -1, optional bool putInTrader = true)
{
	local int i;
	local STraderItem newWeapon;

	if (index < 0 && !shouldNotReplace)
	{
		for (i = 0; i < TraderItems.SaleItems.length; ++i)
		{
			if (PathName(TraderItems.SaleItems[i].WeaponDef) ~= OldWeaponDefPath)
				break;
		}
	}
	else
		i = index;

	newWeapon.WeaponDef = NewWeaponDefClass;
	if (shouldNotReplace)
	{
		newWeapon.ItemID = TraderItems.SaleItems.length;
		TraderItems.SaleItems.AddItem(newWeapon);
	}
	else
	{
		newWeapon.ItemID = i;
		TraderItems.SaleItems[i] = newWeapon;
	}
	
	if (putInTrader)
		AddWeaponInTrader(NewWeaponDefClass);

	if (shouldNotReplace)
		KFWeaponDefPath.AddItem(PathName(newWeapon.WeaponDef)); //for clients
	else
		KFWeaponDefPath[i] = PathName(newWeapon.WeaponDef); //for clients

	// log
	`log("Replace weapon variant : " $ OldWeaponDefPath $ " => " $ PathName(NewWeaponDefClass));
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
		traderVoiceIndex = traderVoiceList[Rand(traderVoiceList.length)];
	else
		traderVoiceIndex = default.traderVoiceIndex;
}

function RepGameInfoHighPriority()
{
	local WMGameReplicationInfo WMGRI;

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == none)
		return;

	//Print game version
	WMGRI.printVersion = true;

	//Trader voice
	WMGRI.TraderVoiceGroupIndex = traderVoiceIndex;
	if (WorldInfo.NetMode != NM_DedicatedServer)
		WMGRI.TraderDialogManager.TraderVoiceGroupClass = WMGRI.default.TraderVoiceGroupClasses[traderVoiceIndex];

	//All traders
	WMGRI.bAllTraders = bUseAllTraders ? 2 : 1; //2 is true, 1 is false;
	if (WorldInfo.NetMode != NM_DedicatedServer && bUseAllTraders)
		WMGRI.SetAllTradersTimer();

	//Optimization
	WMGRI.NumberOfTraderWeapons = Min(510, TraderItems.SaleItems.Length);
	WMGRI.NumberOfStartingWeapons = Min(255, KFStartingWeaponPath.Length);
	WMGRI.NumberOfSkillUpgrades = Min(255, class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades.length);
	WMGRI.NumberOfWeaponUpgrades =  Min(`MAXWEAPONUPGRADES, weaponUpgradeArch.Length);

	//Preinitialize the array size for the sever/standalone
	WMGRI.skillUpgrades.Length = WMGRI.NumberOfSkillUpgrades;
	WMGRI.weaponUpgradeList.Length = WMGRI.NumberOfWeaponUpgrades;

	SetTimer(3.0f, false, 'RepGameInfoNormalPriority');
}

function RepGameInfoNormalPriority()
{
	local WMGameReplicationInfo WMGRI;
	local byte b;

	//AmmoPriceFactor
	MyKFGRI.GameAmmoCostScale = class'ZedternalReborn.Config_Game'.static.GetAmmoPriceFactor(GameDifficultyZedternal);

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == none)
		return;

	//Grenades
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef.length); ++b)
	{
		WMGRI.grenadesStr[b] =	class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef[b];
		WMGRI.Grenades[b] =		class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef[b], class'Class'));
	}

	//Armor pickup enable
	WMGRI.bArmorPickup = class'ZedternalReborn.Config_Game'.default.Game_bArmorSpawnOnMap ? 2 : 1; //2 is true, 1 is false

	//Starting/itempickup Weapon
	for (b = 0; b < Min(255, KFStartingWeaponPath.Length); ++b)
	{
		WMGRI.KFStartingWeaponPath[b] = KFStartingWeaponPath[b];
	}

	//ZedBuff
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath.length); ++b)
	{
		WMGRI.zedBuffStr[b] =	class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[b].Path;
		WMGRI.zedBuffs[b] =		class<WMZedBuff>(DynamicLoadObject(class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[b].Path, class'Class'));
	}

	//Special Waves
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves.length); ++b)
	{
		WMGRI.specialWavesStr[b] =	class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[b].Path;
		WMGRI.specialWaves[b] =		class<WMSpecialWave>(DynamicLoadObject(class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[b].Path, class'Class'));
	}

	SetTimer(3.0f, false, 'RepGameInfoLowPriority');
}

function RepGameInfoLowPriority()
{
	local WMGameReplicationInfo WMGRI;
	local byte b;
	local int i;

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == none)
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
		WMGRI.perkUpgradesStr[b] =	class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[b];
		WMGRI.perkUpgrades[b] =		class<WMUpgrade_Perk>(DynamicLoadObject(class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[b], class'Class'));
	}

	//Weapon Upgrades for the local standalone/server
	for (i = 0; i < Min(`MAXWEAPONUPGRADES, weaponUpgradeArch.Length); ++i)
	{
		WMGRI.weaponUpgradeList[i].KFWeapon = weaponUpgradeArch[i].KFWeapon;
		WMGRI.weaponUpgradeList[i].KFWeaponUpgrade = weaponUpgradeArch[i].KFWeaponUpgrade;
		WMGRI.weaponUpgradeList[i].BasePrice = weaponUpgradeArch[i].Price;
		WMGRI.weaponUpgradeList[i].bDone = true;
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
		WMGRI.skillUpgradesRepArray[b].bValid = true;

		WMGRI.skillUpgrades[b].SkillUpgrade = class<WMUpgrade_Skill>(DynamicLoadObject(class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].SkillPath, class'Class'));
		WMGRI.skillUpgrades[b].PerkPathName = class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].PerkPath;
		WMGRI.skillUpgrades[b].bDone = true;
	}

	//Weapon unlocks
	WMGRI.newWeaponEachWave =	class'ZedternalReborn.Config_Weapon'.default.Trader_NewWeaponEachWave;
	WMGRI.maxWeapon =			class'ZedternalReborn.Config_Weapon'.default.Trader_MaxWeapon;
	WMGRI.staticWeapon =		StaticWeaponList.length;

	//Perks, Skills and Weapons upgrades custom prices
	WMGRI.perkMaxLevel = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price.Length;
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price.length); ++b)
	{
		WMGRI.perkPrice[b] = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price[b];
	}

	WMGRI.skillPrice =			class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_Price;
	WMGRI.skillDeluxePrice =	class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_DeluxePrice;
	WMGRI.weaponMaxLevel =		class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_MaxLevel;
}

function RepPlayerInfo(WMPlayerReplicationInfo WMPRI)
{
	local array<byte> PerkIndex;
	local byte i, j, choice;
	local bool bFound;

	`log("Reconnect : " $WMPRI.NumTimesReconnected);

	if (WMPRI.NumTimesReconnected < 1 && class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_NbAvailablePerks > 0)
	{
		PerkIndex.Length = 0;
		for (i = 0; i < class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades.length; ++i)
		{
			// check if the perk i should be in the trader (fixedPerk)
			bFound = false;
			for (j = 0; j < class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_FixedperkUpgrades.Length; ++j)
			{
				if (class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_FixedperkUpgrades[j] ~= class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[i])
				{
					bFound = true;
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

function int GetAdjustedDeathPenalty( KFPlayerReplicationInfo KilledPlayerPRI, optional bool bLateJoiner=false )
{
	local int PlayerCut;
	local int PlayerCount;
	local int perkBonus;
	local KFPlayerController KFPC;

	// new player (dosh is based on what team won during the game
	if( bLateJoiner )
		return (Round(doshNewPlayer * class'ZedternalReborn.Config_Game'.default.Game_LateJoinerTotalDoshFactor));

	// count current number of players
	PlayerCount = 0;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if(KFPC.Pawn != none)
			++PlayerCount;
	}

	PlayerCut = Round(class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerWavePerPlayer * PlayerCount) + class'ZedternalReborn.Config_Game'.default.Game_DoshPerWavePerPlayer;
	perkBonus = Round(float(Min(WMPlayerReplicationInfo(KilledPlayerPRI).perkLvl, 25) * PlayerCut) / 100.f);
	return Round(float(PlayerCut + perkBonus) * (1.f - FClamp(class'ZedternalReborn.Config_Game'.static.GetDeathPenaltyDoshPct(GameDifficultyZedternal), 0.0f, 1.0f)));
}

function float GetAdjustedAIDoshValue( class<KFPawn_Monster> MonsterClass )
{
	local float TempValue;
	local int PlayerCount;
	local KFPlayerController KFPC;
	local byte i;

	PlayerCount = 0;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if(KFPC.Pawn != none)
			++PlayerCount;
	}

	TempValue = float(MonsterClass.static.GetDoshValue());
	TempValue *= DifficultyInfo.GetKillCashModifier();

	for (i = 0; i <= 1; ++i)
	{
		if (WMGameReplicationInfo(MyKFGRI).SpecialWaveID[i] != -1)
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
	local int PlayerCount;
	local int i;
	local KFPlayerController KFPC;
	local WMSpecialWave WMSW;
	local WMGameReplicationInfo WMGRI;

	super.Killed(Killer, KilledPlayer, KilledPawn, DT);

	if (KilledPawn.IsA('KFPawn_Human'))
		bUseExtendedTraderTime = true;

	WMGRI = WMGameReplicationInfo(MyKFGRI);

	if (WMGRI.SpecialWaveID[0] != -1)
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
		if(KFPC.Pawn != none)
			++PlayerCount;
	}

	if (KFPawn_Monster(KilledPawn) != none && PlayerCount != 0)
		doshNewPlayer += GameLengthDoshScale[GameLength] * KFPawn_Monster(KilledPawn).static.GetDoshValue() / PlayerCount;
}

function ScoreDamage( int DamageAmount, int HealthBeforeDamage, Controller InstigatedBy, Pawn DamagedPawn, class<DamageType> damageType )
{
	super.ScoreDamage(DamageAmount, HealthBeforeDamage, InstigatedBy, DamagedPawn, damageType);
}

function GiveExpToPlayer(Controller Player, int XPValue)
{
}

function RewardSurvivingPlayers()
{
	local int PlayerCut;
	local int PlayerCount;
	local int perkBonus;
	local KFPlayerController KFPC;
	Local KFTeamInfo_Human T;

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if( KFPC.Pawn != none && KFPC.Pawn.IsAliveAndWell() )
		{
			++PlayerCount;

			// Find the player's team
			if( T == none && KFPC.PlayerReplicationInfo != none && KFPC.PlayerReplicationInfo.Team != none )
			{
				T = KFTeamInfo_Human(KFPC.PlayerReplicationInfo.Team);
			}
		}
	}

	// No dosh to distribute if there is no team or score
	if( T == none || T.Score <= 0 )
	{
		return;
	}

	PlayerCut = Round( float(class'ZedternalReborn.Config_Game'.default.Game_ExtraDoshPerWavePerPlayer) * float(PlayerCount) ) + class'ZedternalReborn.Config_Game'.default.Game_DoshPerWavePerPlayer;

	if (bLogScoring) LogInternal("SCORING: Team dosh earned this round:" @ T.Score);
	if (bLogScoring) LogInternal("SCORING: Number of surviving players:" @ PlayerCount);
	if (bLogScoring) LogInternal("SCORING: Dosh/survivng player:" @ PlayerCut);

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if( KFPC.Pawn != none && KFPC.Pawn.IsAliveAndWell() )
		{
			perkBonus = Round(float(Min(WMPlayerReplicationInfo(KFPC.PlayerReplicationInfo).perkLvl, 25) * PlayerCut) / 100.f);
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh(PlayerCut + perkBonus, true);
			doshNewPlayer += (PlayerCut + perkBonus) / PlayerCount;
			T.AddScore( -PlayerCut );

			if (bLogScoring) LogInternal("Player" @ KFPC.PlayerReplicationInfo.PlayerName @ "got" @ PlayerCut @ "for surviving the wave");
		}
	}

	// Reset team score afte the wave ends
	T.AddScore( 0, true );
}

/** Trigger DramaticEvent/ZedTime when pawn is killed */
function CheckZedTimeOnKill(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
	local bool bIsHuman;
	local KFPlayerController KFPC;
	local WMPerk KillersPerk;
	local class<KFDamageType> KFDT;

	// Skip if the damagetype is (or can apply) damage over time
	KFDT = class<KFDamageType>(DamageType);
	if ( KFDT != None && KFDT.default.DoT_Type != DOT_None )
	{
		return;
	}

	// If already in zed time, check for zed time extensions
	if ( IsZedTimeActive() )
	{
		KFPC = KFPlayerController(Killer);
		if ( KFPC != none )
		{
			KillersPerk = WMPerk(KFPC.GetPerk());
			// Handle if someone has a perk with zed time extensions
			if ( ZedTimeRemaining > 0.f && KillersPerk != none && KillersPerk.GetZedTimeExtensionMax( KFPC.GetLevel() ) > ZedTimeExtensionsUsed )
			{
				// Force Zed Time extension for every kill as long as the Player's Perk has Extensions left
				DramaticEvent(1.0);
				++ZedTimeExtensionsUsed;
			}
		}
	}
	else
	{
// NVCHANGE_BEGIN - RLS - Debugging Effects
		if (bNVAlwaysDramatic)
			DramaticEvent(1.0);
// NVCHANGE_END - RLS - Debugging Effects

		// Handle human kills
		bIsHuman = KilledPawn.IsA('KFPawn_Human');
		if ( bIsHuman )
		{
			DramaticEvent(0.05f);
			return;
		}

		if( KilledPawn.Controller == none )
		{
			// don't trigger dramatic event for brain-dead zeds
			return;
		}

		// Handle monster/zed kills - increased probability if closer to the player
		if( Killer != none && Killer.Pawn != none && VSizeSq(Killer.Pawn.Location - KilledPawn.Location) < 90000 ) // 3 meters
		{
			DramaticEvent(0.05);
		}
		else
		{
			DramaticEvent(0.025);
		}
	}
}

function ResetPickups( array<KFPickupFactory> PickupList, int NumPickups )
{
	local byte i, ChosenIndex;
	local array<KFPickupFactory> PossiblePickups;

	NumPickups = max(min(Round(float(NumPickups) * 0.5f) + WaveNum * 2, PickupList.Length - 5), 0);

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

defaultproperties
{
	EndCinematicDelay=4.000000
	AARDisplayDelay=15.000000
	bCanPerkAlwaysChange=False
	ReservationTimeout=120
	DifficultyInfoClass=Class'ZedternalReborn.WMGameDifficulty_Endless'
	DifficultyInfoConsoleClass=Class'kfgamecontent.KFGameDifficulty_Survival_Console'
	MaxGameDifficulty=4
	bIsEndlessGame=True
	MaxPlayersAllowed=128
	SpawnManagerClasses(0)=Class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(1)=Class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(2)=Class'ZedternalReborn.WMAISpawnManager'
	GameplayEventsWriterClass=Class'KFGame.KFGameplayEventsWriter'
	TraderVoiceGroupClass=Class'kfgamecontent.KFTraderVoiceGroup_Default'
	traderVoiceIndex=0

	GameDifficultyZedternal=0.0f
	Name="Default__WMGameInfo_Endless"

	DefaultPawnClass=Class'ZedternalReborn.WMPawn_Human'
	PlayerReplicationInfoClass=Class'ZedternalReborn.WMPlayerReplicationInfo'
	PlayerControllerClass=Class'ZedternalReborn.WMPlayerController'
	KFGFxManagerClass=Class'ZedternalReborn.WMGFxMoviePlayer_Manager'
	GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo'

	DefaultTraderItems=KFGFxObject_TraderItems'GP_Trader_ARCH.DefaultTraderItems'
	HUDType=Class'ZedternalReborn.WMGFxScoreBoardWrapper'
}
