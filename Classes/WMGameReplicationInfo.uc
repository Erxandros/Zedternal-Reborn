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
		bValid=False
	}
};

struct SkillUpgradeRepStruct
{
	var string SkillPathName;
	var string PerkPathName;
	var bool bValid;

	structdefaultproperties
	{
		bValid=False
	}
};

struct EquipmentUpgradeRepStruct
{
	var string EquipmentPathName;
	var int BasePrice;
	var int MaxPrice;
	var byte MaxLevel;
	var bool bValid;

	structdefaultproperties
	{
		bValid=False
	}
};

//Optimization for replicated data
var repnotify int NumberOfTraderWeapons;
var repnotify int NumberOfStartingWeapons;
var repnotify int NumberOfSkillUpgrades;
var repnotify int NumberOfWeaponUpgrades;
var repnotify int NumberOfEquipmentUpgrades;

//Replicated data
var name KFWeaponName_A[255];
var name KFWeaponName_B[255];
var repnotify string KFWeaponDefPath_A[255];
var repnotify string KFWeaponDefPath_B[255];
var repnotify string KFStartingWeaponPath[255];
var repnotify string perkUpgradesStr[255];
var repnotify SkillUpgradeRepStruct skillUpgradesRepArray[255];
var repnotify EquipmentUpgradeRepStruct equipmentUpgradesRepArray[255];
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
var bool bAllowSkillReroll;
var int RerollCost;
var float RerollMultiplier;
var float RerollSkillSellPercent;
var int weaponMaxLevel;
var byte bZedBuffs[255];
var byte bDeluxeSkillUnlock[255];

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

var repnotify byte bAllTraders;
var repnotify bool updateSkins;
var repnotify bool bRepairDoor;

//For Zedternal Reborn Upgrade Menu commands
var bool bZRUMenuCommand;
var bool bZRUMenuAllWave;

