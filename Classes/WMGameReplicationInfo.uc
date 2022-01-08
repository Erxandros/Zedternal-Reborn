class WMGameReplicationInfo extends KFGameReplicationInfo;

//Replication Data Structures
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

//Optimization for replicated data (data array size)
var repnotify int NumberOfEquipmentUpgrades;
var repnotify int NumberOfSkillUpgrades;
var repnotify int NumberOfStartingWeapons;
var repnotify int NumberOfTraderWeapons;
var repnotify int NumberOfWeaponUpgrades;

//Replicated Weapons
var repnotify string KFStartingWeaponPath[255];
var repnotify string KFWeaponDefPath_A[255];
var repnotify string KFWeaponDefPath_B[255];
var name KFWeaponName_A[255];
var name KFWeaponName_B[255];

//Replicated Perk Upgrades
var int PerkUpgMaxLevel;
var int PerkUpgPrice[255];
var repnotify string PerkUpgradesStr[255];

//Replicated Skill Upgrades
var byte bDeluxeSkillUnlock[255];
var int SkillUpgDeluxePrice;
var int SkillUpgPrice;
var repnotify SkillUpgradeRepStruct SkillUpgradesRepArray[255];

//Replicated Skill Reroll
var bool bAllowSkillReroll;
var int RerollCost;
var float RerollMultiplier;
var float RerollSkillSellPercent;

