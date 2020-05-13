class WMGameInfo_Endless extends KFGameInfo_Survival
	config(GameEndless);

var KFGFxObject_TraderItems DefaultTraderItems, TraderItems;
var array< name > KFWeaponName;
var array< string > KFWeaponDefPath;
var array< string > KFStartingWeaponPath;
var array < class<KFWeaponDefinition> > PerkStartingWeapon;
var float doshNewPlayer;
var int lastSpecialWaveID;
var int TimeBetweenWavesDefault;
var int TimeBetweenWavesExtend;
var bool bUseExtendedTraderTime;
var int startingWave;
var int startingDosh;
var byte traderVoiceIndex;

var float CustomDifficulty;
var bool CustomMode;

struct S_Weapon_Upgrade
{
	var class<KFWeapon> KFWeapon;
	var class<WMUpgrade_Weapon> KFWeaponUpgrade;
	var int Price;
};
var array<S_Weapon_Upgrade> weaponUpgradeArch;


event InitGame( string Options, out string ErrorMessage )
{
	// starting wave can be set through the console while launching the mod (by adding : ?wave=XXX)
	startingWave = Min(Max(class'GameInfo'.static.GetIntOption(Options, "wave", 1) - 1, 0), 199);

	// starting dosh can be set through the console while launching the mod (by adding : ?dosh=XXX)
	startingDosh = class'GameInfo'.static.GetIntOption(Options, "dosh", 0);


	Super.InitGame( Options, ErrorMessage );
	GameLength = 2;
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

	// Available weapon are random each wave. Need to build the list
	BuildWeaponList();

	// Select Trader voice
	SelectRandomTraderVoice();

	// Replicate new information from this game mode (weapon list, skill, monster...)
	SetTimer(5.f, false, 'RepGameInfo');

	if (startingDosh > 0)
		doshNewPlayer = startingDosh;
	else
		doshNewPlayer = 400;

	lastSpecialWaveID = -1;

	if (CustomMode)
		TimeBetweenWaves = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWave(CustomDifficulty);
	else
		TimeBetweenWaves = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWave(GameDifficulty);

	TimeBetweenWavesDefault = TimeBetweenWaves;

	if (CustomMode)
		TimeBetweenWavesExtend = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWaveHumanDied(CustomDifficulty);
	else
		TimeBetweenWavesExtend = class'ZedternalReborn.Config_Game'.static.GetTimeBetweenWaveHumanDied(GameDifficulty);

	bUseExtendedTraderTime = false;
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
}

/** Set up the spawning */
function InitSpawnManager()
{
	SpawnManager = new(self) SpawnManagerClasses[GameLength];
	SpawnManager.Initialize();

	if (GameDifficulty > `DIFFICULTY_HELLONEARTH)
	{
		CustomMode = true;
		GameDifficulty = `DIFFICULTY_HELLONEARTH;
	}

	WaveMax = INDEX_NONE;
	MyKFGRI.WaveMax = WaveMax;
}

function StartMatch()
{
	local KFPlayerController KFPC;
	local WMGameReplicationInfo WMGRI;
	WaveNum = startingWave;
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
		MyKFGRI.bWaveStarted = true;
		GotoState('PlayingWave');
	}
	else
	{
		MyKFGRI.UpdateHUDWaveCount();
		bUseExtendedTraderTime = true;
		SetupNextTrader();
		GotoState( 'TraderOpen', 'Begin' );

		// update wave modificators
		SetTimer(4.5f, false, NameOf(CheckForPreviousZedBuff));
	}

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		KFPC.ClientMatchStarted();
		if (startingDosh > 0)
			KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).Score = startingDosh;
	}
}