//Non-replicated data
struct WeaponUpgradeStruct
{
	var class<KFWeapon> KFWeapon;
	var class<WMUpgrade_Weapon> KFWeaponUpgrade;
	var int BasePrice;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

struct SkillUpgradeStruct
{
	var class<WMUpgrade_Skill> SkillUpgrade;
	var string PerkPathName;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

struct EquipmentUpgradeStruct
{
	var class<WMUpgrade_Equipment> EquipmentUpgrade;
	var int BasePrice;
	var int MaxPrice;
	var byte MaxLevel;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

var array< WeaponUpgradeStruct > weaponUpgradeList;

var array< class<KFWeapon> > KFStartingWeapon;
var array< class<WMUpgrade_Perk> > perkUpgrades;
var array<SkillUpgradeStruct> skillUpgrades;
var array<EquipmentUpgradeStruct> equipmentUpgrades;
var array< class<WMSpecialWave> > specialWaves;
var array< class<KFWeaponDefinition> > Grenades;

var array< class<WMZedBuff> > zedBuffs;
var bool bDrawSpecialWave;
var byte specialWaveIndexToShow;

var byte ZedBuff_NextMusicTrackIndex;
var array<KFMusicTrackInfo> ZedBuffMusic;
var array< class<KFTraderVoiceGroupBase> > TraderVoiceGroupClasses;

//For lobby pages
var byte LobbyCurrentPage;
var byte LobbyMaxPage;

//Private variable to get menu upk downloaded upon redirection
var private Texture2D MenuLinker;

replication
{
	if (bNetDirty)
		NumberOfTraderWeapons, NumberOfStartingWeapons, NumberOfSkillUpgrades, NumberOfWeaponUpgrades, NumberOfEquipmentUpgrades,
		KFWeaponName_A, KFWeaponName_B, KFWeaponDefPath_A, KFWeaponDefPath_B, KFStartingWeaponPath,
		perkUpgradesStr, skillUpgradesRepArray, equipmentUpgradesRepArray, specialWavesStr, grenadesStr, zedBuffStr,
		SpecialWaveID, bNewZedBuff, newWeaponEachWave, maxWeapon, staticWeapon, ArmorPrice, GrenadePrice, TraderVoiceGroupIndex,
		bArmorPickup, perkPrice, perkMaxLevel, skillPrice, skillDeluxePrice, bAllowSkillReroll, RerollCost, RerollMultiplier,
		RerollSkillSellPercent, weaponMaxLevel, bZedBuffs, bDeluxeSkillUnlock,
		weaponUpgradeRepArray_1, weaponUpgradeRepArray_2, weaponUpgradeRepArray_3, weaponUpgradeRepArray_4,
		weaponUpgradeRepArray_5, weaponUpgradeRepArray_6, weaponUpgradeRepArray_7, weaponUpgradeRepArray_8,
		weaponUpgradeRepArray_9, weaponUpgradeRepArray_10, weaponUpgradeRepArray_11, weaponUpgradeRepArray_12,
		weaponUpgradeRepArray_13, weaponUpgradeRepArray_14, weaponUpgradeRepArray_15, weaponUpgradeRepArray_16,
		bAllTraders, updateSkins, bRepairDoor, bZRUMenuCommand, bZRUMenuAllWave;
}

simulated event ReplicatedEvent(name VarName)
{
	local int i;

	switch (VarName)
	{
		case 'WaveNum':
			if (SpecialWaveID[0] != INDEX_NONE && WaveNum > 0)
				TriggerSpecialWaveMessage();
			super.ReplicatedEvent(VarName);
			break;

		case 'bTraderIsOpen':
			if (bTraderIsOpen && bAllTraders == 0)
				break; //Not done replicating bAllTraders
			super.ReplicatedEvent(VarName);
			break;

		case 'NumberOfTraderWeapons':
			if (TraderItems == None)
				TraderItems = new class'WMGFxObject_TraderItems';

			TraderItems.SaleItems.Length = NumberOfTraderWeapons;
			SyncWeaponTraderItems(KFWeaponDefPath_A, 0);
			SyncWeaponTraderItems(KFWeaponDefPath_B, 1);
			CheckAndSetTraderItems();
			break;

		case 'NumberOfStartingWeapons':
			SetWeaponPickupList();
			break;

		case 'NumberOfSkillUpgrades':
			skillUpgrades.Length = NumberOfSkillUpgrades;
			SyncAllSkillUpgrades();
			break;

		case 'NumberOfWeaponUpgrades':
			weaponUpgradeList.Length = NumberOfWeaponUpgrades;
			SyncAllWeaponUpgrades();
			break;

		case 'NumberOfEquipmentUpgrades':
			equipmentUpgrades.Length = NumberOfEquipmentUpgrades;
			SyncAllEquipmentUpgrades();
			break;

		case 'bArmorPickup':
			SetWeaponPickupList();
			break;

		case 'ArmorPrice':
			CheckAndSetTraderItems();
			break;

		case 'GrenadePrice':
			CheckAndSetTraderItems();
			break;

		case 'KFWeaponDefPath_A':
			SyncWeaponTraderItems(KFWeaponDefPath_A, 0);
			CheckAndSetTraderItems();
			break;

		case 'KFWeaponDefPath_B':
			SyncWeaponTraderItems(KFWeaponDefPath_B, 1);
			CheckAndSetTraderItems();
			break;

		case 'KFStartingWeaponPath':
			for (i = 0; i < 255; ++i)
			{
				if (KFStartingWeaponPath[i] == "")
					break; //base case

				if (i == KFStartingWeapon.Length || KFStartingWeapon[i] == None || PathName(KFStartingWeapon[i]) != KFStartingWeaponPath[i])
					KFStartingWeapon[i] = class<KFWeapon>(DynamicLoadObject(KFStartingWeaponPath[i], class'Class'));
			}
			SetWeaponPickupList();
			break;

		case 'perkUpgradesStr':
			for (i = 0; i < 255; ++i)
			{
				if (perkUpgradesStr[i] == "")
					break; //base case

				if (i == perkUpgrades.Length || perkUpgrades[i] == None || PathName(perkUpgrades[i]) != perkUpgradesStr[i])
					perkUpgrades[i] = class<WMUpgrade_Perk>(DynamicLoadObject(perkUpgradesStr[i], class'Class'));
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

		case 'skillUpgradesRepArray':
			SyncAllSkillUpgrades();
			break;

		case 'equipmentUpgradesRepArray':
			SyncAllEquipmentUpgrades();
			break;

		case 'specialWavesStr':
			for (i = 0; i < 255; ++i)
			{
				if (specialWavesStr[i] == "")
					break; //base case

				if (i == specialWaves.Length || specialWaves[i] == None || PathName(specialWaves[i]) != specialWavesStr[i])
					specialWaves[i] = class<WMSpecialWave>(DynamicLoadObject(specialWavesStr[i], class'Class'));
			}
			break;

		case 'grenadesStr':
			for (i = 0; i < 255; ++i)
			{
				if (grenadesStr[i] == "")
					break; //base case

				if (i == Grenades.Length || Grenades[i] == None || PathName(Grenades[i]) != grenadesStr[i])
					Grenades[i] = class<KFWeaponDefinition>(DynamicLoadObject(grenadesStr[i], class'Class'));
			}
			break;

		case 'zedBuffStr':
			for (i = 0; i < 255; ++i)
			{
				if (zedBuffStr[i] == "")
					break; //base case

				if (i == zedBuffs.Length || zedBuffs[i] == None || PathName(zedBuffs[i]) != zedBuffStr[i])
					zedBuffs[i] = class<WMZedBuff>(DynamicLoadObject(zedBuffStr[i], class'Class'));
			}
			break;

		case 'bNewZedBuff':
			if (bNewZedBuff)
				PlayZedBuffSoundAndEffect();
			break;

		case 'TraderVoiceGroupIndex':
			if(TraderDialogManager != None)
				TraderDialogManager.TraderVoiceGroupClass = default.TraderVoiceGroupClasses[TraderVoiceGroupIndex];
			break;

		case 'bAllTraders':
			if (bAllTraders == 2)
				SetAllTradersTimer();
			break;

		case 'updateSkins':
			if (updateSkins)
			{
				class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_A);
				class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_B);
			}
			break;

		case 'bRepairDoor':
			RepairDoor();
			break;

		default:
			super.ReplicatedEvent(VarName);
			break;
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if (WorldInfo.NetMode == NM_Client)
		class'ZedternalReborn.Config_Base'.static.PrintVersion();
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
		weaponUpgradeRepArray[i].bValid = True;
	}
}

simulated function SyncAllWeaponUpgrades()
{
	SyncWeaponUpgrades(weaponUpgradeRepArray_1, 0);
	SyncWeaponUpgrades(weaponUpgradeRepArray_2, 1);
	SyncWeaponUpgrades(weaponUpgradeRepArray_3, 2);
	SyncWeaponUpgrades(weaponUpgradeRepArray_4, 3);
	SyncWeaponUpgrades(weaponUpgradeRepArray_5, 4);
	SyncWeaponUpgrades(weaponUpgradeRepArray_6, 5);
	SyncWeaponUpgrades(weaponUpgradeRepArray_7, 6);
	SyncWeaponUpgrades(weaponUpgradeRepArray_8, 7);
	SyncWeaponUpgrades(weaponUpgradeRepArray_9, 8);
	SyncWeaponUpgrades(weaponUpgradeRepArray_10, 9);
	SyncWeaponUpgrades(weaponUpgradeRepArray_11, 10);
	SyncWeaponUpgrades(weaponUpgradeRepArray_12, 11);
	SyncWeaponUpgrades(weaponUpgradeRepArray_13, 12);
	SyncWeaponUpgrades(weaponUpgradeRepArray_14, 13);
	SyncWeaponUpgrades(weaponUpgradeRepArray_15, 14);
	SyncWeaponUpgrades(weaponUpgradeRepArray_16, 15);
}

simulated function SyncWeaponUpgrades(const out WeaponUpgradeRepStruct weaponUpgradeRepArray[255], int indexMultiplier)
{
	local int i, indexOffset;

	if (weaponUpgradeList.Length == 0)
		return; //Not yet initialized

	indexOffset = 255 * indexMultiplier;

	for (i = 0; i < 255; ++i)
	{
		if (!weaponUpgradeRepArray[i].bValid)
			break; //base case

		if (!weaponUpgradeList[i + indexOffset].bDone)
		{
			weaponUpgradeList[i + indexOffset].KFWeapon = class<KFWeapon>(DynamicLoadObject(weaponUpgradeRepArray[i].WeaponPathName, class'Class'));
			weaponUpgradeList[i + indexOffset].KFWeaponUpgrade = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgradeRepArray[i].UpgradePathName, class'Class'));
			weaponUpgradeList[i + indexOffset].BasePrice = weaponUpgradeRepArray[i].BasePrice;
			weaponUpgradeList[i + indexOffset].bDone = True;
		}
	}
}

