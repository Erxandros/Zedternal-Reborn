class WMPlayerController extends KFPlayerController;

var int HUD_perkIndex;
var int UPG_UpgradeListIndex;
var bool bShouldUpdateHUDPerkIcon;
var bool bShouldUpdateGrenadeIcon;

//For scoreboard
var byte PlatformType;

//For command
var bool bUpgradeMenuOpen;

//For damage collection
struct DamageCollector
{
	var class<DamageType> DT;
	var int Damage;
};
var array<DamageCollector> DmgArray;
var int HealPoints;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	PerkList.Length = 1;

	if (CurrentPerk == None)
		RequestPerkChange(0);

	SetTimer(2.0f, True, NameOf(UpdatePerkIcon));

	if (WorldInfo.NetMode != NM_Client)
		SetTimer(0.5f, False, NameOf(GetPlatform));
}

simulated function InitPerkLoadout()
{
}

simulated function byte CheckCurrentPerkAllowed()
{
	return SavedPerkIndex;
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

	if (WMPRI != None && WMPRI.Score >= Cost && WMPRI.bPerkUpgrade[ItemDefinition] < WMGameReplicationInfo(WorldInfo.GRI).PerkUpgMaxLevel)
	{
		++WMPRI.bPerkUpgrade[ItemDefinition];
		if (WMPRI.Purchase_PerkUpgrade.Find(ItemDefinition) == INDEX_NONE)
			WMPRI.Purchase_PerkUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.SyncTrigger = !WMPRI.SyncTrigger;
		}

		UpdateWeaponMagAndCap();

		WMPRI.UpdateCurrentIconToDisplay(ItemDefinition, Cost, 1);
	}
}

reliable server function BuyWeaponUpgrade(int ItemDefinition, int Cost)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != None && WMPRI.Score >= Cost && WMPRI.GetWeaponUpgrade(ItemDefinition) < WMGameReplicationInfo(WorldInfo.GRI).WeaponUpgradeSlotsList[ItemDefinition].MaxLevel)
	{
		WMPRI.IncermentWeaponUpgrade(ItemDefinition);
		if (WMPRI.Purchase_WeaponUpgrade.Find(ItemDefinition) == INDEX_NONE)
			WMPRI.Purchase_WeaponUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.SyncTrigger = !WMPRI.SyncTrigger;
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
		if (WMPRI.Purchase_SkillUpgrade.Find(ItemDefinition) == INDEX_NONE)
			WMPRI.Purchase_SkillUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.SyncTrigger = !WMPRI.SyncTrigger;
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
		for (i = 0; i < WMGRI.SkillUpgradesList.Length; ++i)
		{
			if (RerollPerkPathName ~= WMGRI.SkillUpgradesList[i].PerkPathName)
			{
				WMPRI.bSkillUpgrade[i] = 0;
				WMPRI.bSkillUnlocked[i] = 0;
				WMPRI.bSkillDeluxe[i] = 0;

				if (WMPRI.Purchase_SkillUpgrade.Find(i) != INDEX_NONE)
				{
					WMPRI.Purchase_SkillUpgrade.RemoveItem(i);
					WMGRI.SkillUpgradesList[i].SkillUpgrade.static.DeleteHelperClass(Pawn);
					WMGRI.SkillUpgradesList[i].SkillUpgrade.static.RevertUpgradeChanges(Pawn);
				}
			}
		}

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			++WMPRI.RerollCounter;
			WMPRI.RerollSyncTrigger = !WMPRI.RerollSyncTrigger;
		}

		UpdateWeaponMagAndCap();

		WMPRI.RecalculatePlayerLevel();
	}
}

reliable server function BuyEquipmentUpgrade(int ItemDefinition, int Cost)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != None && WMPRI.Score >= Cost && WMPRI.bEquipmentUpgrade[ItemDefinition] < WMGameReplicationInfo(WorldInfo.GRI).EquipmentUpgradesList[ItemDefinition].MaxLevel)
	{
		++WMPRI.bEquipmentUpgrade[ItemDefinition];
		if (WMPRI.Purchase_EquipmentUpgrade.Find(ItemDefinition) == INDEX_NONE)
			WMPRI.Purchase_EquipmentUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.SyncTrigger = !WMPRI.SyncTrigger;
		}

		UpdateWeaponMagAndCap();
		++WMPRI.PlayerLevel;
	}
}

