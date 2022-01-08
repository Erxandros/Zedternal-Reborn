class WMPlayerReplicationInfo extends KFPlayerReplicationInfo;

//Replicated arrays
var repnotify byte bPerkUpgrade[255];
var byte bPerkUpgradeAvailable[255];
var repnotify byte bWeaponUpgrade_1[255];
var repnotify byte bWeaponUpgrade_2[255];
var repnotify byte bWeaponUpgrade_3[255];
var repnotify byte bWeaponUpgrade_4[255];
var repnotify byte bWeaponUpgrade_5[255];
var repnotify byte bWeaponUpgrade_6[255];
var repnotify byte bWeaponUpgrade_7[255];
var repnotify byte bWeaponUpgrade_8[255];
var repnotify byte bWeaponUpgrade_9[255];
var repnotify byte bWeaponUpgrade_10[255];
var repnotify byte bWeaponUpgrade_11[255];
var repnotify byte bWeaponUpgrade_12[255];
var repnotify byte bWeaponUpgrade_13[255];
var repnotify byte bWeaponUpgrade_14[255];
var repnotify byte bWeaponUpgrade_15[255];
var repnotify byte bWeaponUpgrade_16[255];
var repnotify byte bSkillUpgrade[255];
var repnotify byte bEquipmentUpgrade[255];
var byte bSkillUnlocked[255];
var byte bSkillDeluxe[255];

// Current "perk" : perk's icon reflets where player spend his dosh (perk upgrades and skill upgrades)
var repnotify byte PerkIconIndex;
var texture2D CurrentIconToDisplay;
var int MaxDoshSpent;
var array<int> DoshSpentOnPerk;
var int PlayerLevel;

//UI Menu
var private WMUI_Menu UPGMenuManager;

// Sync variables
var repnotify bool SyncTrigger;
var bool SyncCompleted;
var private WMUI_UPGMenu SyncMenuObject;
var int SyncItemDefinition;
var byte SyncLoopCounter;

// dynamic array used to track purchases of player (on server and client sides)
// used in WMPerk
var array<byte> Purchase_PerkUpgrade, Purchase_SkillUpgrade, Purchase_EquipmentUpgrade;
var array<int> Purchase_WeaponUpgrade;

// For scoreboard updates
var int UncompressedPing;
var int PlayerHealthInt;
var int PlayerArmorInt;
var byte PlatformType;

// For skip trader voting
var bool bHasVoted;
var bool bVotingActive;

//For skill reroll
var repnotify bool RerollSyncTrigger;
var bool RerollSyncCompleted;
var int RerollCounter;

//For first login
var bool bHasPlayed;

//For Supplier
var bool bPerkTertiarySupplyUsed;

replication
{
	if (bNetDirty && (Role == Role_Authority))
		bPerkUpgrade, bPerkUpgradeAvailable, bSkillUpgrade, bSkillUnlocked, bSkillDeluxe, bEquipmentUpgrade,
		bWeaponUpgrade_1, bWeaponUpgrade_2, bWeaponUpgrade_3, bWeaponUpgrade_4, bWeaponUpgrade_5,
		bWeaponUpgrade_6, bWeaponUpgrade_7, bWeaponUpgrade_8, bWeaponUpgrade_9, bWeaponUpgrade_10, bWeaponUpgrade_11,
		bWeaponUpgrade_12, bWeaponUpgrade_13, bWeaponUpgrade_14, bWeaponUpgrade_15, bWeaponUpgrade_16;

	if (bNetDirty)
		PerkIconIndex, PlayerLevel, SyncTrigger, RerollSyncTrigger, UncompressedPing, PlayerHealthInt, PlayerArmorInt,
		PlatformType, RerollCounter;
}

simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
		case 'SyncTrigger':
			break; //do nothing

		case 'RerollSyncTrigger':
			RerollSyncCompleted = True;
			break;

		case 'PerkIconIndex':
			ClientUpdateCurrentIconToDisplay();
			break;

		case 'bPerkUpgrade':
		case 'bSkillUpgrade':
		case 'bEquipmentUpgrade':
		case 'bWeaponUpgrade_1':
		case 'bWeaponUpgrade_2':
		case 'bWeaponUpgrade_3':
		case 'bWeaponUpgrade_4':
		case 'bWeaponUpgrade_5':
		case 'bWeaponUpgrade_6':
		case 'bWeaponUpgrade_7':
		case 'bWeaponUpgrade_8':
		case 'bWeaponUpgrade_9':
		case 'bWeaponUpgrade_10':
		case 'bWeaponUpgrade_11':
		case 'bWeaponUpgrade_12':
		case 'bWeaponUpgrade_13':
		case 'bWeaponUpgrade_14':
		case 'bWeaponUpgrade_15':
		case 'bWeaponUpgrade_16':
			SyncCompleted = True;
			ClientUpdateCurrentIconToDisplay();
			break;

		default:
			super.ReplicatedEvent(VarName);
			break;
	}
}