simulated function SyncAllSkillUpgrades()
{
	local int i;

	if (skillUpgrades.Length == 0)
		return; //Not yet initialized

	for (i = 0; i < 255; ++i)
	{
		if (!skillUpgradesRepArray[i].bValid)
			break; //base case

		if (!skillUpgrades[i].bDone)
		{
			skillUpgrades[i].SkillUpgrade = class<WMUpgrade_Skill>(DynamicLoadObject(skillUpgradesRepArray[i].SkillPathName, class'Class'));
			skillUpgrades[i].PerkPathName = skillUpgradesRepArray[i].PerkPathName;
			skillUpgrades[i].bDone = True;
		}
	}
}

simulated function SyncAllEquipmentUpgrades()
{
	local int i;

	if (equipmentUpgrades.Length == 0)
		return; //Not yet initialized

	for (i = 0; i < 255; ++i)
	{
		if (!equipmentUpgradesRepArray[i].bValid)
			break; //base case

		if (!equipmentUpgrades[i].bDone)
		{
			equipmentUpgrades[i].EquipmentUpgrade = class<WMUpgrade_Equipment>(DynamicLoadObject(equipmentUpgradesRepArray[i].EquipmentPathName, class'Class'));
			equipmentUpgrades[i].BasePrice = equipmentUpgradesRepArray[i].BasePrice;
			equipmentUpgrades[i].MaxPrice = equipmentUpgradesRepArray[i].MaxPrice;
			equipmentUpgrades[i].MaxLevel = equipmentUpgradesRepArray[i].MaxLevel;
			equipmentUpgrades[i].bDone = True;
		}
	}
}

