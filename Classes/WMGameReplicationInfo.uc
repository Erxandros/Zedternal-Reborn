class WMGameReplicationInfo extends KFGameReplicationInfo;

var name KFWeaponName[255];
var repnotify string KFWeaponDefPath[255];
var repnotify string KFStartingWeaponPath[255];
var repnotify string perkUpgradesStr[255];
var repnotify string skillUpgradesStr[255];
var repnotify string skillUpgradesStr_Perk[255];
var repnotify string specialWavesStr[255];
var repnotify string grenadesStr[255];
var repnotify string zedBuffStr[255];
var int SpecialWaveID[2];
var repnotify bool bNewZedBuff;
var int startingWeapon, newWeaponEachWave, maxWeapon, staticWeapon;
var KFGFxObject_TraderItems TraderArch;
var repnotify int ArmorPrice;
var repnotify int TraderVoiceGroupIndex;

var int perkPrice[255];
var int perkMaxLevel;
var int skillPrice;
var int skillDeluxePrice;
var bool bUseCustomWeaponPrice;
var int weaponPrice;
var int weaponMaxLevel;
var int bZedBuffs[255];

var repnotify string weaponUpgrade_WeaponStr[255];
var repnotify string weaponUpgrade_UpgradeStr[255];
var repnotify int weaponUpgrade_PriceRep[255];
var repnotify string weaponUpgrade_WeaponStr_B[255];
var repnotify string weaponUpgrade_UpgradeStr_B[255];
var repnotify int weaponUpgrade_PriceRep_B[255];

var array< class<KFWeapon> > weaponUpgrade_Weapon;
var array< class<WMUpgrade_Weapon> > weaponUpgrade_Upgrade;
var array< int > weaponUpgrade_Price;

var array< class<KFWeapon> > KFStartingWeapon;
var array< class<WMUpgrade_Perk> > perkUpgrades;
var array< class<WMUpgrade_Weapon> > weaponUpgrades;
var array< class<WMUpgrade_Skill> > skillUpgrades;
var array< class<WMUpgrade_Perk> > skillUpgrades_Perk;
var array< class<WMSpecialWave> > specialWaves;
var array< class<KFWeaponDefinition> > Grenades;

var array< class<WMZedBuff> > zedBuffs;
var bool bDrawSpecialWave;
var byte specialWaveIndexToShow;
var int zedBuff_nextMusicTrackIndex;
var array< KFMusicTrackInfo > ZedBuffMusic;

var array< class<KFTraderVoiceGroupBase> > TraderVoiceGroupClasses;

replication
{
	if ( bNetDirty )
		staticWeapon,weaponUpgrade_WeaponStr,weaponUpgrade_UpgradeStr,KFWeaponName,KFWeaponDefPath,KFStartingWeaponPath,SpecialWaveID,TraderVoiceGroupIndex,bNewZedBuff,TraderArch,ArmorPrice,perkUpgradesStr,skillUpgradesStr,skillUpgradesStr_Perk,specialWavesStr,grenadesStr,zedBuffStr,startingWeapon,newWeaponEachWave,maxWeapon,perkPrice,perkMaxLevel,skillPrice,skillDeluxePrice,bUseCustomWeaponPrice,weaponPrice,weaponMaxLevel,bZedBuffs,weaponUpgrade_WeaponStr_B,weaponUpgrade_UpgradeStr_B,weaponUpgrade_PriceRep, weaponUpgrade_PriceRep_B;
}