function CopyProperties(PlayerReplicationInfo PRI)
{
	local WMPlayerReplicationInfo WMPRI;
	local byte i;

	WMPRI = WMPlayerReplicationInfo(PRI);

	if (WMPRI != None)
	{
		for (i = 0; i < 255; ++i)
		{
			WMPRI.bPerkUpgrade[i] = bPerkUpgrade[i];
			WMPRI.bPerkUpgradeAvailable[i] = bPerkUpgradeAvailable[i];
			WMPRI.bWeaponUpgrade_1[i] = bWeaponUpgrade_1[i];
			WMPRI.bWeaponUpgrade_2[i] = bWeaponUpgrade_2[i];
			WMPRI.bWeaponUpgrade_3[i] = bWeaponUpgrade_3[i];
			WMPRI.bWeaponUpgrade_4[i] = bWeaponUpgrade_4[i];
			WMPRI.bWeaponUpgrade_5[i] = bWeaponUpgrade_5[i];
			WMPRI.bWeaponUpgrade_6[i] = bWeaponUpgrade_6[i];
			WMPRI.bWeaponUpgrade_7[i] = bWeaponUpgrade_7[i];
			WMPRI.bWeaponUpgrade_8[i] = bWeaponUpgrade_8[i];
			WMPRI.bWeaponUpgrade_9[i] = bWeaponUpgrade_9[i];
			WMPRI.bWeaponUpgrade_10[i] = bWeaponUpgrade_10[i];
			WMPRI.bWeaponUpgrade_11[i] = bWeaponUpgrade_11[i];
			WMPRI.bWeaponUpgrade_12[i] = bWeaponUpgrade_12[i];
			WMPRI.bWeaponUpgrade_13[i] = bWeaponUpgrade_13[i];
			WMPRI.bWeaponUpgrade_14[i] = bWeaponUpgrade_14[i];
			WMPRI.bWeaponUpgrade_15[i] = bWeaponUpgrade_15[i];
			WMPRI.bWeaponUpgrade_16[i] = bWeaponUpgrade_16[i];
			WMPRI.bSkillUpgrade[i] = bSkillUpgrade[i];
			WMPRI.bSkillUnlocked[i] = bSkillUnlocked[i];
			WMPRI.bSkillDeluxe[i] = bSkillDeluxe[i];
			WMPRI.bEquipmentUpgrade[i] = bEquipmentUpgrade[i];
		}

		WMPRI.PlayerLevel = PlayerLevel;
		WMPRI.RerollCounter = RerollCounter;
		WMPRI.bHasPlayed = bHasPlayed;
	}

	super.CopyProperties(PRI);
}

function UpdateReplicatedPlayerHealth()
{
	local WMPawn_Human OwnerPawn;

	if (KFPlayerOwner != None)
	{
		OwnerPawn = WMPawn_Human(KFPlayerOwner.Pawn);
		if (OwnerPawn != None)
		{
			if (OwnerPawn.Health != PlayerHealthInt)
			{
				PlayerHealthInt = OwnerPawn.Health;
				PlayerHealth = FloatToByte(float(OwnerPawn.Health) / float(OwnerPawn.HealthMax));
				PlayerHealthPercent = PlayerHealth;
			}

			if (OwnerPawn.ZedternalArmor != PlayerArmorInt)
				PlayerArmorInt = OwnerPawn.ZedternalArmor;
		}
	}
}

simulated function byte GetActivePerkLevel()
{
	return PlayerLevel;
}

simulated function byte GetActivePerkPrestigeLevel()
{
	return 0;
}

simulated function Texture2D GetCurrentIconToDisplay()
{
	return CurrentIconToDisplay;
}

simulated function ClientUpdateCurrentIconToDisplay()
{
	local WMGameReplicationInfo WMGRI;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI != None && PerkIconIndex < WMGRI.perkUpgrades.Length)
		CurrentIconToDisplay = WMGRI.perkUpgrades[PerkIconIndex].static.GetUpgradeIcon(bPerkUpgrade[PerkIconIndex] - 1);
}

