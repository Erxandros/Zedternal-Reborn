class WMPlayerController extends KFPlayerController
	config(ZedternalReborn_LocalData);

var int HUD_perkIndex;
var int UPG_UpgradeListIndex;
var bool bShouldUpdateHUDPerkIcon;
var bool bShouldUpdateGrenadeIcon;

var config byte KnifeIndex;
var config string GrenadePath;

//For scoreboard
var byte PlatformType;

//For command
var bool bUpgradeMenuOpen;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	PerkList.Length = 1;
	PerkList[0].PerkClass = Class'ZedternalReborn.WMPerk';

	SetTimer(2.0f, True, nameof(UpdatePerkIcon));

	if (WorldInfo.NetMode != NM_Client)
		SetTimer(0.5f, False, nameof(GetPlatform));
}

reliable client event ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if (WMPerk(CurrentPerk) != None)
		WMPerk(CurrentPerk).ReceiveLocalizedMessage(Message, Switch);
	super.ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

reliable server function BuyPerkUpgrade(int ItemDefinition, int Cost)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != None && WMPRI.Score >= Cost && WMPRI.bPerkUpgrade[ItemDefinition] < WMGameReplicationInfo(WorldInfo.GRI).perkMaxLevel)
	{
		++WMPRI.bPerkUpgrade[ItemDefinition];
		if (WMPRI.purchase_perkUpgrade.Find(ItemDefinition) == -1)
			WMPRI.purchase_perkUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.syncTrigger = !WMPRI.syncTrigger;
		}

		UpdateWeaponMagAndCap();

		WMPRI.UpdateCurrentIconToDisplay(ItemDefinition, Cost, 1);
	}
}

reliable server function BuyWeaponUpgrade(int ItemDefinition, int Cost)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != None && WMPRI.Score >= Cost && WMPRI.GetWeaponUpgrade(ItemDefinition) < WMGameReplicationInfo(WorldInfo.GRI).weaponMaxLevel)
	{
		WMPRI.IncermentWeaponUpgrade(ItemDefinition);
		if (WMPRI.purchase_weaponUpgrade.Find(ItemDefinition) == -1)
			WMPRI.purchase_weaponUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.syncTrigger = !WMPRI.syncTrigger;
		}

		UpdateWeaponMagAndCap();
	}
}

reliable server function BuySkillUpgrade(int ItemDefinition, int PerkItemDefinition, int Cost, int lvl)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != None && WMPRI.Score >= Cost)
	{
		WMPRI.bSkillUpgrade[ItemDefinition] = min(WMPRI.bSkillUpgrade[ItemDefinition] + lvl, 2);
		if (WMPRI.purchase_skillUpgrade.Find(ItemDefinition) == -1)
			WMPRI.purchase_skillUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.syncTrigger = !WMPRI.syncTrigger;
		}

		UpdateWeaponMagAndCap();

		if (lvl > 1)
			WMPRI.UpdateCurrentIconToDisplay(PerkItemDefinition, Cost, 3); // Deluxe skills give +3 lvl
		else
			WMPRI.UpdateCurrentIconToDisplay(PerkItemDefinition, Cost, 1);
	}
}

reliable server function UnlockSkill(int index, bool deluxe)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != None)
	{
		WMPRI.bSkillUnlocked[index] = 1;
		if (deluxe)
			WMPRI.bSkillDeluxe[index] = 1;
	}
}

reliable server function RerollSkillsForPerk(string RerollPerkPathName, int Cost)
{
	local WMGameReplicationInfo WMGRI;
	local WMPlayerReplicationInfo WMPRI;
	local int i;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);
	if (WMPRI != None && WMGRI != None && WMPRI.Score >= Cost)
	{
		for (i = 0; i < WMGRI.skillUpgrades.length; ++i)
		{
			if (RerollPerkPathName ~= WMGRI.skillUpgrades[i].PerkPathName)
			{
				WMPRI.bSkillUpgrade[i] = 0;
				WMPRI.bSkillUnlocked[i] = 0;
				WMPRI.bSkillDeluxe[i] = 0;

				if (WMPRI.purchase_skillUpgrade.Find(i) != INDEX_NONE)
					WMPRI.purchase_skillUpgrade.RemoveItem(i);
			}
		}

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.syncTrigger = !WMPRI.syncTrigger;
		}

		WMPRI.UpdatePerkAndSkillPurchases();
	}
}