reliable server function BuySidearm(int ItemDefinition, int Cost)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != None && WMPRI.Score >= Cost)
	{
		++WMPRI.bSidearmItem[ItemDefinition];
		if (WorldInfo.NetMode == NM_DedicatedServer)
		{
			WMPRI.AddDosh(-Cost);
			WMPRI.SyncTrigger = !WMPRI.SyncTrigger;
		}
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
		WMP.ApplySkillsToPawn();

	// Set client passive bonuses
	if (WorldInfo.NetMode == NM_DedicatedServer)
		UpdateClientPerkBonuses();

	//New Weight, Mag Size and max capacity
	if (WMP != None)
	{
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

unreliable client function ClientPlayCameraShake(CameraShake Shake, optional float Scale=1.0f, optional bool bTryForceFeedback, optional ECameraAnimPlaySpace PlaySpace=CAPS_CameraLocal, optional rotator UserPlaySpaceRot)
{
	local WMPerk WMP;

	WMP = WMPerk(CurrentPerk);
	if (WMP != None)
	{
		if (WMP.ImmuneToCameraShake())
			return;
	}

	super.ClientPlayCameraShake(Shake, Scale, bTryForceFeedback, PlaySpace, UserPlaySpaceRot);
}

function DelayedPerkUpdate(float TimeOffset)
{
	SetTimer(TimeOffset + 3.0f, False, NameOf(UpdateWeaponMagAndCap));
}

reliable client function SetPreferredSidearmTimer()
{
	SetTimer(1.0f, True, NameOf(CheckPreferredSidearm));
}

simulated function CheckPreferredSidearm()
{
	local WMGameReplicationInfo WMGRI;
	local WMPlayerReplicationInfo WMPRI;
	local byte i;
	local bool bFound;
	local string SidearmPath;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	if (WMGRI != None && WMPRI != None && CurrentPerk != None && WMGRI.bSidearmItemsSynced)
	{
		ClearTimer(NameOf(CheckPreferredSidearm));

		if (WMPRI.bHasPlayed)
		{
			CurrentPerk.SetSecondaryWeaponSelectedIndex(WMPRI.SelectedSidarmIndex);
			return;
		}

		SidearmPath = class'ZedternalReborn.Config_LocalPreferences'.static.GetSidearmPath();
		bFound = False;
		for (i = 0; i < 255; ++i)
		{
			if (WMGRI.SidearmsRepArray[i].WeaponPathName ~= "")
				break;

			if (WMGRI.SidearmsRepArray[i].WeaponPathName ~= SidearmPath && WMGRI.SidearmsRepArray[i].BuyPrice <= 0)
			{
				bFound = True;
				break;
			}
		}

		if (bFound)
			CurrentPerk.SetSecondaryWeaponSelectedIndex(i);
	}
}

reliable client simulated function ChangeSidearm(int index)
{
	local Inventory Inv;
	local class<Inventory> SidearmClass;

	SidearmClass = class<Inventory>(DynamicLoadObject(WMGameReplicationInfo(WorldInfo.GRI).SidearmsList[index].Sidearm.default.WeaponClassPath, class'Class'));
	if (!KFInventoryManager(Pawn.InvManager).ClassIsInInventory(SidearmClass, Inv))
	{
		// Remove previous sidearm
		for (Inv = Pawn.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
		{
			if (CurrentPerk.GetSecondaryWeaponClassPath() ~= PathName(Inv.Class)
				|| (KFWeap_DualBase(Inv) != None && CurrentPerk.GetSecondaryWeaponClassPath() ~= PathName(KFWeap_DualBase(Inv).default.SingleClass)))
			{
				WMInventoryManager(Pawn.InvManager).DeleteFromInventory(Inv);
				break;
			}
		}

		// Change sidearm
		ChangeSidearmServer(index);
		CurrentPerk.SetSecondaryWeaponSelectedIndex(index);

		// Save selected sidearm if it is free
		if (WMGameReplicationInfo(WorldInfo.GRI).SidearmsList[index].BuyPrice <= 0)
			class'ZedternalReborn.Config_LocalPreferences'.static.SetSidearmPath(WMGameReplicationInfo(WorldInfo.GRI).SidearmsRepArray[index].WeaponPathName);
	}
}

reliable server function ChangeSidearmServer(int index)
{
	WMInventoryManager(Pawn.InvManager).CreateInventorySidearm(class<Inventory>(DynamicLoadObject(WMGameReplicationInfo(WorldInfo.GRI).SidearmsList[index].Sidearm.default.WeaponClassPath, class'Class')), Pawn.Weapon != None);
}

reliable client function SetPreferredGrenadeTimer()
{
	SetTimer(1.0f, True, NameOf(CheckPreferredGrenade));
}

simulated function CheckPreferredGrenade()
{
	local WMGameReplicationInfo WMGRI;
	local byte i;
	local bool bFound;
	local string GrenadePath;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	if (WMGRI != None && CurrentPerk != None && WMGRI.bGrenadeItemsSynced)
	{
		ClearTimer(NameOf(CheckPreferredGrenade));

		GrenadePath = class'ZedternalReborn.Config_LocalPreferences'.static.GetGrenadePath();
		bFound = False;
		for (i = 0; i < 255; ++i)
		{
			if (WMGRI.GrenadesRepArray[i].GrenadePathName ~= "")
				break;

			if (WMGRI.GrenadesRepArray[i].GrenadePathName ~= GrenadePath)
			{
				bFound = True;
				break;
			}
		}

		if (bFound)
			ChangeGrenade(i);
	}
}

reliable client simulated function ChangeGrenade(int index)
{
	CurrentPerk.GrenadeWeaponDef = WMGameReplicationInfo(WorldInfo.GRI).GrenadesList[index].Grenade;
	// Replace Tripwire medic grenade with ZedternalReborn version to fix bug with sonic resistant rounds
	if (CurrentPerk.GrenadeWeaponDef.default.WeaponClassPath ~= "KFGameContent.KFProj_MedicGrenade")
		CurrentPerk.GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject("ZedternalReborn.WMProj_MedicGrenade", class'Class'));
	else
		CurrentPerk.GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject(CurrentPerk.GrenadeWeaponDef.default.WeaponClassPath, class'Class'));
	ChangeGrenadeServer(index);

	bShouldUpdateGrenadeIcon = True;

	class'ZedternalReborn.Config_LocalPreferences'.static.SetGrenadePath(WMGameReplicationInfo(WorldInfo.GRI).GrenadesRepArray[index].GrenadePathName);
}

reliable server function ChangeGrenadeServer(int index)
{
	CurrentPerk.GrenadeWeaponDef = WMGameReplicationInfo(WorldInfo.GRI).GrenadesList[index].Grenade;
	// Replace Tripwire medic grenade with ZedternalReborn version to fix bug with sonic resistant rounds
	if (CurrentPerk.GrenadeWeaponDef.default.WeaponClassPath ~= "KFGameContent.KFProj_MedicGrenade")
		CurrentPerk.GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject("ZedternalReborn.WMProj_MedicGrenade", class'Class'));
	else
		CurrentPerk.GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject(CurrentPerk.GrenadeWeaponDef.default.WeaponClassPath, class'Class'));
}