function UpdateCurrentIconToDisplay(int lastBoughtIndex, int doshSpent, int lvl)
{
	// function called every time a perk upgrade or skill upgrade is bought
	// will update perk icon based on dosh spent by the player
	// will also increase player level by one

	local WMGameReplicationInfo WMGRI;
	local byte i;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI != None)
	{
		// initialize doshRecord if needed
		if (PerkIconIndex == 254)
		{
			MaxDoshSpent = 0;
			for (i = 0; i < WMGRI.perkUpgrades.length; ++i)
			{
				DoshSpentOnPerk[i] = 0;
			}
		}

		// record dosh spent on perk[index] related upgrades
		DoshSpentOnPerk[lastBoughtIndex] += doshSpent;

		// check and update player's perk icon index
		if (PerkIconIndex == 254 || DoshSpentOnPerk[lastBoughtIndex] >= MaxDoshSpent)
		{
			CurrentIconToDisplay = WMGRI.perkUpgrades[lastBoughtIndex].static.GetUpgradeIcon(bPerkUpgrade[lastBoughtIndex] - 1);
			MaxDoshSpent = DoshSpentOnPerk[lastBoughtIndex];
			PerkIconIndex = lastBoughtIndex;
		}

		// increase player level
		PlayerLevel += lvl;
	}
}

reliable client function UpdateClientPurchase()
{
	UpdatePurchase();
}

reliable server function UpdateServerPurchase()
{
	UpdatePurchase();
	SetTimer(5.0f, False, NameOf(RecalculatePlayerLevel)); //Give server some time before it updates the HUD
}