function UpdateWeaponMagAndCap()
{
	local WMPawn_Human WMPH;
	local KFWeapon KFW;
	local Inventory Inv;
	local WMPerk WMP;

	// Compile passive bonuses
	WMP = WMPerk(CurrentPerk);
	if (WMP != None)
		WMP.ClientAndServerComputePassiveBonuses();
	UpdateClientPerkBonuses();

	//New Weight, Mag Size and max capacity
	if (WMP != None)
	{
		WMP.ApplyWeightLimits();
		WMPH = WMPawn_Human(Pawn);
		if (WMPH != None)
		{
			if (WMPH.InvManager != None)
			{
				for (Inv = WMPH.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
				{
					KFW = KFWeapon(Inv);
					if (KFW != None)
					{
						// Reinitialize ammo counts
						KFW.ReInitializeAmmoCounts(CurrentPerk);
					}
				}
			}
			// Also modify Health and Armor
			WMP.ModifyHealth(WMPH.Health);
			WMP.ModifyHealth(WMPH.HealthMax);
			WMP.ModifyArmorInt(WMPH.ZedternalMaxArmor);
			WMP.ModifyMaxSpareGrenadeAmount();
		}

		// Also update perk info
		WMP.ApplySkillsToPawn();
	}
}

reliable client function UpdateClientPerkBonuses()
{
	local WMPerk WMP;

	WMP = WMPerk(CurrentPerk);
	if (WMP != None)
	{
		WMP.ClientAndServerComputePassiveBonuses();
		WMP.ModifyMaxSpareGrenadeAmount();
	}
}

function DelayedPerkUpdate(float TimeOffset)
{
	SetTimer(TimeOffset + 2.5f, False, nameof(UpdateWeaponMagAndCap));
}

reliable client function SetPreferredGrenadeTimer()
{
	SetTimer(3.0f, True, nameof(CheckPreferredGrenade));
}

simulated function CheckPreferredGrenade()
{
	local WMGameReplicationInfo WMGRI;
	local byte i;
	local bool bFound;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	if (WMGRI != None && WMGRI.Grenades.length > 0)
	{
		ClearTimer(nameof(CheckPreferredGrenade));

		bFound = False;
		for (i = 0; i < 255; ++i)
		{
			if (WMGRI.grenadesStr[i] ~= "")
				break;

			if (WMGRI.grenadesStr[i] ~= GrenadePath)
			{
				bFound = True;
				break;
			}
		}

		if (bFound)
			ChangeGrenade(i);
	}
}

simulated function ChangeGrenade(int Index)
{
	CurrentPerk.GrenadeWeaponDef = WMGameReplicationInfo(WorldInfo.GRI).Grenades[Index];
	CurrentPerk.GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject(CurrentPerk.GrenadeWeaponDef.default.WeaponClassPath, class'Class'));
	ChangeGrenadeServer(Index);

	bShouldUpdateGrenadeIcon = True;

	GrenadePath = WMGameReplicationInfo(WorldInfo.GRI).grenadesStr[Index];
	SaveConfig();
}

reliable server function ChangeGrenadeServer(int Index)
{
	CurrentPerk.GrenadeWeaponDef = WMGameReplicationInfo(WorldInfo.GRI).Grenades[Index];
	CurrentPerk.GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject(CurrentPerk.GrenadeWeaponDef.default.WeaponClassPath, class'Class'));
}

simulated function ChangeKnife(int Index)
{
	local Inventory Inv;
	local KFWeapon KFW;
	local class<Inventory> KnifeClass;

	if (WMPerk(CurrentPerk) != None)
	{
		KnifeClass = class<Inventory>(DynamicLoadObject(WMPerk(CurrentPerk).KnivesWeaponDef[Index].default.WeaponClassPath, class'Class'));
		if (!KFInventoryManager(Pawn.InvManager).ClassIsInInventory(KnifeClass, Inv))
		{
			// remove all backup knives from inventory
			for (Inv = Pawn.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
			{
				KFW = KFWeapon(Inv);
				if (KFW != None && !KFW.CanThrow() && KFWeap_Edged_Knife(KFW) != None && KFW.class != KnifeClass)
					Pawn.InvManager.RemoveFromInventory(Inv);
			}

			// change knife
			ChangeKnifeServer(index);

			// Change knifeindex and save it as local data (client side)
			KnifeIndex = Index;
			SaveConfig();
		}
	}
}

reliable server function ChangeKnifeServer(int index)
{
	Pawn.InvManager.CreateInventory(class<Inventory>(DynamicLoadObject(WMPerk(CurrentPerk).KnivesWeaponDef[Index].default.WeaponClassPath, class'Class')), Pawn.Weapon != None);
}

function float GetPerkLevelProgressPercentage(Class<KFPerk> PerkClass, optional out int CurrentLevelEXP, optional out int NextLevelEXP)
{
	return 0.0f;
}

simulated function int GetCurrentLevel()
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	if (WMPRI != None)
		return WMPRI.perkLvl;
	else
		return 0;
}

