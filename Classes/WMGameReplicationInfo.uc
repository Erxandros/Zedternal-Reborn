class WMGameReplicationInfo extends KFGameReplicationInfo;

////// Replication Data //////

//Replication Data Structures
struct AllowedWeaponRepStruct
{
	var string WeaponPathName;
	var int BuyPrice;
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

struct GrenadeItemRepStruct
{
	var string GrenadePathName;
	var bool bValid;

	structdefaultproperties
	{
		bValid=False
	}
};

struct PerkUpgradeRepStruct
{
	var string PerkPathName;
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

struct SpecialWaveRepStruct
{
	var string SpecialWavePathName;
	var bool bValid;

	structdefaultproperties
	{
		bValid=False
	}
};

struct WeaponRepStruct
{
	var string WeaponPathName;
	var bool bValid;

	structdefaultproperties
	{
		bValid=False
	}
};

struct WeaponUpgradeRepStruct
{
	var string WeaponUpgPathName;
	var int PriceUnit;
	var float PriceMultiplier;
	var int MaxLevel;
	var bool bIsStatic;
	var bool bValid;

	structdefaultproperties
	{
		bValid=False
	}
};

struct ZedBuffRepStruct
{
	var string ZedBuffPathName;
	var bool bValid;

	structdefaultproperties
	{
		bValid=False
	}
};

//Optimization for replicated data (data array size)
var int NumberOfAllowedWeapons;
var int NumberOfEquipmentUpgrades;
var int NumberOfGrenadeItems;
var int NumberOfPerkUpgrades;
var int NumberOfSkillUpgrades;
var int NumberOfSpecialWaves;
var int NumberOfStartingWeapons;
var int NumberOfTraderWeapons;
var int NumberOfWeaponUpgrades;
var int NumberOfWeaponUpgradeSlots;
var int NumberOfZedBuffs;

//Replicated Weapons
var AllowedWeaponRepStruct AllowedWeaponsRepArray_A[255];
var AllowedWeaponRepStruct AllowedWeaponsRepArray_B[255];
var string KFWeaponDefPath_A[255];
var string KFWeaponDefPath_B[255];
var WeaponRepStruct StartingWeaponsRepArray[255];

//Replicated Perk Upgrades
var int PerkUpgMaxLevel;
var int PerkUpgPrice[255];
var PerkUpgradeRepStruct PerkUpgradesRepArray[255];

//Replicated Skill Upgrades
var byte bDeluxeSkillUnlock[255];
var int SkillUpgDeluxePrice;
var int SkillUpgPrice;
var SkillUpgradeRepStruct SkillUpgradesRepArray[255];

//Replicated Skill Reroll
var bool bAllowSkillReroll;
var int RerollCost;
var float RerollMultiplier;
var float RerollSkillSellPercent;

//Replicated Weapon Upgrades
var int WeaponUpgNumberUpgradePerWeapon;
var WeaponUpgradeRepStruct WeaponUpgradesRepArray[255];
var string WeaponUpgRandSeed;

//Replicated Equipment Upgrades
var EquipmentUpgradeRepStruct EquipmentUpgradesRepArray[255];

//Replicated Grenades
var GrenadeItemRepStruct GrenadesRepArray[255];

//Replicated Special Waves
var int SpecialWaveID[2];
var SpecialWaveRepStruct SpecialWavesRepArray[255];

//Replicated Zed Buffs
var byte ActiveZedBuffs[255];
var repnotify bool bNewZedBuff;
var ZedBuffRepStruct ZedBuffsRepArray[255];

//Replicated Trader Values
var int ArmorPrice;
var int GrenadePrice;
var int TraderMaxWeaponCount;
var int TraderNewWeaponEachWave;
var int TraderStartingMaxGrenadeCount;
var int TraderStaticWeaponCount;
var repnotify byte TraderVoiceGroupIndex;

//Replicated Map Values
var repnotify byte bAllTraders;
var byte bArmorPickup;
var byte bOverrideKismetPickups;
var repnotify bool bRepairDoorTrigger;

//Weapon Skins
var repnotify bool UpdateSkinsTrigger;

//For Zedternal Reborn Upgrade Menu commands
var bool bZRUMenuAllWave;
var bool bZRUMenuCommand;

//For pause function
var bool bPauseButtonEnabled;
var bool bIsPaused;
var bool bNoTraderDuringPause;

////////////////////////////////////////////////////////////////////////////////////////////////////

////// Sync Flags //////

//Sync Loop Counter
var byte SyncCounter;

//Sync Flags
var bool bAllDataGenerated;
var bool bAllDataSynced;

var bool bAllowedWeaponsSynced_A;
var bool bAllowedWeaponsSynced_B;
var bool bEquipmentUpgradesSynced;
var bool bGrenadeItemsSynced;
var bool bPerkUpgradesSynced;
var bool bSkillUpgradesSynced;
var bool bSpecialWavesSynced;
var bool bStartingWeaponsSynced;
var bool bTraderWeaponsSynced_A;
var bool bTraderWeaponsSynced_B;
var bool bWeaponUpgradesSynced;
var bool bZedBuffsSynced;

var bool bSetTraderWeaponList;
var bool bSetWeaponPickupList;
var bool bSetWeaponUpgradeSlotsList;

////////////////////////////////////////////////////////////////////////////////////////////////////

////// Non-Replication Data //////

//Non-replicated Data Structures
struct AllowedWeaponStruct
{
	var string KFWeaponPath;
	var name WeaponName;
	var int BuyPrice;
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

struct GrenadeItemStruct
{
	var class<KFWeaponDefinition> Grenade;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

struct PerkUpgradeStruct
{
	var class<WMUpgrade_Perk> PerkUpgrade;
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

struct SpecialWaveStruct
{
	var class<WMSpecialWave> SpecialWave;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

struct WeaponStruct
{
	var class<KFWeapon> KFWeapon;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

struct WeaponUpgradeSlotStruct
{
	var class<KFWeapon> KFWeapon;
	var class<WMUpgrade_Weapon> WeaponUpgrade;
	var int BasePrice;
	var int MaxLevel;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

struct WeaponUpgradeStruct
{
	var class<WMUpgrade_Weapon> WeaponUpgrade;
	var int PriceUnit;
	var float PriceMultiplier;
	var int MaxLevel;
	var bool bIsStatic;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

struct ZedBuffStruct
{
	var class<WMZedBuff> ZedBuff;
	var bool bDone;