function StartWave()
{
	local int i, j;
	local KFPickupFactory_ItemDefault KFPFID;
	local ItemPickup newPickup;

	//closes trader on server
	MyKFGRI.CloseTrader();

	SetupSpecialWave();

	++WaveNum;
	MyKFGRI.WaveNum = WaveNum;
	NumAISpawnsQueued = 0;
	AIAliveCount = 0;
	NumAIFinishedSpawning = 0;
	
	MyKFGRI.bWaveStarted = true;

	// Set Weapon PickupList
	for (i = 0; i < ItemPickups.length; ++i)
	{
		KFPFID = KFPickupFactory_ItemDefault(ItemPickups[i]);
		if (KFPFID != none)
		{
			KFPFID.ItemPickups.length = 0;
			newPickup.ItemClass = Class'kfgamecontent.KFInventory_Armor';
			KFPFID.ItemPickups.AddItem(newPickup);
			
			for (j = 0; j < PerkStartingWeapon.length; ++j)
			{
				newPickup.ItemClass = class<KFWeapon>(DynamicLoadObject(PerkStartingWeapon[j].default.WeaponClassPath,class'Class'));
				KFPFID.ItemPickups.AddItem(newPickup);
			}
		}
	}

	SpawnManager.SetupNextWave(WaveNum);

	if( WorldInfo.NetMode != NM_DedicatedServer && Role == ROLE_Authority )
	{
		MyKFGRI.UpdateHUDWaveCount();
	}

	WaveStarted();
	MyKFGRI.NotifyWaveStart();
	MyKFGRI.AIRemaining = SpawnManager.WaveTotalAI;
	MyKFGRI.WaveTotalAICount = SpawnManager.WaveTotalAI;

	BroadcastLocalizedMessage(class'KFLocalMessage_Priority', GMT_WaveStart);

	SetupNextTrader();
	ResetAllPickups();

	if (WMGameReplicationInfo(MyKFGRI) != none)
		WMGameReplicationInfo(MyKFGRI).bNewZedBuff = false;

	if( Role == ROLE_Authority && KFGameInfo(WorldInfo.Game) != none && KFGameInfo(WorldInfo.Game).DialogManager != none) KFGameInfo(WorldInfo.Game).DialogManager.SetTraderTime( false );

	// first spawn and music are delayed 5 seconds (KFAISpawnManager.TimeUntilNextSpawn == 5 initially), so line up dialog with them;
	// fixes problem of clients not being ready to receive dialog at the instant the match starts;
	SetTimer( 5.f, false, nameof(PlayWaveStartDialog) );
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

function CheckZedBuff()
{
	if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum + 1))
	{
		ApplyRandomZedBuff(WaveNum + 1, true);
	}
}

// Used when starting match at higher wave
function CheckForPreviousZedBuff()
{
	local int testedWave;
	
	for (testedWave = 1; testedWave <= WaveNum + 1; ++testedWave)
	{
		if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(testedWave))
		{
			ApplyRandomZedBuff(WaveNum + 1, false);
		}
	}
}