simulated function string GetPerkIconPath()
{
	local WMPlayerReplicationInfo WMPRI;
	local WMGameReplicationInfo WMGRI;
	local int tries;

	if (Pawn != None)
		WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);
	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	bShouldUpdateHUDPerkIcon = False;

	if (WMPRI != None && WMGRI != None && WMPRI.perkLvl > 0)
	{
		tries = WMGRI.perkUpgrades.length;
		while (tries > 0)
		{
			++HUD_perkIndex;
			--tries;
			if (HUD_perkIndex >= WMGRI.perkUpgrades.length)
				HUD_perkIndex = 0;

			if (WMPRI.bPerkUpgrade[HUD_perkIndex] > 0)
				return PathName(WMGRI.perkUpgrades[HUD_perkIndex].static.GetUpgradeIcon(WMPRI.bPerkUpgrade[HUD_perkIndex] - 1));
		}
	}

	return CurrentPerk.GetPerkIconPath();
}

simulated function UpdatePerkIcon()
{
	bShouldUpdateHUDPerkIcon = True;
}

function NotifyAddInventory(Inventory NewItem)
{
	super.NotifyAddInventory(NewItem);

	if (KFWeapon(NewItem) != None)
		Spawn(class'WMWeaponAmmoFix', NewItem);
}

reliable client function GetPlatform()
{
	//If the server calls GetPlatform on the server and not the client, try again
	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		SetTimer(1.0f, False, nameof(GetPlatform));
		return;
	}

	if (WorldInfo.static.IsEOSBuild()) //Epic
	{
		PlatformType = 2;
		UpdatePlatform(2);
	}
	else //Steam
	{
		PlatformType = 1;
		UpdatePlatform(1);
	}
}

reliable server function UpdatePlatform(byte Platform)
{
	PlatformType = Platform;
	SetTimer(0.5f, False, nameof(SyncPlatform));
}

function SyncPlatform()
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	if (WMPRI != None)
		WMPRI.PlatformType = PlatformType;
	else
		SetTimer(1.0f, False, nameof(SyncPlatform));
}

unreliable server function ServerUpdatePing(int NewPing)
{
	local WMPlayerReplicationInfo WMPRI;
	super.ServerUpdatePing(NewPing);

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	if (WMPRI != None)
		WMPRI.UncompressedPing = NewPing;
}

exec function OpenZedternalUpgradeMenu()
{
	local WMPlayerReplicationInfo WMPRI;
	local WMGameReplicationInfo WMGRI;

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMPRI != None && WMGRI != None)
	{
		if (WMGRI.bZRUMenuCommand && (WMGRI.bTraderIsOpen || WMGRI.bZRUMenuAllWave) && Pawn.IsAliveAndWell() && !WMPRI.bIsSpectator && !WMPRI.bWaitingPlayer && !GetMenuInfo().bMenusOpen)
			WMPRI.CreateUPGMenu();
	}
}

function PawnDied(Pawn inPawn)
{
	if (inPawn == Pawn)
	{
		PawnDiedCloseUPGMenu();
	}

	super.PawnDied(inPawn);
}

reliable client function PawnDiedCloseUPGMenu()
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);

	if (WMPRI != None && bUpgradeMenuOpen)
		WMPRI.CloseUPGMenu();
}

defaultproperties
{
	PurchaseHelperClass=class'WMAutoPurchaseHelper'
	HUD_perkIndex=-1
	bUpgradeMenuOpen=False
	bShouldUpdateHUDPerkIcon=True
	bShouldUpdateGrenadeIcon=True
	UPG_UpgradeListIndex=1
	PerkList(0)=(PerkClass=Class'ZedternalReborn.WMPerk')
	ServPendingPerkBuild=-1
	ServPendingPerkLevel=-1
	PlatformType=0

	Name="Default__WMPlayerController"
}