reliable client function SetPreferredKnifeTimer()
{
	SetTimer(1.0f, True, NameOf(CheckPreferredKnife));
}

simulated function CheckPreferredKnife()
{
	local WMPerk WMP;

	WMP = WMPerk(CurrentPerk);
	if (WMP != None)
	{
		ClearTimer(NameOf(CheckPreferredKnife));
		WMP.SetKnifeSelectedIndex(class'ZedternalReborn.Config_LocalPreferences'.static.GetKnifeIndex());
	}
}

reliable client simulated function ChangeKnife(int index)
{
	local Inventory Inv;
	local class<Inventory> KnifeClass;

	if (WMPerk(CurrentPerk) != None)
	{
		KnifeClass = class<Inventory>(DynamicLoadObject(WMPerk(CurrentPerk).KnivesWeaponDef[index].default.WeaponClassPath, class'Class'));
		if (!KFInventoryManager(Pawn.InvManager).ClassIsInInventory(KnifeClass, Inv))
		{
			// Find old knife and remove it
			for (Inv = Pawn.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
			{
				if (CurrentPerk.GetKnifeWeaponClassPath() ~= PathName(Inv.Class))
				{
					WMInventoryManager(Pawn.InvManager).DeleteFromInventory(Inv);
					break;
				}
			}

			// Change selected knife
			ChangeKnifeServer(index);
			WMPerk(CurrentPerk).SetKnifeSelectedIndex(index);

			// Change selected knife index and save it as local data (client side)
			class'ZedternalReborn.Config_LocalPreferences'.static.SetKnifeIndex(index);
		}
	}
}

reliable server function ChangeKnifeServer(int index)
{
	Pawn.InvManager.CreateInventory(class<Inventory>(DynamicLoadObject(WMPerk(CurrentPerk).KnivesWeaponDef[index].default.WeaponClassPath, class'Class')), Pawn.Weapon != None);
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
		return WMPRI.PlayerLevel;
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

	if (WMPRI != None && WMGRI != None && WMPRI.PlayerLevel > 0)
	{
		tries = WMGRI.PerkUpgradesList.Length;
		while (tries > 0)
		{
			++HUD_perkIndex;
			--tries;
			if (HUD_perkIndex >= WMGRI.PerkUpgradesList.Length)
				HUD_perkIndex = 0;

			if (WMPRI.bPerkUpgrade[HUD_perkIndex] > 0)
				return PathName(WMGRI.PerkUpgradesList[HUD_perkIndex].PerkUpgrade.static.GetUpgradeIcon(WMPRI.bPerkUpgrade[HUD_perkIndex] - 1));
		}
	}

	return CurrentPerk.GetPerkIconPath();
}

simulated function UpdatePerkIcon()
{
	bShouldUpdateHUDPerkIcon = True;
}

simulated function SetNightVision(bool bEnabled)
{
	if (WMPerk(CurrentPerk) != None)
		WMPerk(CurrentPerk).ApplyBatteryRechargeRate();

	super.SetNightVision(bEnabled);
}

reliable client function GetPlatform()
{
	//If the server calls GetPlatform on the server and not the client, try again
	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		SetTimer(1.0f, False, NameOf(GetPlatform));
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
	SetTimer(0.5f, False, NameOf(SyncPlatform));
}

function SyncPlatform()
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	if (WMPRI != None)
		WMPRI.PlatformType = PlatformType;
	else
		SetTimer(1.0f, False, NameOf(SyncPlatform));
}