//Replicated Weapon Upgrades
var int WeaponUpgMaxLevel;
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_1[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_2[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_3[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_4[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_5[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_6[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_7[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_8[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_9[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_10[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_11[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_12[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_13[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_14[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_15[255];
var repnotify WeaponUpgradeRepStruct WeaponUpgradeRepArray_16[255];

//Replicated Equipment Upgrades
var repnotify EquipmentUpgradeRepStruct EquipmentUpgradesRepArray[255];

//Replicated Grenades
var repnotify string GrenadesStr[255];

//Replicated Special Waves
var int SpecialWaveID[2];
var repnotify string SpecialWavesStr[255];

//Replicated Zed Buffs
var byte ActiveZedBuffs[255];
var repnotify bool bNewZedBuff;
var repnotify string ZedBuffsStr[255];

//Replicated Trader Values
var repnotify int ArmorPrice;
var repnotify int GrenadePrice;
var int TraderMaxWeaponCount;
var int TraderNewWeaponEachWave;
var int TraderStaticWeaponCount;
var repnotify byte TraderVoiceGroupIndex;

//Replicated Map Values
var repnotify byte bAllTraders;
var repnotify byte bArmorPickup;
var repnotify bool bRepairDoorTrigger;

//Weapon Skins
var repnotify bool UpdateSkins;

//For Zedternal Reborn Upgrade Menu commands
var bool bZRUMenuAllWave;
var bool bZRUMenuCommand;

////////////////////////////////////////////////////////////////////////////////////////////////////

//Non-replicated Data Structures
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

//Starting Weapons
var array< class<KFWeapon> > KFStartingWeaponList;

//Upgrades
var array<EquipmentUpgradeStruct> EquipmentUpgradesList;
var array< class<WMUpgrade_Perk> > PerkUpgradesList;
var array<SkillUpgradeStruct> SkillUpgradesList;
var array<WeaponUpgradeStruct> WeaponUpgradesList;

//Grenades
var array< class<KFWeaponDefinition> > GrenadesList;

//Special Waves
var bool bDrawSpecialWave;
var byte SpecialWaveIndexToShow;
var array< class<WMSpecialWave> > SpecialWavesList;

//Zed Buffs
var array<KFMusicTrackInfo> ZedBuffMusic;
var byte ZedBuffNextMusicTrackIndex;
var array< class<WMZedBuff> > ZedBuffsList;

//Trader
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
		PerkUpgradesStr, SkillUpgradesRepArray, EquipmentUpgradesRepArray, SpecialWavesStr, GrenadesStr, ZedBuffsStr,
		SpecialWaveID, bNewZedBuff, TraderNewWeaponEachWave, TraderMaxWeaponCount, TraderStaticWeaponCount, ArmorPrice, GrenadePrice, TraderVoiceGroupIndex,
		bArmorPickup, PerkUpgPrice, PerkUpgMaxLevel, SkillUpgPrice, SkillUpgDeluxePrice, bAllowSkillReroll, RerollCost, RerollMultiplier,
		RerollSkillSellPercent, WeaponUpgMaxLevel, ActiveZedBuffs, bDeluxeSkillUnlock,
		WeaponUpgradeRepArray_1, WeaponUpgradeRepArray_2, WeaponUpgradeRepArray_3, WeaponUpgradeRepArray_4,
		WeaponUpgradeRepArray_5, WeaponUpgradeRepArray_6, WeaponUpgradeRepArray_7, WeaponUpgradeRepArray_8,
		WeaponUpgradeRepArray_9, WeaponUpgradeRepArray_10, WeaponUpgradeRepArray_11, WeaponUpgradeRepArray_12,
		WeaponUpgradeRepArray_13, WeaponUpgradeRepArray_14, WeaponUpgradeRepArray_15, WeaponUpgradeRepArray_16,
		bAllTraders, UpdateSkins, bRepairDoorTrigger, bZRUMenuCommand, bZRUMenuAllWave;
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
			SkillUpgradesList.Length = NumberOfSkillUpgrades;
			SyncAllSkillUpgrades();
			break;

		case 'NumberOfWeaponUpgrades':
			WeaponUpgradesList.Length = NumberOfWeaponUpgrades;
			SyncAllWeaponUpgrades();
			break;

		case 'NumberOfEquipmentUpgrades':
			EquipmentUpgradesList.Length = NumberOfEquipmentUpgrades;
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

				if (i == KFStartingWeaponList.Length || KFStartingWeaponList[i] == None || PathName(KFStartingWeaponList[i]) != KFStartingWeaponPath[i])
					KFStartingWeaponList[i] = class<KFWeapon>(DynamicLoadObject(KFStartingWeaponPath[i], class'Class'));
			}
			SetWeaponPickupList();
			break;

		case 'PerkUpgradesStr':
			for (i = 0; i < 255; ++i)
			{
				if (PerkUpgradesStr[i] == "")
					break; //base case

				if (i == PerkUpgradesList.Length || PerkUpgradesList[i] == None || PathName(PerkUpgradesList[i]) != PerkUpgradesStr[i])
					PerkUpgradesList[i] = class<WMUpgrade_Perk>(DynamicLoadObject(PerkUpgradesStr[i], class'Class'));
			}
			break;

		case 'WeaponUpgradeRepArray_1':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_1, 0);
			break;

		case 'WeaponUpgradeRepArray_2':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_2, 1);
			break;

		case 'WeaponUpgradeRepArray_3':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_3, 2);
			break;

		case 'WeaponUpgradeRepArray_4':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_4, 3);
			break;

		case 'WeaponUpgradeRepArray_5':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_5, 4);
			break;

		case 'WeaponUpgradeRepArray_6':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_6, 5);
			break;

		case 'WeaponUpgradeRepArray_7':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_7, 6);
			break;

		case 'WeaponUpgradeRepArray_8':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_8, 7);
			break;

		case 'WeaponUpgradeRepArray_9':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_9, 8);
			break;

		case 'WeaponUpgradeRepArray_10':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_10, 9);
			break;

		case 'WeaponUpgradeRepArray_11':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_11, 10);
			break;

		case 'WeaponUpgradeRepArray_12':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_12, 11);
			break;

		case 'WeaponUpgradeRepArray_13':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_13, 12);
			break;

		case 'WeaponUpgradeRepArray_14':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_14, 13);
			break;

		case 'WeaponUpgradeRepArray_15':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_15, 14);
			break;

		case 'WeaponUpgradeRepArray_16':
			SyncWeaponUpgrades(WeaponUpgradeRepArray_16, 15);
			break;

		case 'SkillUpgradesRepArray':
			SyncAllSkillUpgrades();
			break;

		case 'EquipmentUpgradesRepArray':
			SyncAllEquipmentUpgrades();
			break;

		case 'SpecialWavesStr':
			for (i = 0; i < 255; ++i)
			{
				if (SpecialWavesStr[i] == "")
					break; //base case

				if (i == SpecialWavesList.Length || SpecialWavesList[i] == None || PathName(SpecialWavesList[i]) != SpecialWavesStr[i])
					SpecialWavesList[i] = class<WMSpecialWave>(DynamicLoadObject(SpecialWavesStr[i], class'Class'));
			}
			break;

		case 'GrenadesStr':
			for (i = 0; i < 255; ++i)
			{
				if (GrenadesStr[i] == "")
					break; //base case

				if (i == GrenadesList.Length || GrenadesList[i] == None || PathName(GrenadesList[i]) != GrenadesStr[i])
					GrenadesList[i] = class<KFWeaponDefinition>(DynamicLoadObject(GrenadesStr[i], class'Class'));
			}
			break;

		case 'ZedBuffsStr':
			for (i = 0; i < 255; ++i)
			{
				if (ZedBuffsStr[i] == "")
					break; //base case

				if (i == ZedBuffsList.Length || ZedBuffsList[i] == None || PathName(ZedBuffsList[i]) != ZedBuffsStr[i])
					ZedBuffsList[i] = class<WMZedBuff>(DynamicLoadObject(ZedBuffsStr[i], class'Class'));
			}
			break;

		case 'bNewZedBuff':
			if (bNewZedBuff)
				PlayZedBuffSoundAndEffect();
			break;

		case 'TraderVoiceGroupIndex':
			if (TraderDialogManager != None)
				TraderDialogManager.TraderVoiceGroupClass = default.TraderVoiceGroupClasses[TraderVoiceGroupIndex];
			break;

		case 'bAllTraders':
			if (bAllTraders == 2)
				SetAllTradersTimer();
			break;

		case 'UpdateSkins':
			if (UpdateSkins)
			{
				class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_A);
				class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_B);
			}
			break;

		case 'bRepairDoorTrigger':
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

	for (i = 0; i < Min(255, WeaponUpgradesList.length - indexOffset); ++i)
	{
		weaponUpgradeRepArray[i].WeaponPathName = PathName(WeaponUpgradesList[i + indexOffset].KFWeapon);
		weaponUpgradeRepArray[i].UpgradePathName = PathName(WeaponUpgradesList[i + indexOffset].KFWeaponUpgrade);
		weaponUpgradeRepArray[i].BasePrice = WeaponUpgradesList[i + indexOffset].BasePrice;
		weaponUpgradeRepArray[i].bValid = True;
	}
}