simulated function UpdatePurchase()
{
	local int i;

	Purchase_PerkUpgrade.length = 0;
	for (i = 0; i < 255; ++i)
	{
		if (bPerkUpgrade[i] > 0)
			Purchase_PerkUpgrade.AddItem(i);
	}

	Purchase_SkillUpgrade.length = 0;
	for (i = 0; i < 255; ++i)
	{
		if (bSkillUpgrade[i] > 0)
			Purchase_SkillUpgrade.AddItem(i);
	}

	Purchase_EquipmentUpgrade.length = 0;
	for (i = 0; i < 255; ++i)
	{
		if (bEquipmentUpgrade[i] > 0)
			Purchase_EquipmentUpgrade.AddItem(i);
	}

	Purchase_WeaponUpgrade.length = 0;
	for (i = 0; i < `MAXWEAPONUPGRADES; ++i)
	{
		if (GetWeaponUpgrade(i) > 0)
			Purchase_WeaponUpgrade.AddItem(i);
	}
}

function RecalculatePlayerLevel()
{
	local byte index, level;
	local WMGameReplicationInfo WMGRI;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI != None)
	{
		PlayerLevel = 0;
		PerkIconIndex = 254;

		foreach Purchase_PerkUpgrade(index)
		{
			for (level = 0; level < bPerkUpgrade[index]; ++level)
			{
				UpdateCurrentIconToDisplay(index, WMGRI.PerkUpgPrice[level], 1);
			}
		}

		foreach Purchase_SkillUpgrade(index)
		{
			for (level = 0; level < WMGRI.perkUpgrades.length; ++level)
			{
				if (PathName(WMGRI.perkUpgrades[level]) ~= WMGRI.skillUpgrades[index].PerkPathName)
					break;
			}

			if (bSkillDeluxe[index] > 0)
				UpdateCurrentIconToDisplay(level, WMGRI.SkillUpgDeluxePrice, 3);
			else
				UpdateCurrentIconToDisplay(level, WMGRI.SkillUpgPrice, 1);
		}

		foreach Purchase_EquipmentUpgrade(index)
		{
			PlayerLevel += bEquipmentUpgrade[index];
		}
	}
}

simulated function CreateUPGMenu()
{
	local WMPlayerController WMPC;

	WMPC = WMPlayerController(Owner);
	if (WMPC == None || WMPC.bUpgradeMenuOpen)
		return;

	WMPC.bUpgradeMenuOpen = True;

	UPGMenuManager = new class'ZedternalReborn.WMUI_Menu';
	UPGMenuManager.Owner = WMPawn_Human(WMPC.Pawn);
	UPGMenuManager.WMPC = WMPC;
	UPGMenuManager.WMPRI = WMPlayerReplicationInfo(WMPC.PlayerReplicationInfo);
	UPGMenuManager.SetTimingMode(TM_Real);
	UPGMenuManager.Init(LocalPLayer(WMPC.Player));
}

simulated function CloseUPGMenu()
{
	//If a sync is in progress, cancel it before it can go through
	SyncMenuObject = None;
	SyncItemDefinition = -1;
	ClearTimer(NameOf(SyncTimerLoop));
	SyncCompleted = True;

	if (UPGMenuManager != None)
		UPGMenuManager.CloseMenu();

	UPGMenuManager = None;
}

reliable client function ShowSkipTraderVote(PlayerReplicationInfo PRI, byte VoteDuration, bool bShowChoices)
{
	super.ShowSkipTraderVote(PRI, VoteDuration, bShowChoices);
	bVotingActive = True;
}

reliable client function HideSkipTraderVote()
{
	super.HideSkipTraderVote();
	bHasVoted = False;
	bVotingActive = False;
}

simulated function RequestSkiptTrader(PlayerReplicationInfo PRI)
{
	super.RequestSkiptTrader(PRI);
	bHasVoted = True;
}

simulated function CastSkipTraderVote(PlayerReplicationInfo PRI, bool bSkipTrader)
{
	super.CastSkipTraderVote(PRI, bSkipTrader);
	bHasVoted = True;
}

simulated function NotifyWaveEnded()
{
	super.NotifyWaveEnded();

	bHasVoted = False;
	bVotingActive = False;
}

reliable client function MarkSupplierOwnerUsedZedternal(WMPlayerReplicationInfo SupplierPRI, optional bool bReceivedPrimary=True, optional bool bReceivedSecondary=True, optional bool bReceivedTertiary=True)
{
	if (SupplierPRI != None)
	{
		SupplierPRI.MarkSupplierUsedZedternal(bReceivedPrimary, bReceivedSecondary, bReceivedTertiary);
	}
}

simulated function MarkSupplierUsedZedternal(bool bReceivedPrimary, bool bReceivedSecondary, bool bReceivedTertiary)
{
	bPerkPrimarySupplyUsed = bPerkPrimarySupplyUsed || bReceivedPrimary;
	bPerkSecondarySupplyUsed = bPerkSecondarySupplyUsed || bReceivedSecondary;
	bPerkTertiarySupplyUsed = bPerkTertiarySupplyUsed || bReceivedTertiary;
}

simulated function NotifyWaveStart()
{
	super.NotifyWaveStart();

	bPerkTertiarySupplyUsed = False;
}

simulated function byte GetWeaponUpgrade(int index)
{
	local int div, indexOffset;

	div = index / 255;
	indexOffset = div * 255;

	switch (div)
	{
		case 0:
			return bWeaponUpgrade_1[index - indexOffset];

		case 1:
			return bWeaponUpgrade_2[index - indexOffset];

		case 2:
			return bWeaponUpgrade_3[index - indexOffset];

		case 3:
			return bWeaponUpgrade_4[index - indexOffset];

		case 4:
			return bWeaponUpgrade_5[index - indexOffset];

		case 5:
			return bWeaponUpgrade_6[index - indexOffset];

		case 6:
			return bWeaponUpgrade_7[index - indexOffset];

		case 7:
			return bWeaponUpgrade_8[index - indexOffset];

		case 8:
			return bWeaponUpgrade_9[index - indexOffset];

		case 9:
			return bWeaponUpgrade_10[index - indexOffset];

		case 10:
			return bWeaponUpgrade_11[index - indexOffset];

		case 11:
			return bWeaponUpgrade_12[index - indexOffset];

		case 12:
			return bWeaponUpgrade_13[index - indexOffset];

		case 13:
			return bWeaponUpgrade_14[index - indexOffset];

		case 14:
			return bWeaponUpgrade_15[index - indexOffset];

		case 15:
			return bWeaponUpgrade_16[index - indexOffset];

		default:
			return 0;
	}
}

simulated function IncermentWeaponUpgrade(int index)
{
	local int div, indexOffset;

	div = index / 255;
	indexOffset = div * 255;

	switch (div)
	{
		case 0:
			++bWeaponUpgrade_1[index - indexOffset];
			break;

		case 1:
			++bWeaponUpgrade_2[index - indexOffset];
			break;

		case 2:
			++bWeaponUpgrade_3[index - indexOffset];
			break;

		case 3:
			++bWeaponUpgrade_4[index - indexOffset];
			break;

		case 4:
			++bWeaponUpgrade_5[index - indexOffset];
			break;

		case 5:
			++bWeaponUpgrade_6[index - indexOffset];
			break;

		case 6:
			++bWeaponUpgrade_7[index - indexOffset];
			break;

		case 7:
			++bWeaponUpgrade_8[index - indexOffset];
			break;

		case 8:
			++bWeaponUpgrade_9[index - indexOffset];
			break;

		case 9:
			++bWeaponUpgrade_10[index - indexOffset];
			break;

		case 10:
			++bWeaponUpgrade_11[index - indexOffset];
			break;

		case 11:
			++bWeaponUpgrade_12[index - indexOffset];
			break;

		case 12:
			++bWeaponUpgrade_13[index - indexOffset];
			break;

		case 13:
			++bWeaponUpgrade_14[index - indexOffset];
			break;

		case 14:
			++bWeaponUpgrade_15[index - indexOffset];
			break;

		case 15:
			++bWeaponUpgrade_16[index - indexOffset];
			break;

		default:
			return;
	}
}

simulated function SetWeaponUpgrade(int index, int value)
{
	local int div, indexOffset;

	div = index / 255;
	indexOffset = div * 255;

	switch (div)
	{
		case 0:
			bWeaponUpgrade_1[index - indexOffset] = value;
			break;

		case 1:
			bWeaponUpgrade_2[index - indexOffset] = value;
			break;

		case 2:
			bWeaponUpgrade_3[index - indexOffset] = value;
			break;

		case 3:
			bWeaponUpgrade_4[index - indexOffset] = value;
			break;

		case 4:
			bWeaponUpgrade_5[index - indexOffset] = value;
			break;

		case 5:
			bWeaponUpgrade_6[index - indexOffset] = value;
			break;

		case 6:
			bWeaponUpgrade_7[index - indexOffset] = value;
			break;

		case 7:
			bWeaponUpgrade_8[index - indexOffset] = value;
			break;

		case 8:
			bWeaponUpgrade_9[index - indexOffset] = value;
			break;

		case 9:
			bWeaponUpgrade_10[index - indexOffset] = value;
			break;

		case 10:
			bWeaponUpgrade_11[index - indexOffset] = value;
			break;

		case 11:
			bWeaponUpgrade_12[index - indexOffset] = value;
			break;

		case 12:
			bWeaponUpgrade_13[index - indexOffset] = value;
			break;

		case 13:
			bWeaponUpgrade_14[index - indexOffset] = value;
			break;

		case 14:
			bWeaponUpgrade_15[index - indexOffset] = value;
			break;

		case 15:
			bWeaponUpgrade_16[index - indexOffset] = value;
			break;

		default:
			return;
	}
}

simulated function SetSyncTimer(const WMUI_UPGMenu Menu, int ItemDefinition)
{
	SyncMenuObject = Menu;
	SyncItemDefinition = ItemDefinition;
	SyncLoopCounter = 0;
	SetTimer(0.375f, True, NameOf(SyncTimerLoop));
}

simulated function SyncTimerLoop()
{
	if (SyncCompleted || SyncLoopCounter >= 7)
	{
		SyncCompleted = True; //For timeout case
		ClearTimer(NameOf(SyncTimerLoop));

		if (SyncMenuObject != None)
			SyncMenuObject.Callback_Equip(SyncItemDefinition);

		SyncMenuObject = None;
		SyncItemDefinition = -1;
	}

	++SyncLoopCounter;
}

simulated function SetRerollSyncTimer(const WMUI_UPGMenu Menu, int PerkIndex)
{
	SyncMenuObject = Menu;
	SyncItemDefinition = PerkIndex;
	SyncLoopCounter = 0;
	SetTimer(0.375f, True, NameOf(SyncRerollTimerLoop));
}

simulated function SyncRerollTimerLoop()
{
	if (RerollSyncCompleted || SyncLoopCounter >= 7)
	{
		RerollSyncCompleted = True; //For timeout case
		ClearTimer(NameOf(SyncRerollTimerLoop));

		if (SyncMenuObject != None)
			SyncMenuObject.SkillRerollUnlock(SyncItemDefinition);

		SyncMenuObject = None;
		SyncItemDefinition = -1;
	}

	++SyncLoopCounter;
}

simulated function bool SyncTimerActive()
{
	return IsTimerActive(NameOf(SyncTimerLoop)) || IsTimerActive(NameOf(SyncRerollTimerLoop));
}

defaultproperties
{
	PlayerLevel=0
	PerkIconIndex=254
	CurrentIconToDisplay=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'
	SyncCompleted=True
	RerollSyncCompleted=True
	PlatformType=0
	bHasVoted=False
	bVotingActive=False
	bHasPlayed=False

	Name="Default__WMPlayerReplicationInfo"
}