unreliable server function ServerUpdatePing(int NewPing)
{
	local WMPlayerReplicationInfo WMPRI;
	super.ServerUpdatePing(NewPing);

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	if (WMPRI != None)
		WMPRI.UncompressedPing = NewPing;
}

exec function RequestPauseGame()
{
	local WMGameReplicationInfo WMGRI;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMGRI == None || WMGRI.bPauseButtonEnabled)
		super.RequestPauseGame();
}

exec function OpenZedternalUpgradeMenu()
{
	ShowUpgradeMenu();
}

exec function OpenUpgradeMenu()
{
	ShowUpgradeMenu();
}

exec function OZUM()
{
	ShowUpgradeMenu();
}

function ShowUpgradeMenu()
{
	local WMPlayerReplicationInfo WMPRI;
	local WMGameReplicationInfo WMGRI;

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (WMPRI != None && WMGRI != None)
	{
		if (WMGRI.bZRUMenuCommand && (WMGRI.bTraderIsOpen || WMGRI.bZRUMenuAllWave) && Pawn.IsAliveAndWell()
			&& !WMPRI.bIsSpectator && !WMPRI.bWaitingPlayer && !GetMenuInfo().bMenusOpen
			&& (!WMGRI.bIsPaused || !WMGRI.bNoTraderDuringPause))
		{
			WMPRI.CreateUPGMenu();
		}
	}
}