simulated function SyncAllWeaponUpgrades()
{
	SyncWeaponUpgrades(WeaponUpgradeRepArray_1, 0);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_2, 1);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_3, 2);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_4, 3);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_5, 4);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_6, 5);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_7, 6);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_8, 7);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_9, 8);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_10, 9);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_11, 10);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_12, 11);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_13, 12);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_14, 13);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_15, 14);
	SyncWeaponUpgrades(WeaponUpgradeRepArray_16, 15);
}

simulated function SyncWeaponUpgrades(const out WeaponUpgradeRepStruct weaponUpgradeRepArray[255], int indexMultiplier)
{
	local int i, indexOffset;

	if (WeaponUpgradesList.Length == 0)
		return; //Not yet initialized

	indexOffset = 255 * indexMultiplier;

	for (i = 0; i < 255; ++i)
	{
		if (!weaponUpgradeRepArray[i].bValid)
			break; //base case

		if (!WeaponUpgradesList[i + indexOffset].bDone)
		{
			WeaponUpgradesList[i + indexOffset].KFWeapon = class<KFWeapon>(DynamicLoadObject(weaponUpgradeRepArray[i].WeaponPathName, class'Class'));
			WeaponUpgradesList[i + indexOffset].KFWeaponUpgrade = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgradeRepArray[i].UpgradePathName, class'Class'));
			WeaponUpgradesList[i + indexOffset].BasePrice = weaponUpgradeRepArray[i].BasePrice;
			WeaponUpgradesList[i + indexOffset].bDone = True;
		}
	}
}

simulated function SyncAllSkillUpgrades()
{
	local int i;

	if (SkillUpgradesList.Length == 0)
		return; //Not yet initialized

	for (i = 0; i < 255; ++i)
	{
		if (!SkillUpgradesRepArray[i].bValid)
			break; //base case

		if (!SkillUpgradesList[i].bDone)
		{
			SkillUpgradesList[i].SkillUpgrade = class<WMUpgrade_Skill>(DynamicLoadObject(SkillUpgradesRepArray[i].SkillPathName, class'Class'));
			SkillUpgradesList[i].PerkPathName = SkillUpgradesRepArray[i].PerkPathName;
			SkillUpgradesList[i].bDone = True;
		}
	}
}

