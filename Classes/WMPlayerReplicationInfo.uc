class WMPlayerReplicationInfo extends KFPlayerReplicationInfo;

//Replicated arrays
var repnotify byte bPerkUpgrade[255];
var byte bPerkUpgradeAvailable[255];
var repnotify byte bWeaponUpgrade_A[255];
var repnotify byte bWeaponUpgrade_B[255];
var repnotify byte bWeaponUpgrade_C[255];
var repnotify byte bWeaponUpgrade_D[255];
var repnotify byte bSkillUpgrade[255];
var byte bSkillUnlocked[255];
var byte bSkillDeluxe[255];

// Current "perk" : perk's icon reflets where player spend his dosh (perk upgrades and skill upgrades)
var repnotify byte perkIconIndex;
var texture2D CurrentIconToDisplay;
var array< int > doshSpentOnPerk;
var int perkLvl;

// Sync variables
var repnotify bool syncTrigger;
var bool syncCompleted;
var WMUI_UPGMenu syncMenuObject;
var int syncItemDefinition;
var byte syncLoopCounter;

// dynamic array used to track purchases of player (on server and client sides)
// used in WMPerk
var array< byte > purchase_perkUpgrade, purchase_skillUpgrade;
var array< int > purchase_weaponUpgrade;

replication
{
	if ( bNetDirty && (Role == Role_Authority) )
		bPerkUpgrade, bPerkUpgradeAvailable, bWeaponUpgrade_A, bWeaponUpgrade_B, bWeaponUpgrade_C, bWeaponUpgrade_D,
		bSkillUpgrade, bSkillUnlocked, bSkillDeluxe;

	if ( bNetDirty )
		perkIconIndex, perkLvl, syncTrigger;
}

simulated event ReplicatedEvent(name VarName)
{
	local WMGameReplicationInfo WMGRI;

	if (VarName == 'syncTrigger')
		return; //do nothing
	else if (VarName == 'perkIconIndex')
	{
		WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
		if (WMGRI != none)
			CurrentIconToDisplay = WMGRI.perkUpgrades[perkIconIndex].static.GetUpgradeIcon( bPerkUpgrade[perkIconIndex] - 1 );
	}
	else if (VarName == 'bPerkUpgrade' || VarName == 'bWeaponUpgrade_A' || VarName == 'bWeaponUpgrade_B' ||
			VarName == 'bWeaponUpgrade_C' || VarName == 'bWeaponUpgrade_D' || VarName == 'bSkillUpgrade')
	{
		syncCompleted = true;
	}
	else
		super.ReplicatedEvent(VarName);
}

function CopyProperties(PlayerReplicationInfo PRI)
{
	local WMPlayerReplicationInfo WMPRI;
	local WMPlayerController WMP;
	local WMPerk Perk;
	local byte i;

	WMPRI = WMPlayerReplicationInfo(PRI);

	if (WMPRI != none)
	{
		for (i = 0; i < 255; ++i)
		{
			WMPRI.bPerkUpgrade[i] = bPerkUpgrade[i];
			WMPRI.bPerkUpgradeAvailable[i] = bPerkUpgradeAvailable[i];
			WMPRI.bWeaponUpgrade_A[i] = bWeaponUpgrade_A[i];
			WMPRI.bWeaponUpgrade_B[i] = bWeaponUpgrade_B[i];
			WMPRI.bWeaponUpgrade_C[i] = bWeaponUpgrade_C[i];
			WMPRI.bWeaponUpgrade_D[i] = bWeaponUpgrade_D[i];
			WMPRI.bSkillUpgrade[i] = bSkillUpgrade[i];
			WMPRI.bSkillUnlocked[i] = bSkillUnlocked[i];
			WMPRI.bSkillDeluxe[i] = bSkillDeluxe[i];
		}

		WMPRI.perkLvl = perkLvl;

		WMP = WMPlayerController(WMPRI.KFPlayerOwner);
		if (WMP != none)
		{
			Perk = WMPerk(WMP.CurrentPerk);
			if (Perk != none)
				Perk.ServerComputePassiveBonuses();
		}
	}

	super.CopyProperties(PRI);
}

simulated function byte GetActivePerkLevel()
{
	return perkLvl;
}

simulated function byte GetActivePerkPrestigeLevel()
{
	return 0;
}

simulated function Texture2D GetCurrentIconToDisplay()
{
	return CurrentIconToDisplay;
}