function PawnDied(Pawn inPawn)
{
	if (inPawn == Pawn)
	{
		PawnDiedCloseUPGMenu();
		SendAllStats();
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

function NotifyXPGain(class<KFPerk> PerkClass, int Amount, int BonusXP)
{
	// Do nothing
}

function NotifyLevelUp(class<KFPerk> PerkClass, byte PerkLevel, byte NewPrestigeLevel)
{
	// Do nothing
}

static simulated function KFInterface_Usable GetCurrentUsableActor(Pawn P, optional bool bUseOnFind=False)
{
	local KFInterface_Usable UsableActor;
	local Actor A, BestActor;

	local KFInterface_Usable BestUsableActor;
	local int InteractionIndex, BestInteractionIndex;

	local WMGameReplicationInfo WMGRI;

	BestInteractionIndex = -1;

	if (P != None)
	{
		// On endless mode, if game is paused players can move but not interact with objects.
		WMGRI = WMGameReplicationInfo(P.WorldInfo.GRI);
		if (WMGRI != None && WMGRI.bNoTraderDuringPause)
			return None;

		// Check touching -- Useful when UsedBy() is implemented by subclass instead of kismet
		ForEach P.TouchingActors(class'Actor', A)
		{
			UsableActor = KFInterface_Usable(A);
			if (UsableActor != None && UsableActor.GetIsUsable(P))
			{
				// find the best usable by priority
				// use the usable's interaction index as priority, since the UI already sort of does that
				InteractionIndex = UsableActor.GetInteractionIndex(P);
				if (InteractionIndex > BestInteractionIndex)
				{
					BestInteractionIndex = InteractionIndex;
					BestUsableActor = UsableActor;
					BestActor = A;
				}
			}
		}

		if (BestUsableActor != None)
		{
			if (bUseOnFind)
				BestActor.UsedBy(P);

			return BestUsableActor;
		}
	}

	return None;
}

function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
	local int Idx;
	local vector cameraLoc, cameraDir;
	local rotator cameraRot;
	local Trigger checkTrigger;
	local SeqEvent_Used	UseSeq;
	local float aimEpsilon;
	local WMGameReplicationInfo WMGRI;

	if (Pawn == None)
		return;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	if (WMGRI != None && WMGRI.bNoTraderDuringPause)
		return;

	// search of nearby actors that have use events
	foreach Pawn.CollidingActors(class'Trigger', checkTrigger, interactDistanceToCheck)
	{
		for (Idx = 0; Idx < checkTrigger.GeneratedEvents.Length; ++Idx)
		{
			UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);
			if (UseSeq == None)
				continue;

			// one-time init of camera vars
			if (IsZero(cameraDir))
			{
				// grab camera location/rotation for checking crosshairDist
				GetPlayerViewPoint(cameraLoc, cameraRot);
				cameraDir = vector(cameraRot);
			}

			aimEpsilon = (UseSeq.bAimToInteract) ? 0.98f : minDot;

			// if bUsuableOnly is true then we must get true back from CheckActivate (which tests various validity checks on the player and on the trigger's trigger count and retrigger conditions etc)
			if ((!bUsuableOnly || (checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger,Pawn,true)))
				// check to see if we are within range of the trigger
				&& (VSizeSq(Pawn.Location - checkTrigger.Location) <= Square(UseSeq.InteractDistance))
				// check to see if we are looking at the object
				&& (Normal(checkTrigger.Location-cameraLoc) dot cameraDir >= aimEpsilon)
				// check bUseLineCheck
				&& (!UseSeq.bUseLineCheck || FastTrace(checkTrigger.Location, cameraLoc))
			)
			{
				out_useList[out_useList.Length] = checkTrigger;

				// don't bother searching for more events
				Idx = checkTrigger.GeneratedEvents.Length;
			}
		}
	}
}