simulated event ReplicatedEvent(name VarName)
{
	local bool bEnd;
	local int i;
	local STraderItem newWeapon;
	switch (VarName)
	{
		case 'WaveNum':
			if (SpecialWaveID[0]!=-1 && WaveNum > 0)
				TriggerSpecialWaveMessage();
			SetWeaponPickupList();
			super.ReplicatedEvent(VarName);
			break;

		case 'KFWeaponDefPath':
			TraderItems = new class'KFGFxObject_TraderItems';
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (KFWeaponDefPath[i]!="")
				{
					newWeapon.WeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(KFWeaponDefPath[i],class'Class'));
					newWeapon.ItemID = i;
					TraderItems.SaleItems.AddItem(newWeapon);
					i += 1;
				}
				else
					bEnd = true;
			}
			if (TraderItems != none)
			{
				TraderItems.ArmorPrice = ArmorPrice;
				TraderItems.SetItemsInfo(TraderItems.SaleItems);
			}
			break;
			
		case 'KFStartingWeaponPath':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (KFStartingWeaponPath[i]!="")
				{
					KFStartingWeapon[i] = class<KFWeapon>(DynamicLoadObject(KFStartingWeaponPath[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;
			
		case 'ArmorPrice':
			TraderItems.ArmorPrice = ArmorPrice;
			break;
			
		case 'perkUpgradesStr':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (perkUpgradesStr[i]!="")
				{
					perkUpgrades[i] = class<WMUpgrade_Perk>(DynamicLoadObject(perkUpgradesStr[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;
			
		case 'weaponUpgrade_WeaponStr':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (weaponUpgrade_WeaponStr[i]!="")
				{
					weaponUpgrade_Weapon[i] = class<KFWeapon>(DynamicLoadObject(weaponUpgrade_WeaponStr[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;
			
		case 'weaponUpgrade_UpgradeStr':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (weaponUpgrade_UpgradeStr[i]!="")
				{
					weaponUpgrade_Upgrade[i] = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgrade_UpgradeStr[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'weaponUpgrade_PriceRep':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (weaponUpgrade_PriceRep[i]!=0)
				{
					weaponUpgrade_Price[i] = weaponUpgrade_PriceRep[i];
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'weaponUpgrade_WeaponStr_B':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (weaponUpgrade_WeaponStr_B[i]!="")
				{
					weaponUpgrade_Weapon[i+255] = class<KFWeapon>(DynamicLoadObject(weaponUpgrade_WeaponStr_B[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'weaponUpgrade_UpgradeStr_B':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (weaponUpgrade_UpgradeStr_B[i]!="")
				{
					weaponUpgrade_Upgrade[i+255] = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgrade_UpgradeStr_B[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'weaponUpgrade_PriceRep_B':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (weaponUpgrade_PriceRep_B[i]!=0)
				{
					weaponUpgrade_Price[i+255] = weaponUpgrade_PriceRep_B[i];
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'skillUpgradesStr':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (skillUpgradesStr[i]!="")
				{
					skillUpgrades[i] = class<WMUpgrade_Skill>(DynamicLoadObject(skillUpgradesStr[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'skillUpgradesStr_Perk':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (skillUpgradesStr_Perk[i]!="")
				{
					skillUpgrades_Perk[i] = class<WMUpgrade_Perk>(DynamicLoadObject(skillUpgradesStr_Perk[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'specialWavesStr':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (specialWavesStr[i]!="")
				{
					specialWaves[i] = class<WMSpecialWave>(DynamicLoadObject(specialWavesStr[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'grenadesStr':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (grenadesStr[i]!="")
				{
					Grenades[i] = class<KFWeaponDefinition>(DynamicLoadObject(grenadesStr[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
			}
			break;

		case 'zedBuffStr':
			bEnd = false;
			i = 0;
			while (!bEnd && i<=254)
			{
				if (zedBuffStr[i]!="")
				{
					zedBuffs[i] = class<WMZedBuff>(DynamicLoadObject(zedBuffStr[i],class'Class'));
					i += 1;
				}
				else
					bEnd = true;
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

		default:
			super.ReplicatedEvent(VarName);
			break;
	}
}

simulated function SetWeaponPickupList()
{
	local int j;
	local KFPickupFactory_ItemDefault KFPFID;
	local ItemPickup newPickup;

	foreach DynamicActors( class'KFPickupFactory_ItemDefault', KFPFID )
	{
		if (KFPFID != none)
		{
			KFPFID.ItemPickups.length = 0;
			newPickup.ItemClass = Class'kfgamecontent.KFInventory_Armor';
			KFPFID.ItemPickups.AddItem(newPickup);
			
			for (j=0; j<KFStartingWeapon.length; j++)
			{
				newPickup.ItemClass = KFStartingWeapon[j];
				KFPFID.ItemPickups.AddItem(newPickup);
			}
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
	
	zedBuff_nextMusicTrackIndex += 1;
	
	// if we played all tracks, play last 2 tracks
	if (zedBuff_nextMusicTrackIndex >= default.ZedBuffMusic.length)
		zedBuff_nextMusicTrackIndex -= 2;
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
		specialWaveIndexToShow += 1;
		ShowSpecialWaveMessage();
	}
	else
	{
		KFPlayerController(GetALocalPlayerController()).MyGFxHUD.HideBossNamePlate();
		bDrawSpecialWave = true;
	}
}


reliable server function ChangeThirdPersonWeaponSkin(KFPawn weaponOwner, int SkinId)
{
	SendThirdPersonWeaponSkin(weaponOwner, SkinId);
}

reliable client function SendThirdPersonWeaponSkin(KFPawn weaponOwner, int SkinId)
{
	local array<MaterialInterface> SkinMICs;
	local int i;
	
	SkinMICs = class'KFWeaponSkinList'.static.GetWeaponSkin(SkinId, WST_ThirdPerson);
	for (i=0; i<SkinMICs.length; i++)
	{
		weaponOwner.WeaponAttachment.WeapMesh.SetMaterial(i, SkinMICs[i]);
	}
}

simulated function bool IsItemAllowed(STraderItem Item)
{
	local int i;
	
	for (i = 0; i < min(maxWeapon - staticWeapon, (startingWeapon + staticWeapon + (WaveNum + 1) * newWeaponEachWave)); i++)
	{
		if (Item.ClassName==KFWeaponName[i])
			return true;
		else if (Item.SingleClassName==KFWeaponName[i])
			return true;
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
   WaveMax=255
   ArmorPrice=3
   bEndlessMode=True
   bDrawSpecialWave=false
   UpdateZedInfoInterval=0.500000
   UpdateHumanInfoInterval=0.500000
   UpdatePickupInfoInterval=1.000000
   zedBuff_nextMusicTrackIndex=0
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
}