simulated function SyncWeaponTraderItems(const out string KFWeaponDefPath[255], int indexMultiplier)
{
	local int i, indexOffset;

	if (TraderItems == None || TraderItems.SaleItems.Length == 0)
		return; //Not yet initialized

	indexOffset = 255 * indexMultiplier;

	for (i = 0; i < 255; ++i)
	{
		if (KFWeaponDefPath[i] == "")
			break; //base case

		if (TraderItems.SaleItems[i + indexOffset].ItemID == INDEX_NONE)
		{
			TraderItems.SaleItems[i + indexOffset].WeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(KFWeaponDefPath[i], class'Class'));
			TraderItems.SaleItems[i + indexOffset].ItemID = i + indexOffset;
		}
	}
}

simulated function CheckAndSetTraderItems()
{
	local int i;

	if (TraderItems == None)
		return; //TraderItems not created yet

	if (ArmorPrice == -1)
		return; //Not yet replicated

	if (GrenadePrice == -1)
		return; //Not yet replicated

	for (i = 0; i < NumberOfTraderWeapons; ++i)
	{
		if (TraderItems.SaleItems[i].ItemID == INDEX_NONE)
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

	if (NumberOfStartingWeapons == INDEX_NONE)
		return; //Not yet replicated

	if (bArmorPickup == 0)
		return; //Not yet replicated

	if (KFStartingWeapon.Length != NumberOfStartingWeapons)
		return; //Replication not done yet

	for (i = 0; i < NumberOfStartingWeapons; ++i)
	{
		if (KFStartingWeapon[i] == None)
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
		if (startingWeaponClassDual != None)
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
		if (KFPFID != None)
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
	//Run it immediately and check if we should open the trader now
	UpdateNextTrader();
	if (bTraderIsOpen)
		OpenTrader();

	//Only run UpdateNextTrader every 3 seconds as it is computationally heavy
	SetTimer(3.0f, True, NameOf(UpdateNextTrader));
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
		LocActor = PC.ViewTarget != None ? PC.ViewTarget : PC;
		foreach DynamicActors(class'KFTraderTrigger', MyTrader)
		{
			if (MyTrader.bEnabled)
			{
				CurrentDistToTrader = IsZero(MyTrader.Location) ? -1.0f : VSize(MyTrader.Location - LocActor.Location) / 100.f;
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

	if (bAllTraders == 2)
	{
		foreach DynamicActors(class'KFTraderTrigger', MyTrader)
		{
			if (MyTrader.bEnabled && !MyTrader.bOpened)
				MyTrader.OpenTrader();
		}

		SetTimer(1.0f, True, NameOf(UpdateOpenedTrader));
	}

	super.OpenTrader(time);
}

simulated function CloseTrader()
{
	local KFTraderTrigger MyTrader;

	if (IsTimerActive(NameOf(UpdateOpenedTrader)))
		ClearTimer(NameOf(UpdateOpenedTrader));

	if (bAllTraders == 2)
	{
		bStopCountDown = True;
		foreach DynamicActors(class'KFTraderTrigger', MyTrader)
		{
			if (MyTrader.bOpened)
				MyTrader.CloseTrader();
		}
	}

	super.CloseTrader();
}

simulated function PlayZedBuffSoundAndEffect()
{
	if (WMGFxHudWrapper(KFPlayerController(GetALocalPlayerController()).myHUD) != None)
		WMGFxHudWrapper(KFPlayerController(GetALocalPlayerController()).myHUD).ResestWarningMessage();

	class'KFMusicStingerHelper'.static.PlayRoundWonStinger(KFPlayerController(GetALocalPlayerController()));

	//trader dialog
	SetTimer(2.0f, False, NameOf(PlayZedBuffTraderDialog));
}

simulated function PlayZedBuffTraderDialog()
{
	if (TraderDialogManager != None)
		TraderDialogManager.PlayDialog(9, KFPlayerController(GetALocalPlayerController()));
}

simulated function ForceNewMusicZedBuff()
{
	// play a boss music during this wave
	ForceNewMusicTrack(default.ZedBuffMusic[ZedBuff_NextMusicTrackIndex]);

	++ZedBuff_NextMusicTrackIndex;

	// cycle tracks
	if (ZedBuff_NextMusicTrackIndex >= default.ZedBuffMusic.length)
		ZedBuff_NextMusicTrackIndex = 0;
}

simulated function RepairDoor()
{
	local KFDoorActor KFD;

	foreach WorldInfo.AllActors(class'KFGame.KFDoorActor', KFD)
	{
		KFD.ResetDoor();
	}
}

simulated function TriggerSpecialWaveMessage()
{
	bDrawSpecialWave = False; // we will turn it on later
	specialWaveIndexToShow = 0;
	SetTimer(2.0f, False, NameOf(ShowSpecialWaveMessage));
}

simulated function ShowSpecialWaveMessage()
{
	local KFPawn_Human KFP;
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(GetALocalPlayerController());
	KFP = KFPawn_Human(GetALocalPlayerController().Pawn);
	if (KFP != None)
	{
		KFP.CheckAndEndActiveEMoteSpecialMove();
		if (SpecialWaveID[specialWaveIndexToShow] != INDEX_NONE)
		{
			KFPC.MyGFxHUD.ShowBossNameplate(specialWaves[SpecialWaveID[specialWaveIndexToShow]].default.Title,specialWaves[SpecialWaveID[specialWaveIndexToShow]].default.Description);
			SetTimer(1.25f, False, NameOf(PlaySpecialWaveSound));
		}
	}
}

simulated function PlaySpecialWaveSound()
{
	class'KFMusicStingerHelper'.static.PlayZedPlayerSuicideStinger(KFPlayerController(GetALocalPlayerController()));
	SetTimer(4.15f, False, NameOf(HideSpecialWaveMessage));
}

simulated function HideSpecialWaveMessage()
{
	if (specialWaveIndexToShow == 0 && SpecialWaveID[1] != INDEX_NONE)
	{
		++specialWaveIndexToShow;
		ShowSpecialWaveMessage();
	}
	else
	{
		KFPlayerController(GetALocalPlayerController()).MyGFxHUD.HideBossNamePlate();
		bDrawSpecialWave = True;
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
				return True;
			else if (Item.SingleClassName == KFWeaponName_A[i])
				return True;
		}
		else
		{
			if (Item.ClassName == KFWeaponName_B[i - 255])
				return True;
			else if (Item.SingleClassName == KFWeaponName_B[i - 255])
				return True;
		}
	}
	return False;
}

simulated function bool IsFinalWave()
{
	return False;
}

simulated function bool IsBossWave()
{
	return False;
}

simulated function bool IsBossWaveNext()
{
	return False;
}

simulated function bool ShouldSetBossCamOnBossSpawn()
{
	return False;
}

simulated function bool ShouldSetBossCamOnBossDeath()
{
	return False;
}

simulated function array<int> GetKFSeqEventLevelLoadedIndices()
{
	local array<int> ActivateIndices;

	ActivateIndices[0] = 6;

	return ActivateIndices;
}

defaultproperties
{
	NetPriority=1.25f
	NetUpdateFrequency=20

	bAllTraders=0
	bArmorPickup=0
	bDrawSpecialWave=False
	bEndlessMode=True
	bZRUMenuAllWave=False
	bZRUMenuCommand=False
	ArmorPrice=-1
	GrenadePrice=-1
	LobbyCurrentPage=1
	LobbyMaxPage=1
	ZedBuff_NextMusicTrackIndex=0
	NumberOfTraderWeapons=INDEX_NONE
	NumberOfStartingWeapons=INDEX_NONE
	NumberOfSkillUpgrades=INDEX_NONE
	NumberOfWeaponUpgrades=INDEX_NONE
	NumberOfEquipmentUpgrades=INDEX_NONE

	SpecialWaveID(0)=INDEX_NONE
	SpecialWaveID(1)=INDEX_NONE
	TraderVoiceGroupClasses(0)=Class'KFGameContent.KFTraderVoiceGroup_Default'
	TraderVoiceGroupClasses(1)=Class'KFGameContent.KFTraderVoiceGroup_Patriarch'
	TraderVoiceGroupClasses(2)=Class'KFGameContent.KFTraderVoiceGroup_Hans'
	TraderVoiceGroupClasses(3)=Class'KFGameContent.KFTraderVoiceGroup_Lockheart'
	TraderVoiceGroupClasses(4)=Class'KFGameContent.KFTraderVoiceGroup_Santa'
	ZedBuffMusic(0)=KFMusicTrackInfo'WW_MACT_Default.TI_SH_Boss_DieVolter'
	ZedBuffMusic(1)=KFMusicTrackInfo'WW_MACT_Default.TI_Boss_Patriarch'
	ZedBuffMusic(2)=KFMusicTrackInfo'WW_MACT_Default.TI_RG_Abomination'
	ZedBuffMusic(3)=KFMusicTrackInfo'WW_MACT_Default.TI_RG_KingFP'
	ZedBuffMusic(4)=KFMusicTrackInfo'WW_MACT_Default.TI_Boss_Matriarch'

	MenuLinker=Texture2D'ZedternalReborn_Menus.Linker'
	VoteCollectorClass=Class'ZedternalReborn.WMVoteCollector'

	Name="Default__WMGameReplicationInfo"
}