simulated function SyncAllEquipmentUpgrades()
{
	local int i;

	if (EquipmentUpgradesList.Length == 0)
		return; //Not yet initialized

	for (i = 0; i < 255; ++i)
	{
		if (!EquipmentUpgradesRepArray[i].bValid)
			break; //base case

		if (!EquipmentUpgradesList[i].bDone)
		{
			EquipmentUpgradesList[i].EquipmentUpgrade = class<WMUpgrade_Equipment>(DynamicLoadObject(EquipmentUpgradesRepArray[i].EquipmentPathName, class'Class'));
			EquipmentUpgradesList[i].BasePrice = EquipmentUpgradesRepArray[i].BasePrice;
			EquipmentUpgradesList[i].MaxPrice = EquipmentUpgradesRepArray[i].MaxPrice;
			EquipmentUpgradesList[i].MaxLevel = EquipmentUpgradesRepArray[i].MaxLevel;
			EquipmentUpgradesList[i].bDone = True;
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

	if (KFStartingWeaponList.Length != NumberOfStartingWeapons)
		return; //Replication not done yet

	for (i = 0; i < NumberOfStartingWeapons; ++i)
	{
		if (KFStartingWeaponList[i] == None)
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
	for (i = 0; i < KFStartingWeaponList.length; ++i)
	{
		startingWeaponClass = KFStartingWeaponList[i];

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
				if (CurrentDistToTrader < SmallestDistToTrader || SmallestDistToTrader == 0)
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

simulated function WaveStartedEndlessDialog()
{
	class'KFTraderDialogManager'.static.BroadcastEndlessStartWaveDialog(WaveNum, INDEX_NONE, WorldInfo);
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
	ForceNewMusicTrack(default.ZedBuffMusic[ZedBuffNextMusicTrackIndex]);

	++ZedBuffNextMusicTrackIndex;

	// cycle tracks
	if (ZedBuffNextMusicTrackIndex >= default.ZedBuffMusic.length)
		ZedBuffNextMusicTrackIndex = 0;
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
	SpecialWaveIndexToShow = 0;
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
		if (SpecialWaveID[SpecialWaveIndexToShow] != INDEX_NONE)
		{
			KFPC.MyGFxHUD.ShowBossNameplate(SpecialWavesList[SpecialWaveID[SpecialWaveIndexToShow]].default.Title,SpecialWavesList[SpecialWaveID[SpecialWaveIndexToShow]].default.Description);
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
	if (SpecialWaveIndexToShow == 0 && SpecialWaveID[1] != INDEX_NONE)
	{
		++SpecialWaveIndexToShow;
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

	for (i = 0; i < min(TraderMaxWeaponCount - TraderStaticWeaponCount, (NumberOfStartingWeapons + TraderStaticWeaponCount + (WaveNum + 1) * TraderNewWeaponEachWave)); ++i)
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

simulated function int GetNumPlayersAlive()
{
	local int i, NumPlayersAlive;
	local array<KFPlayerReplicationInfo> PRIs;

	GetKFPRIArray(PRIs);

	for (i = 0; i < PRIs.Length; ++i)
	{
		if ((WMPlayerReplicationInfo(PRIs[i]) != None && WMPlayerReplicationInfo(PRIs[i]).PlayerHealthInt > 0)
			|| PRIs[i].PlayerHealth > 0)
		{
			++NumPlayersAlive;
		}
	}

	return NumPlayersAlive;
}

simulated function bool HasFinalWave()
{
	return WaveMax != byte(INDEX_NONE);
}

simulated function bool IsFinalWave()
{
	return HasFinalWave() && (WaveNum == WaveMax);
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

simulated function int GetFinalWaveNum()
{
	return WaveMax;
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
	ZedBuffNextMusicTrackIndex=0
	NumberOfTraderWeapons=INDEX_NONE
	NumberOfStartingWeapons=INDEX_NONE
	NumberOfSkillUpgrades=INDEX_NONE
	NumberOfWeaponUpgrades=INDEX_NONE
	NumberOfEquipmentUpgrades=INDEX_NONE

	SpecialWaveID(0)=INDEX_NONE
	SpecialWaveID(1)=INDEX_NONE
	TraderVoiceGroupClasses(0)=Class'KFGameContent.KFTraderVoiceGroup_Patriarch'
	TraderVoiceGroupClasses(1)=Class'KFGameContent.KFTraderVoiceGroup_Hans'
	TraderVoiceGroupClasses(2)=Class'KFGameContent.KFTraderVoiceGroup_Default'
	TraderVoiceGroupClasses(3)=Class'KFGameContent.KFTraderVoiceGroup_Objective'
	TraderVoiceGroupClasses(4)=Class'KFGameContent.KFTraderVoiceGroup_Lockheart'
	TraderVoiceGroupClasses(5)=Class'KFGameContent.KFTraderVoiceGroup_Santa'
	ZedBuffMusic(0)=KFMusicTrackInfo'WW_MACT_Default.TI_SH_Boss_DieVolter'
	ZedBuffMusic(1)=KFMusicTrackInfo'WW_MACT_Default.TI_Boss_Patriarch'
	ZedBuffMusic(2)=KFMusicTrackInfo'WW_MACT_Default.TI_RG_Abomination'
	ZedBuffMusic(3)=KFMusicTrackInfo'WW_MACT_Default.TI_RG_KingFP'
	ZedBuffMusic(4)=KFMusicTrackInfo'WW_MACT_Default.TI_Boss_Matriarch'

	MenuLinker=Texture2D'ZedternalReborn_Menus.Linker'
	VoteCollectorClass=Class'ZedternalReborn.WMVoteCollector'

	Name="Default__WMGameReplicationInfo"
}
