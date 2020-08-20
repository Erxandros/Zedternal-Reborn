class WMGameReplicationInfo extends KFGameReplicationInfo;

//Replication Data Structures
struct WeaponUpgradeRepStruct
{
	var string WeaponPathName;
	var string UpgradePathName;
	var int BasePrice;
	var bool bValid;

	structdefaultproperties
	{
		bValid=false
	}
};

//Optimization for replicated data
var repnotify int NumberOfTraderWeapons;
var repnotify int NumberOfStartingWeapons;

//Replicated data
var name KFWeaponName_A[255];
var name KFWeaponName_B[255];
var repnotify string KFWeaponDefPath_A[255];
var repnotify string KFWeaponDefPath_B[255];
var repnotify string KFStartingWeaponPath[255];
var repnotify string perkUpgradesStr[255];
var repnotify string skillUpgradesStr[255];
var repnotify string skillUpgradesStr_Perk[255];
var repnotify string specialWavesStr[255];
var repnotify string grenadesStr[255];
var repnotify string zedBuffStr[255];
var int SpecialWaveID[2];
var repnotify bool bNewZedBuff;
var int newWeaponEachWave, maxWeapon, staticWeapon;
var repnotify int ArmorPrice;
var repnotify int GrenadePrice;
var repnotify byte TraderVoiceGroupIndex;
var repnotify byte bArmorPickup;

var int perkPrice[255];
var int perkMaxLevel;
var int skillPrice;
var int skillDeluxePrice;
var int weaponMaxLevel;
var byte bZedBuffs[255];