	structdefaultproperties
	{
		bDone=False
	}
};

//Allowed Weapons
var array<AllowedWeaponStruct> AllowedWeaponsList;

//Starting Weapons
var array<WeaponStruct> StartingWeaponsList;

//Upgrades
var array<EquipmentUpgradeStruct> EquipmentUpgradesList;
var array<PerkUpgradeStruct> PerkUpgradesList;
var array<SkillUpgradeStruct> SkillUpgradesList;
var array<WeaponUpgradeStruct> WeaponUpgradesList;

//Weapon Upgrade Slots
var array<WeaponUpgradeSlotStruct> WeaponUpgradeSlotsList;

//Grenades
var array<GrenadeItemStruct> GrenadesList;

//Special Waves
var bool bDrawSpecialWave;
var byte SpecialWaveIndexToShow;
var array<SpecialWaveStruct> SpecialWavesList;

//Zed Buffs
var array<KFMusicTrackInfo> ZedBuffMusic;
var byte ZedBuffNextMusicTrackIndex;
var array<ZedBuffStruct> ZedBuffsList;

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
		ActiveZedBuffs,
		AllowedWeaponsRepArray_A,
		AllowedWeaponsRepArray_B,
		ArmorPrice,
		bAllowSkillReroll,
		bAllTraders,
		bArmorPickup,
		bDeluxeSkillUnlock,
		bIsPaused,
		bNewZedBuff,
		bNoTraderDuringPause,
		bOverrideKismetPickups,
		bPauseButtonEnabled,
		bRepairDoorTrigger,
		bZRUMenuAllWave,
		bZRUMenuCommand,
		EquipmentUpgradesRepArray,
		GrenadePrice,
		GrenadesRepArray,
		KFWeaponDefPath_A,
		KFWeaponDefPath_B,
		NumberOfAllowedWeapons,
		NumberOfEquipmentUpgrades,
		NumberOfGrenadeItems,
		NumberOfPerkUpgrades,
		NumberOfSkillUpgrades,
		NumberOfSpecialWaves,
		NumberOfStartingWeapons,
		NumberOfTraderWeapons,
		NumberOfWeaponUpgrades,
		NumberOfWeaponUpgradeSlots,
		NumberOfZedBuffs,
		PerkUpgMaxLevel,
		PerkUpgPrice,
		PerkUpgradesRepArray,
		RerollCost,
		RerollMultiplier,
		RerollSkillSellPercent,
		SkillUpgDeluxePrice,
		SkillUpgPrice,
		SkillUpgradesRepArray,
		SpecialWaveID,
		SpecialWavesRepArray,
		StartingWeaponsRepArray,
		TraderMaxWeaponCount,
		TraderNewWeaponEachWave,
		TraderStartingMaxGrenadeCount,
		TraderStaticWeaponCount,
		TraderVoiceGroupIndex,
		UpdateSkinsTrigger,
		WeaponUpgNumberUpgradePerWeapon,
		WeaponUpgradesRepArray,
		WeaponUpgRandSeed,
		ZedBuffsRepArray;
}

simulated event ReplicatedEvent(name VarName)
{
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

		case 'UpdateSkinsTrigger':
			UpdateSkins();
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
	{
		class'ZedternalReborn.Config_Base'.static.PrintVersion();
		SetSyncLoop();
	}
}

simulated function SetSyncLoop()
{
	ClearTimer(NameOf(SyncTimer));

	SyncCounter = 0;
	SetTimer(3.0f, True, NameOf(SyncTimer));
}

simulated function SyncTimer()
{
	++SyncCounter;

	if (!bAllDataSynced)
		ProcessAllSyncData();
	else if (!bAllDataGenerated)
		GenerateDataFromSyncData();
	else
		ClearTimer(NameOf(SyncTimer));

	if (SyncCounter > 40)
	{
		if (!bAllDataSynced || !bAllDataGenerated)
			`log("ZR Error: Failed to sync and process all data from server for game replication");

		ClearTimer(NameOf(SyncTimer));
	}
}

simulated function ProcessAllSyncData()
{
	//Sync Allowed Weapons
	if (!bAllowedWeaponsSynced_A)
		SyncAllowedWeapons(AllowedWeaponsRepArray_A, 0);

	if (!bAllowedWeaponsSynced_B)
		SyncAllowedWeapons(AllowedWeaponsRepArray_B, 1);

	//Sync Trader Weapons
	if (!bTraderWeaponsSynced_A)
		SyncWeaponTraderItems(KFWeaponDefPath_A, 0);

	if (!bTraderWeaponsSynced_B)
		SyncWeaponTraderItems(KFWeaponDefPath_B, 1);

	//Sync Starting Weapons
	if (!bStartingWeaponsSynced)
		SyncAllStartingWeapons();

	//Sync Perk Upgrades
	if (!bPerkUpgradesSynced)
		SyncAllPerkUpgrades();

	//Sync Skill Upgrades
	if (!bSkillUpgradesSynced)
		SyncAllSkillUpgrades();

	//Sync Weapon Upgrades
	if (!bWeaponUpgradesSynced)
		SyncAllWeaponUpgrades();

	//Sync Equipment Upgrades
	if (!bEquipmentUpgradesSynced)
		SyncAllEquipmentUpgrades();

	//Sync Grenades
	if (!bGrenadeItemsSynced)
		SyncAllGrenadeItems();

	//Sync Special Waves
	if (!bSpecialWavesSynced)
		SyncAllSpecialWaves();

	//Sync Zed Buffs
	if (!bZedBuffsSynced)
		SyncAllZedBuffs();

	if (bAllowedWeaponsSynced_A && bAllowedWeaponsSynced_B && bTraderWeaponsSynced_A
		&& bTraderWeaponsSynced_B && bStartingWeaponsSynced && bPerkUpgradesSynced
		&& bSkillUpgradesSynced && bWeaponUpgradesSynced && bEquipmentUpgradesSynced
		&& bGrenadeItemsSynced && bSpecialWavesSynced && bZedBuffsSynced)
	{
		bAllDataSynced = True;
		`log("ZR Info: All base data received from server for game replication");
	}
}

simulated function GenerateDataFromSyncData()
{
	//Set Trader Items
	if (!bSetTraderWeaponList)
		CheckAndSetTraderItems();

	//Set Map Pickups
	if (!bSetWeaponPickupList)
		SetWeaponPickupList();

	//Generate Weapon Upgrade Slots
	if (!bSetWeaponUpgradeSlotsList)
		GenerateWeaponUpgrades();

	if (bSetTraderWeaponList && bSetWeaponPickupList && bSetWeaponUpgradeSlotsList)
	{
		bAllDataGenerated = True;
		`log("ZR Info: All needed data generated from replicated data");

		if (WorldInfo.NetMode == NM_Client)
			WorldInfo.ForceGarbageCollection(False);
	}
}

simulated function SyncAllowedWeapons(const out AllowedWeaponRepStruct AllowedWeaponsRepArray[255], int indexMultiplier)
{
	local int i, indexOffset;

	if (NumberOfAllowedWeapons == INDEX_NONE)
		return;

	if (AllowedWeaponsList.Length == 0)
		AllowedWeaponsList.Length = NumberOfAllowedWeapons;

	if (NumberOfAllowedWeapons > 0)
	{
		indexOffset = 255 * indexMultiplier;

		for (i = 0; i < 255; ++i)
		{
			if (!AllowedWeaponsRepArray[i].bValid)
				break; //base case

			if (!AllowedWeaponsList[i + indexOffset].bDone)
			{
				AllowedWeaponsList[i + indexOffset].KFWeaponPath = AllowedWeaponsRepArray[i].WeaponPathName;
				AllowedWeaponsList[i + indexOffset].WeaponName = name(GetItemName(AllowedWeaponsRepArray[i].WeaponPathName));
				AllowedWeaponsList[i + indexOffset].BuyPrice = AllowedWeaponsRepArray[i].BuyPrice;
				AllowedWeaponsList[i + indexOffset].bDone = True;
			}
		}
	}

	if (indexMultiplier == 0 && (i == NumberOfAllowedWeapons || i == 255))
		bAllowedWeaponsSynced_A = True;

	if (indexMultiplier == 1 && ((i + indexOffset) == NumberOfAllowedWeapons || 255 >= NumberOfAllowedWeapons))
		bAllowedWeaponsSynced_B = True;
}

simulated function SyncWeaponTraderItems(const out string KFWeaponDefPath[255], int indexMultiplier)
{
	local int i, indexOffset;

	if (NumberOfTraderWeapons == INDEX_NONE)
		return;

	if (TraderItems == None || TraderItems.SaleItems.Length == 0)
	{
		TraderItems = new class'WMGFxObject_TraderItems';
		TraderItems.SaleItems.Length = NumberOfTraderWeapons;
	}

	if (NumberOfTraderWeapons > 0)
	{
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

	if (indexMultiplier == 0 && (i == NumberOfTraderWeapons || i == 255))
		bTraderWeaponsSynced_A = True;

	if (indexMultiplier == 1 && ((i + indexOffset) == NumberOfTraderWeapons || 255 >= NumberOfTraderWeapons))
		bTraderWeaponsSynced_B = True;
}

simulated function SyncAllStartingWeapons()
{
	local int i;

	if (NumberOfStartingWeapons == INDEX_NONE)
		return;

	if (StartingWeaponsList.Length == 0)
		StartingWeaponsList.Length = NumberOfStartingWeapons;

	if (NumberOfStartingWeapons > 0)
	{
		for (i = 0; i < 255; ++i)
		{
			if (!StartingWeaponsRepArray[i].bValid)
				break; //base case

			if (!StartingWeaponsList[i].bDone)
			{
				StartingWeaponsList[i].KFWeapon = class<KFWeapon>(DynamicLoadObject(StartingWeaponsRepArray[i].WeaponPathName, class'Class'));
				StartingWeaponsList[i].bDone = True;
			}
		}
	}

	if (i == NumberOfStartingWeapons)
		bStartingWeaponsSynced = True;
}

simulated function SyncAllPerkUpgrades()
{
	local int i;

	if (NumberOfPerkUpgrades == INDEX_NONE)
		return;

	if (PerkUpgradesList.Length == 0)
		PerkUpgradesList.Length = NumberOfPerkUpgrades;

	if (NumberOfPerkUpgrades > 0)
	{
		for (i = 0; i < 255; ++i)
		{
			if (!PerkUpgradesRepArray[i].bValid)
				break; //base case

			if (!PerkUpgradesList[i].bDone)
			{
				PerkUpgradesList[i].PerkUpgrade = class<WMUpgrade_Perk>(DynamicLoadObject(PerkUpgradesRepArray[i].PerkPathName, class'Class'));
				PerkUpgradesList[i].bDone = True;
			}
		}
	}

	if (i == NumberOfPerkUpgrades)
		bPerkUpgradesSynced = True;
}

simulated function SyncAllSkillUpgrades()
{
	local int i;

	if (NumberOfSkillUpgrades == INDEX_NONE)
		return;

	if (SkillUpgradesList.Length == 0)
		SkillUpgradesList.Length = NumberOfSkillUpgrades;

	if (NumberOfSkillUpgrades > 0)
	{
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

	if (i == NumberOfSkillUpgrades)
		bSkillUpgradesSynced = True;
}

simulated function SyncAllWeaponUpgrades()
{
	local int i;

	if (NumberOfWeaponUpgrades == INDEX_NONE)
		return;

	if (WeaponUpgradesList.Length == 0)
		WeaponUpgradesList.Length = NumberOfWeaponUpgrades;

	if (NumberOfWeaponUpgrades > 0)
	{
		for (i = 0; i < 255; ++i)
		{
			if (!WeaponUpgradesRepArray[i].bValid)
				break; //base case

			if (!WeaponUpgradesList[i].bDone)
			{
				WeaponUpgradesList[i].WeaponUpgrade = class<WMUpgrade_Weapon>(DynamicLoadObject(WeaponUpgradesRepArray[i].WeaponUpgPathName, class'Class'));
				WeaponUpgradesList[i].PriceUnit = WeaponUpgradesRepArray[i].PriceUnit;
				WeaponUpgradesList[i].PriceMultiplier = WeaponUpgradesRepArray[i].PriceMultiplier;
				WeaponUpgradesList[i].MaxLevel = WeaponUpgradesRepArray[i].MaxLevel;
				WeaponUpgradesList[i].bIsStatic = WeaponUpgradesRepArray[i].bIsStatic;
				WeaponUpgradesList[i].bDone = True;
			}
		}
	}

	if (i == NumberOfWeaponUpgrades)
		bWeaponUpgradesSynced = True;
}

simulated function SyncAllEquipmentUpgrades()
{
	local int i;

	if (NumberOfEquipmentUpgrades == INDEX_NONE)
		return;

	if (EquipmentUpgradesList.Length == 0)
		EquipmentUpgradesList.Length = NumberOfEquipmentUpgrades;

	if (NumberOfEquipmentUpgrades > 0)
	{
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

	if (i == NumberOfEquipmentUpgrades)
		bEquipmentUpgradesSynced = True;
}

simulated function SyncAllGrenadeItems()
{
	local int i;

	if (NumberOfGrenadeItems == INDEX_NONE)
		return;

	if (GrenadesList.Length == 0)
		GrenadesList.Length = NumberOfGrenadeItems;

	if (NumberOfGrenadeItems > 0)
	{
		for (i = 0; i < 255; ++i)
		{
			if (!GrenadesRepArray[i].bValid)
				break; //base case

			if (!GrenadesList[i].bDone)
			{
				GrenadesList[i].Grenade = class<KFWeaponDefinition>(DynamicLoadObject(GrenadesRepArray[i].GrenadePathName, class'Class'));
				GrenadesList[i].bDone = True;
			}
		}
	}

	if (i == NumberOfGrenadeItems)
		bGrenadeItemsSynced = True;
}

simulated function SyncAllSpecialWaves()
{
	local int i;

	if (NumberOfSpecialWaves == INDEX_NONE)
		return;

	if (SpecialWavesList.Length == 0)
		SpecialWavesList.Length = NumberOfSpecialWaves;

	if (NumberOfSpecialWaves > 0)
	{
		for (i = 0; i < 255; ++i)
		{
			if (!SpecialWavesRepArray[i].bValid)
				break; //base case

			if (!SpecialWavesList[i].bDone)
			{
				SpecialWavesList[i].SpecialWave = class<WMSpecialWave>(DynamicLoadObject(SpecialWavesRepArray[i].SpecialWavePathName, class'Class'));
				SpecialWavesList[i].bDone = True;
			}
		}
	}

	if (i == NumberOfSpecialWaves)
		bSpecialWavesSynced = True;
}

simulated function SyncAllZedBuffs()
{
	local int i;

	if (NumberOfZedBuffs == INDEX_NONE)
		return;

	if (ZedBuffsList.Length == 0)
		ZedBuffsList.Length = NumberOfZedBuffs;

	if (NumberOfZedBuffs > 0)
	{
		for (i = 0; i < 255; ++i)
		{
			if (!ZedBuffsRepArray[i].bValid)
				break; //base case

			if (!ZedBuffsList[i].bDone)
			{
				ZedBuffsList[i].ZedBuff = class<WMZedBuff>(DynamicLoadObject(ZedBuffsRepArray[i].ZedBuffPathName, class'Class'));
				ZedBuffsList[i].bDone = True;
			}
		}
	}

	if (i == NumberOfZedBuffs)
		bZedBuffsSynced = True;
}

simulated function CheckAndSetTraderItems()
{
	if (ArmorPrice == -1)
		return; //Not yet replicated

	if (GrenadePrice == -1)
		return; //Not yet replicated

	//Set armor and grenade price
	TraderItems.ArmorPrice = ArmorPrice;
	TraderItems.GrenadePrice = GrenadePrice;

	TraderItems.SetItemsInfo(TraderItems.SaleItems);

	bSetTraderWeaponList = True;
}

simulated function SetWeaponPickupList()
{
	local int i;
	local KFPickupFactory_Ammo KFPFA;
	local KFPickupFactory_Item KFPFI;
	local array<ItemPickup> StartingItemPickups;
	local class<KFWeapon> startingWeaponClass;
	local class<KFWeap_DualBase> startingWeaponClassDual;
	local ItemPickup newPickup;

	if (bArmorPickup == 0)
		return; //Not yet replicated

	if (bOverrideKismetPickups == 0)
		return; //Not yet replicated

	//Convert Kismet controlled pickups to standard pickups
	if (bOverrideKismetPickups == 2)
	{
		foreach DynamicActors(class'KFPickupFactory_Ammo', KFPFA)
		{
			if (KFPFA != None && KFPFA.bKismetDriven)
			{
				KFPFA.bKismetDriven = False;
				KFPFA.bUseRespawnTimeOverride = False;
				KFPFA.RespawnTime = KFPFA.default.RespawnTime;
				KFPFA.bEnabledAtStart = False;
				KFPFA.bKismetEnabled = False;
				if (KFPFA.GetStateName() == 'Pickup' || KFPFA.GetStateName() == 'Disabled')
					KFPFA.Reset();
				else
					KFPFA.StartSleeping();
			}
		}

		foreach DynamicActors(class'KFPickupFactory_Item', KFPFI)
		{
			if (KFPFI != None && KFPFI.bKismetDriven)
			{
				KFPFI.bKismetDriven = False;
				KFPFI.bUseRespawnTimeOverride = False;
				KFPFI.RespawnTime = KFPFI.default.RespawnTime;
				KFPFI.bEnabledAtStart = False;
				KFPFI.bKismetEnabled = False;
				if (KFPFI.GetStateName() == 'Pickup' || KFPFI.GetStateName() == 'Disabled')
					KFPFI.Reset();
				else
					KFPFI.StartSleeping();
			}
		}
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
	for (i = 0; i < StartingWeaponsList.length; ++i)
	{
		startingWeaponClass = StartingWeaponsList[i].KFWeapon;

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
	foreach DynamicActors(class'KFPickupFactory_Item', KFPFI)
	{
		if (KFPFI != None)
		{
			if (bArmorPickup == 2 && KFPFI.ItemPickups.length == 1 && KFPFI.ItemPickups[0].ItemClass == Class'KFGameContent.KFInventory_Armor')
				continue; //Do not replace an armor only spawn, unless armor is disabled from pickups
			KFPFI.ItemPickups.length = 0;
			KFPFI.ItemPickups = StartingItemPickups;
			KFPFI.SetPickupMesh();
		}
	}

	bSetWeaponPickupList = True;
}

simulated function GenerateWeaponUpgrades()
{
	local int i, x, Choice, UpgCounter, WeaponUpgRandPosition;
	local class<KFWeapon> KFW;
	local array< class<WMUpgrade_Weapon> > AllowedUpgrades, StaticUpgrades;
	local array<int> AllowedUpgrades_PU, StaticUpgrades_PU;
	local array<float> AllowedUpgrades_PM, StaticUpgrades_PM;
	local array<int> AllowedUpgrades_ML, StaticUpgrades_ML;

	if (NumberOfWeaponUpgradeSlots == INDEX_NONE)
		return; //Not yet replicated

	if (WeaponUpgNumberUpgradePerWeapon == -1)
		return; //Not yet replicated

	if (Len(WeaponUpgRandSeed) == 0)
		return; //Not yet replicated

	UpgCounter = 0;
	WeaponUpgRandPosition = 0;
	for (i = 0; i < AllowedWeaponsList.Length; ++i)
	{
		KFW = class<KFWeapon>(DynamicLoadObject(AllowedWeaponsList[i].KFWeaponPath, class'Class'));
		if (KFW != None)
		{
			AllowedUpgrades.Length = 0;
			AllowedUpgrades_PU.Length = 0;
			AllowedUpgrades_PM.Length = 0;
			AllowedUpgrades_ML.Length = 0;

			StaticUpgrades.Length = 0;
			StaticUpgrades_PU.Length = 0;
			StaticUpgrades_PM.Length = 0;
			StaticUpgrades_ML.Length = 0;

			for (x = 0; x < WeaponUpgradesList.Length; ++x)
			{
				if (WeaponUpgradesList[x].WeaponUpgrade.static.IsUpgradeCompatible(KFW))
				{
					if (WeaponUpgradesList[x].bIsStatic)
					{
						StaticUpgrades.AddItem(WeaponUpgradesList[x].WeaponUpgrade);
						StaticUpgrades_PU.AddItem(WeaponUpgradesList[x].PriceUnit);
						StaticUpgrades_PM.AddItem(WeaponUpgradesList[x].PriceMultiplier);
						StaticUpgrades_ML.AddItem(WeaponUpgradesList[x].MaxLevel);
					}
					else
					{
						AllowedUpgrades.AddItem(WeaponUpgradesList[x].WeaponUpgrade);
						AllowedUpgrades_PU.AddItem(WeaponUpgradesList[x].PriceUnit);
						AllowedUpgrades_PM.AddItem(WeaponUpgradesList[x].PriceMultiplier);
						AllowedUpgrades_ML.AddItem(WeaponUpgradesList[x].MaxLevel);
					}
				}
			}

			for (x = 0; x < WeaponUpgNumberUpgradePerWeapon; ++x)
			{
				if (UpgCounter == NumberOfWeaponUpgradeSlots)
					break;

				if (StaticUpgrades.Length > 0)
				{
					AddWeaponUpgrade(KFW, StaticUpgrades[0], StaticUpgrades_PU[0], StaticUpgrades_PM[0], AllowedWeaponsList[i].BuyPrice, StaticUpgrades_ML[0]);
					StaticUpgrades.Remove(0, 1);
					StaticUpgrades_PU.Remove(0, 1);
					StaticUpgrades_PM.Remove(0, 1);
					StaticUpgrades_ML.Remove(0, 1);
					++UpgCounter;
				}
				else if (AllowedUpgrades.Length > 0)
				{
					Choice = class'ZedternalReborn.WMRandom'.static.SeedRandom(WeaponUpgRandSeed, WeaponUpgRandPosition, AllowedUpgrades.Length);
					AddWeaponUpgrade(KFW, AllowedUpgrades[Choice], AllowedUpgrades_PU[Choice], AllowedUpgrades_PM[Choice], AllowedWeaponsList[i].BuyPrice, AllowedUpgrades_ML[Choice]);
					AllowedUpgrades.Remove(Choice, 1);
					AllowedUpgrades_PU.Remove(Choice, 1);
					AllowedUpgrades_PM.Remove(Choice, 1);
					AllowedUpgrades_ML.Remove(Choice, 1);
					++WeaponUpgRandPosition;
					++UpgCounter;
				}
			}
		}

		if (UpgCounter == NumberOfWeaponUpgradeSlots)
		{
			bSetWeaponUpgradeSlotsList = True;
			return;
		}
	}
}

simulated function AddWeaponUpgrade(const out class<KFWeapon> KFW, const out class<WMUpgrade_Weapon> WMUW, int PriceUnit, float PriceMultiplier, int BuyPrice, int MaxLevel)
{
	local WeaponUpgradeSlotStruct WepUpg;

	WepUpg.KFWeapon = KFW;
	WepUpg.WeaponUpgrade = WMUW;

	if (PriceUnit == 0)
		WepUpg.BasePrice = 0;
	else
	{
		if (KFW.default.DualClass != None) // is a dual weapons
			WepUpg.BasePrice = Max(PriceUnit, Round(float(BuyPrice) * 2 * PriceMultiplier / float(PriceUnit)) * PriceUnit);
		else
			WepUpg.BasePrice = Max(PriceUnit, Round(float(BuyPrice) * PriceMultiplier / float(PriceUnit)) * PriceUnit);
	}

	WepUpg.MaxLevel = MaxLevel;
	WepUpg.bDone = True;

	WeaponUpgradeSlotsList.AddItem(WepUpg);
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

	if (WorldInfo.NetMode == NM_Client)
		WorldInfo.ForceGarbageCollection(False);
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

simulated function UpdateSkins()
{
	if (bTraderWeaponsSynced_A && bTraderWeaponsSynced_B)
	{
		class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_A);
		class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath_B);
	}
	else
		SetTimer(0.5f, False, NameOf(UpdateSkins));
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
			if (SpecialWavesList[SpecialWaveID[SpecialWaveIndexToShow]].SpecialWave.default.bShouldLocalize)
			{
				KFPC.MyGFxHUD.ShowBossNameplate(SpecialWavesList[SpecialWaveID[SpecialWaveIndexToShow]].SpecialWave.static.GetSpecialWaveTitle(),
					SpecialWavesList[SpecialWaveID[SpecialWaveIndexToShow]].SpecialWave.static.GetSpecialWaveDescription());
			}
			else
			{
				KFPC.MyGFxHUD.ShowBossNameplate(SpecialWavesList[SpecialWaveID[SpecialWaveIndexToShow]].SpecialWave.default.Title,
					SpecialWavesList[SpecialWaveID[SpecialWaveIndexToShow]].SpecialWave.default.Description);
			}

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

	for (i = 0; i < Min(TraderMaxWeaponCount, (NumberOfStartingWeapons + TraderStaticWeaponCount + (WaveNum + 1) * TraderNewWeaponEachWave)); ++i)
	{
		if (Item.ClassName == AllowedWeaponsList[i].WeaponName)
			return True;
		else if (Item.SingleClassName == AllowedWeaponsList[i].WeaponName)
			return True;
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
	bOverrideKismetPickups=0
	bDrawSpecialWave=False
	bEndlessMode=True
	bZRUMenuAllWave=False
	bZRUMenuCommand=False
	bPauseButtonEnabled=False
	bIsPaused=False
	bNoTraderDuringPause=False

	ArmorPrice=-1
	GrenadePrice=-1
	LobbyCurrentPage=1
	LobbyMaxPage=1
	TraderStartingMaxGrenadeCount=-1
	TraderVoiceGroupIndex=255
	WeaponUpgNumberUpgradePerWeapon=-1
	ZedBuffNextMusicTrackIndex=0

	NumberOfAllowedWeapons=INDEX_NONE
	NumberOfEquipmentUpgrades=INDEX_NONE
	NumberOfGrenadeItems=INDEX_NONE
	NumberOfPerkUpgrades=INDEX_NONE
	NumberOfSkillUpgrades=INDEX_NONE
	NumberOfSpecialWaves=INDEX_NONE
	NumberOfStartingWeapons=INDEX_NONE
	NumberOfTraderWeapons=INDEX_NONE
	NumberOfWeaponUpgrades=INDEX_NONE
	NumberOfWeaponUpgradeSlots=INDEX_NONE
	NumberOfZedBuffs=INDEX_NONE

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