function UpdateCurrentIconToDisplay(int lastBoughtIndex, int doshSpent, int lvl)
{
	// function called every time a perk upgrade or skill upgrade is bought
	// will update perk icon based on dosh spent by the player
	// will also increase player level by one

	local WMGameReplicationInfo WMGRI;
	local byte i;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI != none)
	{
		// initialize doshRecord if needed
		if (perkIconIndex == 254)
		{
			for (i = 0; i < WMGRI.perkUpgrades.length; ++i)
			{
				doshSpentOnPerk[i] = 0;
			}
		}

		// record dosh spent on perk[index] related upgrades
		doshSpentOnPerk[lastBoughtIndex] += doshSpent;

		// check and update player's perk icon index
		if (perkIconIndex == 254 || doshSpentOnPerk[lastBoughtIndex] >= doshSpentOnPerk[perkIconIndex])
		{
			perkIconIndex = lastBoughtIndex;
			CurrentIconToDisplay = WMGRI.perkUpgrades[perkIconIndex].static.GetUpgradeIcon( bPerkUpgrade[perkIconIndex] - 1 );
		}

		// increase player level
		perkLvl += lvl;
	}
}

reliable client function UpdateClientPurchase()
{
	UpdatePurchase();
}

simulated function UpdatePurchase()
{
	local WMPlayerController LocalPC;
	local WMPerk Perk;
	local int i;

	purchase_perkUpgrade.length = 0;
	for (i = 0; i < 255; ++i)
	{
		if (bPerkUpgrade[i] > 0)
			purchase_perkUpgrade.AddItem(i);
	}

	purchase_skillUpgrade.length = 0;
	for (i = 0; i < 255; ++i)
	{
		if (bSkillUpgrade[i] > 0)
			purchase_skillUpgrade.AddItem(i);
	}

	purchase_weaponUpgrade.length = 0;
	for (i = 0; i < 1020; ++i)
	{
		if (GetWeaponUpgrade(i) > 0)
			purchase_weaponUpgrade.AddItem(i);
	}

	LocalPC = WMPlayerController(GetALocalPlayerController());
	if (LocalPC != none)
	{
		Perk = WMPerk(LocalPC.CurrentPerk);
		if (Perk != none)
			Perk.ClientAndServerComputePassiveBonuses();
	}
}

simulated function CreateUPGMenu()
{
	local WMUI_Menu UPGMenu;
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(Owner);

	UPGMenu = new class'ZedternalReborn.WMUI_Menu';
	UPGMenu.Owner = KFPawn_Human(KFPC.Pawn);
	UPGMenu.KFPC = KFPC;
	UPGMenu.KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
	UPGMenu.SetTimingMode(TM_Real);
	UPGMenu.Init(LocalPLayer(KFPC.Player));
}

simulated function byte GetWeaponUpgrade(int index)
{
	if (index < 255)
	{
		return bWeaponUpgrade_A[index];
	}
	else if (index < 510)
	{
		return bWeaponUpgrade_B[index - 255];
	}
	else if (index < 765)
	{
		return bWeaponUpgrade_C[index - 510];
	}
	else
	{
		return bWeaponUpgrade_D[index - 765];
	}
}

simulated function IncermentWeaponUpgrade(int index)
{
	if (index < 255)
	{
		++bWeaponUpgrade_A[index];
	}
	else if (index < 510)
	{
		++bWeaponUpgrade_B[index - 255];
	}
	else if (index < 765)
	{
		++bWeaponUpgrade_C[index - 510];
	}
	else
	{
		++bWeaponUpgrade_D[index - 765];
	}
}

simulated function SetWeaponUpgrade(int index, int value)
{
	if (index < 255)
	{
		bWeaponUpgrade_A[index] = value;
	}
	else if (index < 510)
	{
		bWeaponUpgrade_B[index - 255] = value;
	}
	else if (index < 765)
	{
		bWeaponUpgrade_C[index - 510] = value;
	}
	else
	{
		bWeaponUpgrade_D[index - 765] = value;
	}
}


simulated function SetSyncTimer(const WMUI_UPGMenu menu, int ItemDefinition)
{
	syncMenuObject = menu;
	syncItemDefinition = ItemDefinition;
	syncLoopCounter = 0;
	SetTimer(0.1f, true, 'SyncTimerLoop');
}

simulated function SyncTimerLoop()
{
	if (syncCompleted || syncLoopCounter >= 30)
	{
		ClearTimer('SyncTimerLoop');
		syncMenuObject.Callback_Equip(syncItemDefinition);
	}

	++syncLoopCounter;
}

simulated function bool SyncTimerActive()
{
	return IsTimerActive('SyncTimerLoop');
}

defaultproperties
{
	perkLvl=0
	perkIconIndex=254
	CurrentIconToDisplay=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'
	syncTrigger=false
	syncCompleted=true

	Name="Default__WMPlayerReplicationInfo"
}
