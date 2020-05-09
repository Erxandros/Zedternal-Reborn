class WMPlayerReplicationInfo extends KFPlayerReplicationInfo;

//Replicated arrays
var name KFWeaponName[255];
var byte bPerkUpgrade[255];
var byte bPerkUpgradeAvailable[255];
var byte bWeaponUpgrade_A[255];
var byte bWeaponUpgrade_B[255];
var byte bSkillUpgrade[255];
var byte bSkillUnlocked[255];
var byte bSkillDeluxe[255];

// Current "perk" : perk's icon reflets where player spend his dosh (perk upgrades and skill upgrades)
var repnotify byte perkIconIndex;
var texture2D CurrentIconToDisplay;
var array< int > doshSpentOnPerk;
var int perkLvl;

// new opti array to track purchase of player (on server and client sides)
// used in WMPerk
var array< byte > purchase_perkUpgrade, purchase_skillUpgrade, purchase_weaponUpgrade;

replication
{
	if ( bNetDirty && (Role == Role_Authority) )
		KFWeaponName,bPerkUpgrade,bPerkUpgradeAvailable,bWeaponUpgrade_A,bWeaponUpgrade_B,bSkillUpgrade,bSkillUnlocked,bSkillDeluxe;

	if ( bNetDirty )
		perkIconIndex,perkLvl;
}

simulated event ReplicatedEvent(name VarName)
{
	local WMGameReplicationInfo WMGRI;
	
	if (VarName == 'perkIconIndex')
	{
		WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
		if (WMGRI != none)
			CurrentIconToDisplay = WMGRI.perkUpgrades[perkIconIndex].static.GetUpgradeIcon( bPerkUpgrade[perkIconIndex]-1 );
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
		for (i = 0; i < 255; i++)
		{
			WMPRI.KFWeaponName[i] = KFWeaponName[i];
			WMPRI.bPerkUpgrade[i] = bPerkUpgrade[i];
			WMPRI.bPerkUpgradeAvailable[i] = bPerkUpgradeAvailable[i];
			WMPRI.bWeaponUpgrade_A[i] = bWeaponUpgrade_A[i];
			WMPRI.bWeaponUpgrade_B[i] = bWeaponUpgrade_B[i];
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
			for (i=0; i<WMGRI.perkUpgrades.length; i+=1)
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
			CurrentIconToDisplay = WMGRI.perkUpgrades[perkIconIndex].static.GetUpgradeIcon( bPerkUpgrade[perkIconIndex]-1 );
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
	for (i = 0; i < 255; i++)
	{
		if (bPerkUpgrade[i] > 0)
			purchase_perkUpgrade.AddItem(i);
	}

	purchase_skillUpgrade.length = 0;
	for (i = 0; i < 255; i++)
	{
		if (bSkillUpgrade[i] > 0)
			purchase_skillUpgrade.AddItem(i);
	}

	purchase_weaponUpgrade.length = 0;
	for (i = 0; i < 510; i++)
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
	else
	{
		return bWeaponUpgrade_B[index - 255];
	}
}

simulated function IncermentWeaponUpgrade(int index)
{
	if (index < 255)
	{
		bWeaponUpgrade_A[index]++;
	}
	else
	{
		bWeaponUpgrade_B[index - 255]++;
	}
}

simulated function SetWeaponUpgrade(int index, int value)
{
	if (index < 255)
	{
		bWeaponUpgrade_A[index] = value;
	}
	else
	{
		bWeaponUpgrade_B[index - 255] = value;
	}
}

defaultproperties
{
	perkLvl=0
	perkIconIndex=254
	CurrentIconToDisplay=Texture2D'UI_PerkIcons_TEX.UI_Horzine_H_Logo'

	Name="Default__WMPlayerReplicationInfo"
}