function ApplyRandomZedBuff(int Wave, bool bRewardPlayer)
{
	local WMGameReplicationInfo WMGRI;
	local KFPlayerController KFPC;
	local array<byte> buffIndex;
	local byte i;
	local int index;

	WMGRI = WMGameReplicationInfo(MyKFGRI);

	if (WMGRI != none)
	{
		// build available buff list
		for (i = 0; i < WMGRI.zedBuffs.length; ++i)
		{
			if (WMGRI.bZedBuffs[i] == 0 && class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[i].minWave <= Wave && class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[i].maxWave >= WaveNum)
				buffIndex.AddItem(i);
		}

		// select random buff
		if (buffIndex.length > 0)
		{
			index = buffIndex[Rand(buffIndex.length)];
			WMGRI.bZedBuffs[index] = 1;

			// warning players about new buff
			WMGRI.bNewZedBuff = true;
			if (WorldInfo.NetMode != NM_DedicatedServer)
				WMGRI.PlayZedBuffSoundAndEffect();

			// spawn zedbuff object in world
			Spawn(WMGRI.zedBuffs[index]);

			// reward players, well, for being good :]
			if (bRewardPlayer)
			{
				foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
				{
					if (KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo) != none)
					{
						if (CustomMode)
							KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh( class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(CustomDifficulty), true );
						else
							KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh( class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(GameDifficulty), true );

					}
				}
				if (CustomMode)
					doshNewPlayer += class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(CustomDifficulty);
				else
					doshNewPlayer += class'ZedternalReborn.Config_ZedBuff'.static.GetDoshBonus(GameDifficulty);
			}
		}

		// play bosses music to stress players
		WMGRI.ForceNewMusicZedBuff();
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
	if (bUseExtendedTraderTime)
	{
		TimeBetweenWaves = TimeBetweenWavesExtend;
		bUseExtendedTraderTime = false;
	}
	else
		TimeBetweenWaves = TimeBetweenWavesDefault;
	
	if (class'ZedternalReborn.Config_ZedBuff'.static.IsWaveBuffZed(WaveNum+1))
	{
		if (CustomMode)
			TimeBetweenWaves += class'ZedternalReborn.Config_ZedBuff'.static.GetTraderTimeBonus(CustomDifficulty);
		else
			TimeBetweenWaves += class'ZedternalReborn.Config_ZedBuff'.static.GetTraderTimeBonus(GameDifficulty);
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

	// Check if its a secial wave. If true, build Available Special Wave list (SWList)
	if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_bAllowed && WaveNum > 0 && FRand() < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_Probability)
	{		
		for (i = 0; i < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves.length; ++i)
		{
			if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].MinWave <= (WaveNum + 1) && class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[i].MaxWave >= (WaveNum + 1) && i != lastSpecialWaveID)
				SWList.AddItem(i);
		}
	}

	// Select a Special Wave from SWList
	if (SWList.length != 0)
	{
		index = Rand(SWList.Length);
		WMGameReplicationInfo(MyKFGRI).SpecialWaveID[0] = SWList[index];

		if (class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves.length > 1)
		{
			lastSpecialWaveID = SWList[index];
			SWList.Remove(index, 1);
		}

		// check for a double special wave
		if (SWList.length != 0 && FRand() < class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_DoubleProbability)
		{
			index = Rand(SWList.Length);
			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = SWList[index];
		}
		else
			WMGameReplicationInfo(MyKFGRI).SpecialWaveID[1] = -1;

		// if playing solo, trigger special wave visual effect
		if (WorldInfo.NetMode != NM_DedicatedServer)
			WMGameReplicationInfo(MyKFGRI).TriggerSpecialWaveMessage();
		
		SetTimer(5.f,false,nameof(SetSpecialWaveActor));
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
		WMSW.destroy();
	}
	foreach DynamicActors(class'WMPlayerController', WMPC)
	{
		WMPC.UpdateWeaponMagAndCap();
	}
}