function bool PerformedUseAction()
{
	local WMGameReplicationInfo WMGRI;

	// Intentionally do not trigger Super Class so that we do not close the menu
	if (WorldInfo.NetMode != NM_StandAlone)
		return Super.PerformedUseAction();

	// if the level is paused,
	if (Pawn == None)
		return True;

	// below is only on server
	if (Role < Role_Authority)
		return False;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	if (WMGRI != None && WMGRI.bNoTraderDuringPause)
		return False;

	// leave vehicle if currently in one
	if (Vehicle(Pawn) != None)
		return Vehicle(Pawn).DriverLeave(False);

	// try to find a vehicle to drive
	if (FindVehicleToDrive())
		return True;

	// try to interact with triggers
	return TriggerInteracted();
}

function bool DmgArrayBinarySearch(string DTName, out int Low)
{
	local string MidStr;
	local int Mid, High;

	DTName = Caps(DTName);
	Low = 0;
	High = DmgArray.Length - 1;
	while (Low <= High)
	{
		Mid = (Low + High) / 2;
		MidStr = Caps(PathName(DmgArray[Mid].DT));
		if (DTName < MidStr)
			High = Mid - 1;
		else if (DTName > MidStr)
			Low = Mid + 1;
		else
			return False;
	}

	return True;
}

function AddDamageStat(int DamageAmount, class<DamageType> DT)
{
	local int i;

	if (DmgArrayBinarySearch(PathName(DT), i))
	{
		DmgArray.Insert(i, 1);
		DmgArray[i].DT = DT;
		DmgArray[i].Damage = DamageAmount;
	}
	else
	{
		DmgArray[i].Damage += DamageAmount;
	}
}

function SendDamageData()
{
	local int i;

	if (DmgArray.Length <= 0)
		return;

	for (i = 0; i < DmgArray.Length; ++i)
	{
		AddTrackedDamage(DmgArray[i].Damage, DmgArray[i].DT, None, None);
	}

	DmgArray.Length = 0;
}

function AddHealStat(int HealAmount)
{
	HealPoints += HealAmount;
}

function SendHealData()
{
	AddHealPoints(HealPoints);

	HealPoints = 0;
}

function SendAllStats()
{
	SendDamageData();
	SendHealData();
}

defaultproperties
{
	bShouldUpdateGrenadeIcon=True
	bShouldUpdateHUDPerkIcon=True
	bUpgradeMenuOpen=False
	HUD_perkIndex=INDEX_NONE
	UPG_UpgradeListIndex=1
	PlatformType=0

	PerkList(0)=(PerkClass=class'ZedternalReborn.WMPerk')
	PerkList(1)=(PerkClass=class'KFGame.KFPerk_Berserker')
	PerkList(2)=(PerkClass=class'KFGame.KFPerk_Commando')
	PerkList(3)=(PerkClass=class'KFGame.KFPerk_Support')
	PerkList(4)=(PerkClass=class'KFGame.KFPerk_FieldMedic')
	PerkList(5)=(PerkClass=class'KFGame.KFPerk_Demolitionist')
	PerkList(6)=(PerkClass=class'KFGame.KFPerk_Firebug')
	PerkList(7)=(PerkClass=class'KFGame.KFPerk_Gunslinger')
	PerkList(8)=(PerkClass=class'KFGame.KFPerk_Sharpshooter')
	PerkList(9)=(PerkClass=class'KFGame.KFPerk_SWAT')
	PerkList(10)=(PerkClass=class'KFGame.KFPerk_Survivalist')
	CheatClass=class'ZedternalReborn.WMCheatManager'
	MatchStatsClass=class'ZedternalReborn.WMEphemeralMatchStats'
	PurchaseHelperClass=class'ZedternalReborn.WMAutoPurchaseHelper'

	Name="Default__WMPlayerController"
}