var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_1[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_2[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_3[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_4[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_5[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_6[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_7[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_8[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_9[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_10[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_11[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_12[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_13[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_14[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_15[255];
var repnotify WeaponUpgradeRepStruct weaponUpgradeRepArray_16[255];

var repnotify bool bAllTraders;
var repnotify bool updateSkins;
var repnotify bool printVersion;

//Non-replicated data
struct WeaponUpgradeStruct
{
	var class<KFWeapon> KFWeapon;
	var class<WMUpgrade_Weapon> KFWeaponUpgrade;
	var int BasePrice;
	var bool bDone;

	structdefaultproperties
	{
		bDone=false
	}
};

var array< WeaponUpgradeStruct > weaponUpgradeList;

var array< class<KFWeapon> > KFStartingWeapon;
var array< class<WMUpgrade_Perk> > perkUpgrades;
var array< class<WMUpgrade_Skill> > skillUpgrades;
var array< class<WMUpgrade_Perk> > skillUpgrades_Perk;
var array< class<WMSpecialWave> > specialWaves;
var array< class<KFWeaponDefinition> > Grenades;

var array< class<WMZedBuff> > zedBuffs;
var bool bDrawSpecialWave;
var byte specialWaveIndexToShow;

var byte zedBuff_nextMusicTrackIndex;
var array< KFMusicTrackInfo > ZedBuffMusic;
var array< class<KFTraderVoiceGroupBase> > TraderVoiceGroupClasses;

//For lobby pages
var byte currentPage;
var byte maxPage;

//Private variable to get menu upk downloaded upon redirection
var private Texture2D MenuLinker;

replication
{
	if ( bNetDirty )
		NumberOfTraderWeapons, NumberOfStartingWeapons, KFWeaponName_A, KFWeaponName_B, KFWeaponDefPath_A, KFWeaponDefPath_B, KFStartingWeaponPath,
		perkUpgradesStr, skillUpgradesStr, skillUpgradesStr_Perk, specialWavesStr, grenadesStr, zedBuffStr, SpecialWaveID, bNewZedBuff,
		newWeaponEachWave, maxWeapon, staticWeapon, ArmorPrice, GrenadePrice, TraderVoiceGroupIndex, bArmorPickup,
		perkPrice, perkMaxLevel, skillPrice, skillDeluxePrice, weaponMaxLevel, bZedBuffs,
		weaponUpgradeRepArray_1, weaponUpgradeRepArray_2, weaponUpgradeRepArray_3, weaponUpgradeRepArray_4,
		weaponUpgradeRepArray_5, weaponUpgradeRepArray_6, weaponUpgradeRepArray_7, weaponUpgradeRepArray_8,
		weaponUpgradeRepArray_9, weaponUpgradeRepArray_10, weaponUpgradeRepArray_11, weaponUpgradeRepArray_12,
		weaponUpgradeRepArray_13, weaponUpgradeRepArray_14, weaponUpgradeRepArray_15, weaponUpgradeRepArray_16,
		bAllTraders, updateSkins, printVersion;
}

simulated event ReplicatedEvent(name VarName)
{
	local int i;
	local STraderItem newWeapon;

	switch (VarName)
	{
		case 'WaveNum':
			if (SpecialWaveID[0]!=-1 && WaveNum > 0)
				TriggerSpecialWaveMessage();
			super.ReplicatedEvent(VarName);
			break;

		case 'NumberOfTraderWeapons':
			CheckAndSetTraderItems();
			break;

		case 'NumberOfStartingWeapons':
			SetWeaponPickupList();
			break;

		case 'bArmorPickup':
			SetWeaponPickupList();
			break;

		case 'ArmorPrice':
			if (TraderItems == none)
				TraderItems = new class'WMGFxObject_TraderItems';

			CheckAndSetTraderItems();
			break;

		case 'GrenadePrice':
			if (TraderItems == none)
				TraderItems = new class'WMGFxObject_TraderItems';

			CheckAndSetTraderItems();
			break;

		case 'KFWeaponDefPath_A':
			if (TraderItems == none)
				TraderItems = new class'WMGFxObject_TraderItems';

			for (i = 0; i < 255; ++i)
			{
				if (KFWeaponDefPath_A[i] == "")
					break; //base case

				if (i == TraderItems.SaleItems.Length || TraderItems.SaleItems[i].ItemID == -1 || PathName(TraderItems.SaleItems[i].WeaponDef) != KFWeaponDefPath_A[i])
				{
					newWeapon.WeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(KFWeaponDefPath_A[i],class'Class'));
					newWeapon.ItemID = i;
					TraderItems.SaleItems[i] = newWeapon;
				}
			}
			CheckAndSetTraderItems();
			break;

		case 'KFWeaponDefPath_B':
			if (TraderItems == none)
				TraderItems = new class'WMGFxObject_TraderItems';

			if (255 > TraderItems.SaleItems.Length)
				TraderItems.SaleItems.Length = 255;

			for (i = 0; i < 255; ++i)
			{
				if (KFWeaponDefPath_B[i] == "")
					break; //base case

				if ((i + 255) == TraderItems.SaleItems.Length || TraderItems.SaleItems[i + 255].ItemID == -1 || PathName(TraderItems.SaleItems[i + 255].WeaponDef) != KFWeaponDefPath_B[i])
				{
					newWeapon.WeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(KFWeaponDefPath_B[i],class'Class'));
					newWeapon.ItemID = i + 255;
					TraderItems.SaleItems[i + 255] = newWeapon;
				}
			}
			CheckAndSetTraderItems();
			break;

		case 'KFStartingWeaponPath':
			for (i = 0; i < 255; ++i)
			{
				if (KFStartingWeaponPath[i] == "")
					break; //base case

				if (i == KFStartingWeapon.Length || KFStartingWeapon[i] == none || PathName(KFStartingWeapon[i]) != KFStartingWeaponPath[i])
					KFStartingWeapon[i] = class<KFWeapon>(DynamicLoadObject(KFStartingWeaponPath[i],class'Class'));
			}
			SetWeaponPickupList();
			break;

		case 'perkUpgradesStr':
			for (i = 0; i < 255; ++i)
			{
				if (perkUpgradesStr[i] == "")
					break; //base case

				if (i == perkUpgrades.Length || perkUpgrades[i] == none || PathName(perkUpgrades[i]) != perkUpgradesStr[i])
					perkUpgrades[i] = class<WMUpgrade_Perk>(DynamicLoadObject(perkUpgradesStr[i],class'Class'));
			}
			break;

		case 'weaponUpgradeRepArray_1':
			SyncWeaponUpgrades(weaponUpgradeRepArray_1, 0);
			break;

		case 'weaponUpgradeRepArray_2':
			SyncWeaponUpgrades(weaponUpgradeRepArray_2, 1);
			break;

		case 'weaponUpgradeRepArray_3':
			SyncWeaponUpgrades(weaponUpgradeRepArray_3, 2);
			break;

		case 'weaponUpgradeRepArray_4':
			SyncWeaponUpgrades(weaponUpgradeRepArray_4, 3);
			break;

		case 'weaponUpgradeRepArray_5':
			SyncWeaponUpgrades(weaponUpgradeRepArray_5, 4);
			break;

		case 'weaponUpgradeRepArray_6':
			SyncWeaponUpgrades(weaponUpgradeRepArray_6, 5);
			break;

		case 'weaponUpgradeRepArray_7':
			SyncWeaponUpgrades(weaponUpgradeRepArray_7, 6);
			break;

		case 'weaponUpgradeRepArray_8':
			SyncWeaponUpgrades(weaponUpgradeRepArray_8, 7);
			break;

		case 'weaponUpgradeRepArray_9':
			SyncWeaponUpgrades(weaponUpgradeRepArray_9, 8);
			break;

		case 'weaponUpgradeRepArray_10':
			SyncWeaponUpgrades(weaponUpgradeRepArray_10, 9);
			break;

		case 'weaponUpgradeRepArray_11':
			SyncWeaponUpgrades(weaponUpgradeRepArray_11, 10);
			break;

		case 'weaponUpgradeRepArray_12':
			SyncWeaponUpgrades(weaponUpgradeRepArray_12, 11);
			break;

		case 'weaponUpgradeRepArray_13':
			SyncWeaponUpgrades(weaponUpgradeRepArray_13, 12);
			break;

		case 'weaponUpgradeRepArray_14':
			SyncWeaponUpgrades(weaponUpgradeRepArray_14, 13);
			break;

		case 'weaponUpgradeRepArray_15':
			SyncWeaponUpgrades(weaponUpgradeRepArray_15, 14);
			break;

		case 'weaponUpgradeRepArray_16':
			SyncWeaponUpgrades(weaponUpgradeRepArray_16, 15);
			break;

		case 'skillUpgradesStr':
			for (i = 0; i < 255; ++i)
			{
				if (skillUpgradesStr[i] == "")
					break; //base case

				if (i == skillUpgrades.Length || skillUpgrades[i] == none || PathName(skillUpgrades[i]) != skillUpgradesStr[i])
					skillUpgrades[i] = class<WMUpgrade_Skill>(DynamicLoadObject(skillUpgradesStr[i],class'Class'));
			}
			break;

		case 'skillUpgradesStr_Perk':
			for (i = 0; i < 255; ++i)
			{
				if (skillUpgradesStr_Perk[i] == "")
					break; //base case

				if (i == skillUpgrades_Perk.Length || skillUpgrades_Perk[i] == none || PathName(skillUpgrades_Perk[i]) != skillUpgradesStr_Perk[i])
					skillUpgrades_Perk[i] = class<WMUpgrade_Perk>(DynamicLoadObject(skillUpgradesStr_Perk[i],class'Class'));
			}
			break;

		case 'specialWavesStr':
			for (i = 0; i < 255; ++i)
			{
				if (specialWavesStr[i] == "")
					break; //base case

				if (i == specialWaves.Length || specialWaves[i] == none || PathName(specialWaves[i]) != specialWavesStr[i])
					specialWaves[i] = class<WMSpecialWave>(DynamicLoadObject(specialWavesStr[i],class'Class'));
			}
			break;

		case 'grenadesStr':
			for (i = 0; i < 255; ++i)
			{
				if (grenadesStr[i] == "")
					break; //base case

				if (i == Grenades.Length || Grenades[i] == none || PathName(Grenades[i]) != grenadesStr[i])
					Grenades[i] = class<KFWeaponDefinition>(DynamicLoadObject(grenadesStr[i],class'Class'));
			}
			break;

		case 'zedBuffStr':
			for (i = 0; i < 255; ++i)
			{
				if (zedBuffStr[i] == "")
					break; //base case

				if (i == zedBuffs.Length || zedBuffs[i] == none || PathName(zedBuffs[i]) != zedBuffStr[i])
					zedBuffs[i] = class<WMZedBuff>(DynamicLoadObject(zedBuffStr[i],class'Class'));
			}
			break;

		case 'bNewZedBuff':
			if (bNewZedBuff)
				PlayZedBuffSoundAndEffect();
			break;

		case 'TraderVoiceGroupIndex':
			if(TraderDialogManager != none)
				TraderDialogManager.TraderVoiceGroupClass = default.TraderVoiceGroupClasses[TraderVoiceGroupIndex];
			break;

		case 'bAllTraders':
			if (bAllTraders)
				SetAllTradersTimer();
			break;

		case 'updateSkins':
			if (updateSkins)
			{
				class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_A);
				class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_B);
			}
			break;

		case 'printVersion':
			if (printVersion)
				class'ZedternalReborn.Config_Base'.static.PrintVersion();
			break;

		default:
			super.ReplicatedEvent(VarName);
			break;
	}
}

function RepGameInfoWeaponUpgrades(out WeaponUpgradeRepStruct weaponUpgradeRepArray[255], int indexMultiplier)
{
	local int i, indexOffset;

	indexOffset = 255 * indexMultiplier;

	for (i = 0; i < Min(255, weaponUpgradeList.length - indexOffset); ++i)
	{
		weaponUpgradeRepArray[i].WeaponPathName = PathName(weaponUpgradeList[i + indexOffset].KFWeapon);
		weaponUpgradeRepArray[i].UpgradePathName = PathName(weaponUpgradeList[i + indexOffset].KFWeaponUpgrade);
		weaponUpgradeRepArray[i].BasePrice = weaponUpgradeList[i + indexOffset].BasePrice;
		weaponUpgradeRepArray[i].bValid = true;
	}
}

simulated function SyncWeaponUpgrades(const out WeaponUpgradeRepStruct weaponUpgradeRepArray[255], int indexMultiplier)
{
	local int i, indexOffset;

	indexOffset = 255 * indexMultiplier;

	if (indexOffset > weaponUpgradeList.Length)
		weaponUpgradeList.Length = indexOffset;

	for (i = 0; i < 255; ++i)
	{
		if (!weaponUpgradeRepArray[i].bValid)
			break; //base case

		if (i + indexOffset == weaponUpgradeList.Length)
			weaponUpgradeList.Add(1);

		if (!weaponUpgradeList[i + indexOffset].bDone)
		{
			weaponUpgradeList[i + indexOffset].KFWeapon = class<KFWeapon>(DynamicLoadObject(weaponUpgradeRepArray[i].WeaponPathName, class'Class'));
			weaponUpgradeList[i + indexOffset].KFWeaponUpgrade = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgradeRepArray[i].UpgradePathName, class'Class'));
			weaponUpgradeList[i + indexOffset].BasePrice = weaponUpgradeRepArray[i].BasePrice;
			weaponUpgradeList[i + indexOffset].bDone = true;
		}
	}
}

simulated function CheckAndSetTraderItems()
{
	local int i;

	if (TraderItems == none)
		return; //TraderItems not created yet

	if (ArmorPrice == -1)
		return; //Not yet replicated

	if (GrenadePrice == -1)
		return; //Not yet replicated

	if (NumberOfTraderWeapons == -1)
		return; //Not yet replicated

	if (TraderItems.SaleItems.Length != NumberOfTraderWeapons)
		return; //Replication not done yet

	for (i = 0; i < NumberOfTraderWeapons; ++i)
	{
		if (TraderItems.SaleItems[i].ItemID == -1)
			return;
	}

	//Set armor and grenade price
	TraderItems.ArmorPrice = ArmorPrice;
	TraderItems.GrenadePrice = GrenadePrice;

	TraderItems.SetItemsInfo(TraderItems.SaleItems);
}

simulated function SetWeaponPickupList()
{
	local int i;
	local KFPickupFactory_Item KFPFID;
	local array<ItemPickup> StartingItemPickups;
	local class<KFWeapon> startingWeaponClass;
	local class<KFWeap_DualBase> startingWeaponClassDual;
	local ItemPickup newPickup;

	if (NumberOfStartingWeapons == -1)
		return; //Not yet replicated

	if (bArmorPickup == 0)
		return; //Not yet replicated

	if (KFStartingWeapon.Length != NumberOfStartingWeapons)
		return; //Replication not done yet

	for (i = 0; i < NumberOfStartingWeapons; ++i)
	{
		if (KFStartingWeapon[i] == none)
			return;
	}

	// Set Weapon PickupFactory

	//Add armor
	if (bArmorPickup == 2)
	{
		newPickup.ItemClass = Class'KFGameContent.KFInventory_Armor';
		StartingItemPickups.AddItem(newPickup);
	}

	//Add 9mm
	newPickup.ItemClass = class'KFGameContent.KFWeap_Pistol_9mm';
	StartingItemPickups.AddItem(newPickup);

	//Add starting weapons
	for (i = 0; i < KFStartingWeapon.length; ++i)
	{
		startingWeaponClass = KFStartingWeapon[i];

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

	//Set KFPickupFactory objects on map to match server
	foreach DynamicActors(class'KFPickupFactory_Item', KFPFID)
	{
		if (KFPFID != none)
		{
			if (bArmorPickup == 2 && KFPFID.ItemPickups.length == 1 && KFPFID.ItemPickups[0].ItemClass == Class'KFGameContent.KFInventory_Armor')
				continue; //Do not replace an armor only spawn, unless armor is disabled from pickups
			KFPFID.ItemPickups.length = 0;
			KFPFID.ItemPickups = StartingItemPickups;
			KFPFID.SetPickupMesh();
		}
	}
}

simulated function SetAllTradersTimer()
{
	//Only run UpdateNextTrader every 3 seconds as it is computationally heavy
	SetTimer(3.0f, true, nameof(UpdateNextTrader));
}

simulated function UpdateNextTrader()
{
	local KFTraderTrigger MyTrader, ShortestDistanceTrader;
	local float SmallestDistToTrader, CurrentDistToTrader;
	local PlayerController PC;
	local Actor LocActor;

	PC = GetALocalPlayerController();

	if (PC != None)
	{
		SmallestDistToTrader = 0;
		LocActor = PC.ViewTarget != none ? PC.ViewTarget : PC;
		foreach DynamicActors(class'KFTraderTrigger', MyTrader)
		{
			if (MyTrader.bEnabled)
			{
				CurrentDistToTrader = IsZero(MyTrader.Location) ? -1.f : VSize(MyTrader.Location - LocActor.Location) / 100.f;
				if (CurrentDistToTrader <  SmallestDistToTrader || SmallestDistToTrader == 0)
				{
					SmallestDistToTrader = CurrentDistToTrader;
					ShortestDistanceTrader = MyTrader;
				}
			}
		}

		NextTrader = ShortestDistanceTrader;
	}
}

simulated function UpdateOpenedTrader()
{
	if (NextTrader != OpenedTrader)
	{
		OpenedTrader = NextTrader;
		OpenedTrader.ShowTraderPath();
	}
}

simulated function OpenTrader(optional int time)
{
	local KFTraderTrigger MyTrader;

	super.OpenTrader(time);

	if (bAllTraders)
	{
		foreach DynamicActors(class'KFTraderTrigger', MyTrader)
		{
			if (MyTrader.bEnabled && !MyTrader.bOpened)
				MyTrader.OpenTrader();
		}

		SetTimer(1.0f, true, nameof(UpdateOpenedTrader));
	}
}

simulated function CloseTrader()
{
	local KFTraderTrigger MyTrader;

	if (IsTimerActive(nameof(UpdateOpenedTrader)))
		ClearTimer(nameof(UpdateOpenedTrader));

	super.CloseTrader();

	if (bAllTraders)
	{
		foreach DynamicActors(class'KFTraderTrigger', MyTrader)
		{
			if (MyTrader.bOpened)
				MyTrader.CloseTrader();
		}
	}
}

simulated function PlayZedBuffSoundAndEffect()
{
	if (WMGFxHudWrapper(KFPlayerController(GetALocalPlayerController()).myHUD) != none)
		WMGFxHudWrapper(KFPlayerController(GetALocalPlayerController()).myHUD).ResestWarningMessage();

	class'KFMusicStingerHelper'.static.PlayRoundWonStinger( KFPlayerController(GetALocalPlayerController()) );

	// reset doors
	RepairDoor();

	//trader dialog
	SetTimer(2.f, false, nameof(PlayZedBuffTraderDialog));
}

simulated function PlayZedBuffTraderDialog()
{
	if (TraderDialogManager != none)
		TraderDialogManager.PlayDialog( 9, KFPlayerController(GetALocalPlayerController()));
}

simulated function ForceNewMusicZedBuff()
{
	// play a boss music during this wave
	ForceNewMusicTrack(default.ZedBuffMusic[zedBuff_nextMusicTrackIndex]);

	++zedBuff_nextMusicTrackIndex;

	// cycle tracks
	if (zedBuff_nextMusicTrackIndex >= default.ZedBuffMusic.length)
		zedBuff_nextMusicTrackIndex = 0;
}

simulated function RepairDoor()
{
	local KFDoorActor KFD;

	ForEach WorldInfo.AllActors(class'KFGame.KFDoorActor',KFD)
	{
		KFD.ResetDoor();
	}
}

simulated function TriggerSpecialWaveMessage()
{
	bDrawSpecialWave = false; // we will turn it on later
	specialWaveIndexToShow = 0;
	SetTimer(2.00000,false,nameof(ShowSpecialWaveMessage));
}

simulated function ShowSpecialWaveMessage()
{
	local KFPawn_Human KFP;
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(GetALocalPlayerController());
	KFP = KFPawn_Human(GetALocalPlayerController().Pawn);
	if (KFP != none)
	{
		KFP.CheckAndEndActiveEMoteSpecialMove();
		if (SpecialWaveID[specialWaveIndexToShow] != -1)
		{
			KFPC.MyGFxHUD.ShowBossNameplate(specialWaves[SpecialWaveID[specialWaveIndexToShow]].default.Title,specialWaves[SpecialWaveID[specialWaveIndexToShow]].default.Description);
			SetTimer(1.250000, false, nameof(PlaySpecialWaveSound));
		}
	}
}

simulated function PlaySpecialWaveSound()
{
	class'KFMusicStingerHelper'.static.PlayZedPlayerSuicideStinger( KFPlayerController(GetALocalPlayerController()) );
	SetTimer(4.150000, false, nameof(HideSpecialWaveMessage));
}

simulated function HideSpecialWaveMessage()
{
	if (specialWaveIndexToShow == 0 && SpecialWaveID[1] != -1)
	{
		++specialWaveIndexToShow;
		ShowSpecialWaveMessage();
	}
	else
	{
		KFPlayerController(GetALocalPlayerController()).MyGFxHUD.HideBossNamePlate();
		bDrawSpecialWave = true;
	}
}

simulated function bool IsItemAllowed(STraderItem Item)
{
	local int i;

	for (i = 0; i < min(maxWeapon - staticWeapon, (NumberOfStartingWeapons + staticWeapon + (WaveNum + 1) * newWeaponEachWave)); ++i)
	{
		if (i < 255)
		{
			if (Item.ClassName == KFWeaponName_A[i])
				return true;
			else if (Item.SingleClassName == KFWeaponName_A[i])
				return true;
		}
		else
		{
			if (Item.ClassName == KFWeaponName_B[i - 255])
				return true;
			else if (Item.SingleClassName == KFWeaponName_B[i - 255])
				return true;
		}
	}
	return false;
}

simulated function bool ShouldSetBossCamOnBossDeath()
{
	return false;
}

simulated function bool IsEndlessWave()
{
	return false;
}

simulated function bool IsBossWave()
{
	return false;
}

simulated function array<int> GetKFSeqEventLevelLoadedIndices()
{
	local array<int> ActivateIndices;

	ActivateIndices[0] = 6;

	return ActivateIndices;
}

defaultproperties
{
	NumberOfTraderWeapons=-1
	NumberOfStartingWeapons=-1
	bArmorPickup=0
	WaveMax=255
	ArmorPrice=-1
	GrenadePrice=-1
	bEndlessMode=True
	bDrawSpecialWave=false
	UpdateZedInfoInterval=0.500000
	UpdateHumanInfoInterval=0.500000
	UpdatePickupInfoInterval=1.000000
	zedBuff_nextMusicTrackIndex=0
	currentPage=1
	maxPage=1
	MenuLinker=Texture2D'ZedternalReborn_Menus.Linker'
	SpecialWaveID(0)=-1
	SpecialWaveID(1)=-1
	TraderVoiceGroupClasses(0)=Class'kfgamecontent.KFTraderVoiceGroup_Default'
	TraderVoiceGroupClasses(1)=Class'kfgamecontent.KFTraderVoiceGroup_Patriarch'
	TraderVoiceGroupClasses(2)=Class'kfgamecontent.KFTraderVoiceGroup_Hans'
	TraderVoiceGroupClasses(3)=Class'kfgamecontent.KFTraderVoiceGroup_Lockheart'
	TraderVoiceGroupClasses(4)=Class'kfgamecontent.KFTraderVoiceGroup_Santa'
	ZedBuffMusic(0)=KFMusicTrackInfo'WW_MACT_Default.TI_SH_Boss_DieVolter'
	ZedBuffMusic(1)=KFMusicTrackInfo'WW_MACT_Default.TI_Boss_Patriarch'
	ZedBuffMusic(2)=KFMusicTrackInfo'WW_MACT_Default.TI_RG_Abomination'
	ZedBuffMusic(3)=KFMusicTrackInfo'WW_MACT_Default.TI_RG_KingFP'
	ZedBuffMusic(4)=KFMusicTrackInfo'WW_MACT_Default.TI_Boss_Matriarch'
}