function BuildWeaponList()
{
	local int i, choice, count;
	local bool bAllowWeaponVariant;
	local array<int> weaponIndex;
	local array<string> tempWeapDefStr;
	local class<KFWeaponDefinition> KFWeaponDefClass, CustomWeaponDef;
	local STraderItem newWeapon;
	local array< int > tempList;

	weaponIndex.Length = 0;

	TraderItems = new class'KFGFxObject_TraderItems';

	/////////////////
	// Armor Price //
	/////////////////
	if (CustomMode)
		TraderItems.ArmorPrice = class'ZedternalReborn.Config_Game'.static.GetArmorPrice(CustomDifficulty);
	else
		TraderItems.ArmorPrice = class'ZedternalReborn.Config_Game'.static.GetArmorPrice(GameDifficulty);

	if (WMGameReplicationInfo(MyKFGRI) != none)
		WMGameReplicationInfo(MyKFGRI).ArmorPrice = TraderItems.ArmorPrice;

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
			weaponIndex[weaponIndex.Length] = count-1;
	}

	//Add and register custom weapons
	if (class'ZedternalReborn.Config_Weapon'.default.Weapon_bUseCustomWeaponList)
	{
		for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef.length; ++i)
		{
			CustomWeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i],class'Class'));
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
	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList.length; ++i)
	{
		tempList[tempList.length] = i;
	}
	for (i = 0; i < min(class'ZedternalReborn.Config_Weapon'.default.Trader_StartingWeaponNumber, tempList.length); ++i)
	{
		choice = Rand(tempList.length);
		tempWeapDefStr[i] = class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[tempList[choice]];
		PerkStartingWeapon[i] = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[tempList[choice]],class'Class'));
		KFStartingWeaponPath[i] = PerkStartingWeapon[i].default.WeaponClassPath;
		tempList.Remove(choice, 1);
	}

	//adding randomly starting weapon in trader
	for (i = 0; i < PerkStartingWeapon.length; ++i)
	{
		KFWeaponDefClass = PerkStartingWeapon[i];
		if (KFWeaponDefClass != none)
		{
			if (bAllowWeaponVariant)
				ApplyRandomWeaponVariant(tempWeapDefStr[i], true);
			else
				CheckForWeaponOverrides(KFWeaponDefClass);
		}
	}

	//adding static weapon in the trader
	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs.length; ++i)
	{
		KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i],class'Class'));
		if (KFWeaponDefClass != none)
		{
			if (bAllowWeaponVariant)
				ApplyRandomWeaponVariant(class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i], true);
			else
				CheckForWeaponOverrides(KFWeaponDefClass);
		}
	}

	//Adding randomly other weapons
	for (i = (class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs.length + class'ZedternalReborn.Config_Weapon'.default.Trader_StartingWeaponNumber); i < class'ZedternalReborn.Config_Weapon'.default.Trader_maxWeapon; ++i)
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

function AddWeaponInTrader(class<KFWeaponDefinition> KFWD)
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
	KFW = class<KFWeapon>(DynamicLoadObject(KFWD.default.WeaponClassPath,class'Class'));
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

// To fix broken weapons using our own overrides, like nailguns
function CheckForWeaponOverrides(class<KFWeaponDefinition> KFWD, optional int index = -1)
{
	local string weapDefinitionPath;
	local class<KFWeaponDefinition> overrideWeapon;

	weapDefinitionPath = PathName(KFWD);

	if (weapDefinitionPath == "KFGame.KFWeapDef_Nailgun")
	{
		overrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun",class'Class'));
	}

	else if (weapDefinitionPath == "KFGame.KFWeapDef_Nailgun_HRG")
	{
		overrideWeapon = class<KFWeaponDefinition>(DynamicLoadObject("ZedternalReborn.WMWeapDef_Nailgun_HRG",class'Class'));
	}


	if (overrideWeapon != none)
	{
		TraderItemsReplacementHelper(weapDefinitionPath, overrideWeapon, false, index);
		return;
	}

	AddWeaponInTrader(KFWD);
}

function int GetWeaponUpgradePrice(class<KFWeaponDefinition> KFWD)
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

function bool IsWeaponDefCanBeRandom(Class<KFWeaponDefinition> KFWepDef)
{
	local int i;
	// check if this weapon can be randomly added in the trader during the game

	// Exclude dualWeapon. DualWeapon will be available with singleWeapon
	if (class<KFWeap_DualBase>(class<KFWeapon>(DynamicLoadObject(KFWepDef.default.WeaponClassPath,class'Class'))) != none)
		return false;

	// Exclude static weapon (because they are already in the trader)
	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs.length; ++i)
	{
		if (KFWepDef == class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i], class'Class')))
			return false;
	}

	// Exclude starting weapons (because they are already in the trader)
	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList.length; ++i)
	{
		if (KFWepDef == class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[i], class'Class')))
			return false;
	}

	return true;
}

