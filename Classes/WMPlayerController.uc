class WMPlayerController extends KFPlayerController
	config(ZedternalReborn_LocalData);

var int HUD_perkIndex;
var int UPG_PerkListIndex, UPG_SkillListIndex, UPG_WeaponlistIndex;
var bool bShouldUpdateHUDPerkIcon;

var config byte KnifeIndex;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	PerkList.Length=1;
	PerkList[0].PerkClass=Class'ZedternalReborn.WMPerk';

	SetTimer(2.f, true, nameof(UpdatePerkIcon));
}


reliable client event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if (WMPerk(CurrentPerk) != none)
		WMPerk(CurrentPerk).ReceiveLocalizedMessage( Message, Switch );
	super.ReceiveLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

reliable server function BuyPerkUpgrade(int ItemDefinition, int Cost)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != none && Pawn.PlayerReplicationInfo.Score >= Cost && WMPRI.bPerkUpgrade[ItemDefinition] < WMGameReplicationInfo(WorldInfo.GRI).perkMaxLevel)
	{
		++WMPRI.bPerkUpgrade[ItemDefinition];
		if (WMPRI.purchase_perkUpgrade.Find(ItemDefinition) == -1)
			WMPRI.purchase_perkUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
			Pawn.PlayerReplicationInfo.Score -= Cost;

		UpdateWeaponMagAndCap();

		WMPRI.UpdateCurrentIconToDisplay(ItemDefinition, Cost, 1);
	}
}

reliable server function BuyWeaponUpgrade(int ItemDefinition, int Cost)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != none && Pawn.PlayerReplicationInfo.Score >= Cost && WMPRI.GetWeaponUpgrade(ItemDefinition) < WMGameReplicationInfo(WorldInfo.GRI).weaponMaxLevel)
	{
		WMPRI.IncermentWeaponUpgrade(ItemDefinition);
		if (WMPRI.purchase_weaponUpgrade.Find(ItemDefinition) == -1)
			WMPRI.purchase_weaponUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
			Pawn.PlayerReplicationInfo.Score -= Cost;

		UpdateWeaponMagAndCap();
	}
}

reliable server function BuySkillUpgrade(int ItemDefinition, int PerkItemDefinition, int Cost, int lvl)
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);

	if (WMPRI != none && Pawn.PlayerReplicationInfo.Score >= Cost)
	{
		WMPRI.bSkillUpgrade[ItemDefinition] = min(WMPRI.bSkillUpgrade[ItemDefinition] + lvl, 2);
		if (WMPRI.purchase_skillUpgrade.Find(ItemDefinition) == -1)
			WMPRI.purchase_skillUpgrade.AddItem(ItemDefinition);

		if (WorldInfo.NetMode == NM_DedicatedServer)
			Pawn.PlayerReplicationInfo.Score -= Cost;

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

	if (WMPRI != none)
	{
		WMPRI.bSkillUnlocked[index] = 1;
		if (deluxe)
			WMPRI.bSkillDeluxe[index] = 1;
	}
}

function UpdateWeaponMagAndCap()
{
	local KFPawn_Human KFP;
	local KFWeapon KFW;
	local Inventory Inv;
	local WMPerk WMP;

	// Compile passive bonuses
	WMP = WMPerk(CurrentPerk);
	if (WMP != none)
		WMP.ClientAndServerComputePassiveBonuses();
	UpdateClientPerkBonuses();

	//New Weight, Mag Size and max capacity
	if (CurrentPerk != none)
	{
		CurrentPerk.ApplyWeightLimits();
		KFP = KFPawn_Human(Pawn);
		if( KFP != none)
		{
			if ( KFP.InvManager != none )
			{
				for( Inv = KFP.InvManager.InventoryChain; Inv != none; Inv = Inv.Inventory )
				{
					KFW = KFWeapon(Inv);
					if( KFW != none )
					{
					// Reinitialize ammo counts
					KFW.ReInitializeAmmoCounts(CurrentPerk);
					}
				}
			}
			// Also modify Health and Armor
			CurrentPerk.ModifyHealth(KFP.Health);
			CurrentPerk.ModifyHealth(KFP.HealthMax);
			CurrentPerk.ModifyArmor(KFP.MaxArmor);
			WMPerk(CurrentPerk).ModifyMaxSpareGrenadeAmount();
		}

		// Also update perk info
		CurrentPerk.ApplySkillsToPawn();
	}
}

reliable client function UpdateClientPerkBonuses()
{
	local WMPerk WMP;

	WMP = WMPerk(CurrentPerk);
	if (WMP != none)
	{
		WMP.ClientAndServerComputePassiveBonuses();
		WMP.ModifyMaxSpareGrenadeAmount();
	}
}

simulated function ChangeGrenade(int Index)
{
	CurrentPerk.GrenadeWeaponDef = WMGameReplicationInfo(WorldInfo.GRI).Grenades[Index];
	CurrentPerk.GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject(CurrentPerk.GrenadeWeaponDef.default.WeaponClassPath, class'Class'));
	ChangeGrenadeServer(Index);
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

	if (WMPerk(CurrentPerk) != none)
	{
		KnifeClass = class<Inventory>(DynamicLoadObject(WMPerk(CurrentPerk).KnivesWeaponDef[Index].default.WeaponClassPath, class'Class'));
		if (!KFInventoryManager(Pawn.InvManager).ClassIsInInventory(KnifeClass, Inv))
		{
			// remove all backup knives from inventory
			for( Inv = Pawn.InvManager.InventoryChain; Inv != none; Inv = Inv.Inventory ) 
			{
				KFW = KFWeapon(Inv);
				if( KFW != none && !KFW.CanThrow() && KFWeap_Edged_Knife(KFW) != none && KFW.class != KnifeClass)
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
	return 0.f;
}

simulated function int GetCurrentLevel()
{
	local WMPlayerReplicationInfo WMPRI;

	WMPRI = WMPlayerReplicationInfo(PlayerReplicationInfo);
	if (WMPRI != none)
		return WMPRI.perkLvl;
	else
		return 0;
}

simulated function string GetPerkIconPath()
{
	local WMPlayerReplicationInfo WMPRI;
	local WMGameReplicationInfo WMGRI;
	local int tries;

	WMPRI = WMPlayerReplicationInfo(Pawn.PlayerReplicationInfo);
	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	bShouldUpdateHUDPerkIcon = false;

	if (WMPRI != none && WMGRI != none && WMPRI.perkLvl > 0)
	{
		tries = WMGRI.perkUpgrades.length;
		while(tries > 0)
		{
			++HUD_perkIndex;
			--tries;
			if (HUD_perkIndex >= WMGRI.perkUpgrades.length)
				HUD_perkIndex = 0;

			if (WMPRI.bPerkUpgrade[HUD_perkIndex] > 0)
				return PathName(WMGRI.perkUpgrades[HUD_perkIndex].static.GetUpgradeIcon( WMPRI.bPerkUpgrade[HUD_perkIndex] - 1 ));
		}
		
	}

	return CurrentPerk.GetPerkIconPath();
}

simulated function UpdatePerkIcon()
{
	bShouldUpdateHUDPerkIcon=true;
}

defaultproperties
{
	HUD_perkIndex=-1
	bShouldUpdateHUDPerkIcon=true
	UPG_PerkListIndex=1
	UPG_SkillListIndex=2
	UPG_WeaponListIndex=1
	PerkList(0)=(PerkClass=Class'ZedternalReborn.WMPerk')
	ServPendingPerkBuild=-1
	ServPendingPerkLevel=-1
}