function ApplyRandomWeaponVariant(string weapDefinitionPath, bool shouldNotReplace, optional int index = -1)
{
	local int i, x;
	local class<KFWeaponDefinition> KFWeaponDefClass, KFDualWeaponDefClass;

	if (shouldNotReplace)
		CheckForWeaponOverrides(class<KFWeaponDefinition>(DynamicLoadObject(weapDefinitionPath,class'Class')), index);

	for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList.length; ++i)
	{
		if (class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].WeaponDef == weapDefinitionPath && FRand() <= class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_VariantList[i].Probability)
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
		CheckForWeaponOverrides(class<KFWeaponDefinition>(DynamicLoadObject(weapDefinitionPath,class'Class')), index);
}

function TraderItemsReplacementHelper(string OldWeaponDefPath, class<KFWeaponDefinition> NewWeaponDefClass, bool shouldNotReplace, optional int index = -1, optional bool putInTrader = true)
{
	local int i;
	local STraderItem newWeapon;

	if (index < 0 && !shouldNotReplace)
	{
		for (i = 0; i < TraderItems.SaleItems.length; ++i)
		{
			if (PathName(TraderItems.SaleItems[i].WeaponDef) == OldWeaponDefPath)
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


function RepGameInfo()
{
	local WMGameReplicationInfo WMGRI;
	local byte b;
	local int i;

	//AmmoPriceFactor
	if (CustomMode)
		MyKFGRI.GameAmmoCostScale = class'ZedternalReborn.Config_Game'.static.GetAmmoPriceFactor(CustomDifficulty);
	else
		MyKFGRI.GameAmmoCostScale = class'ZedternalReborn.Config_Game'.static.GetAmmoPriceFactor(GameDifficulty);

	WMGRI = WMGameReplicationInfo(MyKFGRI);
	if (WMGRI == none)
		return;

	//Print game version
	WMGRI.printVersion = true;

	//ZedBuff
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath.length); ++b)
	{
		WMGRI.zedBuffStr[b] =	class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[b].Path;
		WMGRI.zedBuffs[b] =		class<WMZedBuff>(DynamicLoadObject(class'ZedternalReborn.Config_ZedBuff'.default.ZedBuff_BuffPath[b].Path,class'Class'));
	}

	WMGRI.TraderVoiceGroupIndex = traderVoiceIndex;
	if (WorldInfo.NetMode != NM_DedicatedServer)
		WMGRI.TraderDialogManager.TraderVoiceGroupClass = WMGRI.default.TraderVoiceGroupClasses[traderVoiceIndex];

	//Grenades
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef.length); ++b)
	{
		WMGRI.grenadesStr[b] =	class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef[b];
		WMGRI.Grenades[b] =		class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_grenadesDef[b],class'Class'));
	}

	//Starting/itempickup Weapon
	for (b = 0; b < Min(255, KFStartingWeaponPath.Length); ++b)
	{
		WMGRI.KFStartingWeaponPath[b] = KFStartingWeaponPath[b];
	}

	//Weapons
	for (b = 0; b < Min(255, KFWeaponName.Length); ++b)
	{
		WMGRI.KFWeaponName[b] = KFWeaponName[b];
	}
	for (b = 0; b < Min(255, KFWeaponDefPath.Length); ++b)
	{
		WMGRI.KFWeaponDefPath[b] = KFWeaponDefPath[b];
	}

	//Perk Upgrades
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_perkUpgrades.length); ++b)
	{
		WMGRI.perkUpgradesStr[b] =	class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[b];
		WMGRI.perkUpgrades[b] =		class<WMUpgrade_Perk>(DynamicLoadObject(class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[b],class'Class'));
	}

	//Weapon Upgrades
	for (i = 0; i < Min(255, weaponUpgradeArch.length); ++i)
	{
		WMGRI.weaponUpgrade_WeaponStr_A[i] =	PathName(weaponUpgradeArch[i].KFWeapon);
		WMGRI.weaponUpgrade_UpgradeStr_A[i] =	PathName(weaponUpgradeArch[i].KFWeaponUpgrade);
		WMGRI.weaponUpgrade_PriceRep_A[i] =		weaponUpgradeArch[i].Price;
		WMGRI.weaponUpgrade_Price[i] =			weaponUpgradeArch[i].Price;
		WMGRI.weaponUpgrade_Weapon[i] =			weaponUpgradeArch[i].KFWeapon;
		WMGRI.weaponUpgrade_Upgrade[i] =		weaponUpgradeArch[i].KFWeaponUpgrade;
	}
	for (i = 0; i < Min(255, weaponUpgradeArch.length - 255); ++i)
	{
		WMGRI.weaponUpgrade_WeaponStr_B[i] =	PathName(weaponUpgradeArch[i + 255].KFWeapon);
		WMGRI.weaponUpgrade_UpgradeStr_B[i] =	PathName(weaponUpgradeArch[i + 255].KFWeaponUpgrade);
		WMGRI.weaponUpgrade_PriceRep_B[i] =		weaponUpgradeArch[i + 255].Price;
		WMGRI.weaponUpgrade_Price[i + 255] =	weaponUpgradeArch[i + 255].Price;
		WMGRI.weaponUpgrade_Weapon[i + 255] =	weaponUpgradeArch[i + 255].KFWeapon;
		WMGRI.weaponUpgrade_Upgrade[i + 255] =	weaponUpgradeArch[i + 255].KFWeaponUpgrade;
	}
	for (i = 0; i < Min(255, weaponUpgradeArch.length - 510); ++i)
	{
		WMGRI.weaponUpgrade_WeaponStr_C[i] =	PathName(weaponUpgradeArch[i + 510].KFWeapon);
		WMGRI.weaponUpgrade_UpgradeStr_C[i] =	PathName(weaponUpgradeArch[i + 510].KFWeaponUpgrade);
		WMGRI.weaponUpgrade_PriceRep_C[i] =		weaponUpgradeArch[i + 510].Price;
		WMGRI.weaponUpgrade_Price[i + 510] =	weaponUpgradeArch[i + 510].Price;
		WMGRI.weaponUpgrade_Weapon[i + 510] =	weaponUpgradeArch[i + 510].KFWeapon;
		WMGRI.weaponUpgrade_Upgrade[i + 510] =	weaponUpgradeArch[i + 510].KFWeaponUpgrade;
	}
	for (i = 0; i < Min(255, weaponUpgradeArch.length - 765); ++i)
	{
		WMGRI.weaponUpgrade_WeaponStr_D[i] =	PathName(weaponUpgradeArch[i + 765].KFWeapon);
		WMGRI.weaponUpgrade_UpgradeStr_D[i] =	PathName(weaponUpgradeArch[i + 765].KFWeaponUpgrade);
		WMGRI.weaponUpgrade_PriceRep_D[i] =		weaponUpgradeArch[i + 765].Price;
		WMGRI.weaponUpgrade_Price[i + 765] =	weaponUpgradeArch[i + 765].Price;
		WMGRI.weaponUpgrade_Weapon[i + 765] =	weaponUpgradeArch[i + 765].KFWeapon;
		WMGRI.weaponUpgrade_Upgrade[i + 765] =	weaponUpgradeArch[i + 765].KFWeaponUpgrade;
	}

	//Skill Upgrades
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades.length); ++b)
	{
		WMGRI.skillUpgradesStr[b] =			class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].SkillPath;
		WMGRI.skillUpgrades[b] =			class<WMUpgrade_Skill>(DynamicLoadObject(class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].SkillPath,class'Class'));
		WMGRI.skillUpgradesStr_Perk[b] =	class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].PerkPath;
		WMGRI.skillUpgrades_Perk[b] =		class<WMUpgrade_Perk>(DynamicLoadObject(class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_SkillUpgrades[b].PerkPath,class'Class'));
	}

	for (b = 0; b < Min(255, class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves.length); ++b)
	{
		WMGRI.specialWavesStr[b] =	class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[b].Path;
		WMGRI.specialWaves[b] =		class<WMSpecialWave>(DynamicLoadObject(class'ZedternalReborn.Config_SpecialWave'.default.SpecialWave_SpecialWaves[b].Path,class'Class'));
	}

	WMGRI.startingWeapon =		class'ZedternalReborn.Config_Weapon'.default.Trader_StartingWeaponNumber;
	WMGRI.newWeaponEachWave =	class'ZedternalReborn.Config_Weapon'.default.Trader_NewWeaponEachWave;
	WMGRI.maxWeapon =			class'ZedternalReborn.Config_Weapon'.default.Trader_MaxWeapon;
	WMGRI.staticWeapon =		class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs.length;

	//Perks, Skills and Weapons upgrades custom prices
	WMGRI.perkMaxLevel = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price.Length;
	for (b = 0; b < Min(255, class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price.length); ++b)
	{
		WMGRI.perkPrice[b] = class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_Price[b];
	}

	WMGRI.skillPrice =			class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_Price;
	WMGRI.skillDeluxePrice =	class'ZedternalReborn.Config_SkillUpgrade'.default.SkillUpgrade_DeluxePrice;
	WMGRI.weaponMaxLevel =		class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_MaxLevel;
	WMGRI.weaponPrice =			class'ZedternalReborn.Config_WeaponUpgrade'.default.WeaponUpgrade_PriceFactor;
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
				if (class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_FixedperkUpgrades[j] == class'ZedternalReborn.Config_PerkUpgrade'.default.PerkUpgrade_PerkUpgrades[i])
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
		WMPRI.UpdatePurchase();
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
	return Round(float(PlayerCut + perkBonus) * (1.f - DeathPenaltyModifiers[GameDifficulty]));
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
		if (CustomMode)
			TempValue *= class'ZedternalReborn.Config_Game'.static.GetLargeZedDoshFactor(CustomDifficulty);
		else
			TempValue *= class'ZedternalReborn.Config_Game'.static.GetLargeZedDoshFactor(GameDifficulty);

		if (PlayerCount > 1)
			tempValue *= (1.f + (PlayerCount - 1) * class'ZedternalReborn.Config_Game'.default.Game_ExtraLargeZedDoshFactorPerPlayer);
	}
	else
	{
		if (CustomMode)
			TempValue *= class'ZedternalReborn.Config_Game'.static.GetNormalZedDoshFactor(CustomDifficulty);
		else
			TempValue *= class'ZedternalReborn.Config_Game'.static.GetNormalZedDoshFactor(GameDifficulty);
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
	startingWave=0
	SpawnManagerClasses(0)=Class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(1)=Class'ZedternalReborn.WMAISpawnManager'
	SpawnManagerClasses(2)=Class'ZedternalReborn.WMAISpawnManager'
	GameplayEventsWriterClass=Class'KFGame.KFGameplayEventsWriter'
	TraderVoiceGroupClass=Class'kfgamecontent.KFTraderVoiceGroup_Default'
	traderVoiceIndex=0

	CustomMode=false
	CustomDifficulty=4.0
	Name="Default__WMGameInfo_Endless"

	DefaultPawnClass=Class'ZedternalReborn.WMPawn_Human'
	PlayerReplicationInfoClass=Class'ZedternalReborn.WMPlayerReplicationInfo'
	PlayerControllerClass=Class'ZedternalReborn.WMPlayerController'
	KFGFxManagerClass=Class'ZedternalReborn.WMGFxMoviePlayer_Manager'
	GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo'

	DefaultTraderItems=KFGFxObject_TraderItems'GP_Trader_ARCH.DefaultTraderItems'
	HUDType=Class'ZedternalReborn.WMGFxHudWrapper'
}
