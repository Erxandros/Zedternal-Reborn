class WMGameReplicationInfo extends KFGameReplicationInfo;

//Replicated data
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
var int ArmorPrice;
var repnotify byte TraderVoiceGroupIndex;

var int perkPrice[255];
var int perkMaxLevel;
var int skillPrice;
var int skillDeluxePrice;
var int weaponMaxLevel;
var byte bZedBuffs[255];

var repnotify string weaponUpgrade_WeaponStr_A[255];
var repnotify string weaponUpgrade_UpgradeStr_A[255];
var repnotify int weaponUpgrade_PriceRep_A[255];
var repnotify string weaponUpgrade_WeaponStr_B[255];
var repnotify string weaponUpgrade_UpgradeStr_B[255];
var repnotify int weaponUpgrade_PriceRep_B[255];
var repnotify string weaponUpgrade_WeaponStr_C[255];
var repnotify string weaponUpgrade_UpgradeStr_C[255];
var repnotify int weaponUpgrade_PriceRep_C[255];
var repnotify string weaponUpgrade_WeaponStr_D[255];
var repnotify string weaponUpgrade_UpgradeStr_D[255];
var repnotify int weaponUpgrade_PriceRep_D[255];

var repnotify bool updateSkins;
var repnotify bool printVersion;

//Non-replicated data
var array< class<KFWeapon> > weaponUpgrade_Weapon;
var array< class<WMUpgrade_Weapon> > weaponUpgrade_Upgrade;
var array< int > weaponUpgrade_Price;

var array< class<KFWeapon> > KFStartingWeapon;
var array< class<WMUpgrade_Perk> > perkUpgrades;
var array< class<WMUpgrade_Skill> > skillUpgrades;
var array< class<WMUpgrade_Perk> > skillUpgrades_Perk;
var array< class<WMSpecialWave> > specialWaves;
var array< class<KFWeaponDefinition> > Grenades;

var array< class<WMZedBuff> > zedBuffs;
var bool bDrawSpecialWave;
var byte specialWaveIndexToShow;

var byte zedBuff_nextMusicTrackIndex;
var array< KFMusicTrackInfo > ZedBuffMusic;
var array< class<KFTraderVoiceGroupBase> > TraderVoiceGroupClasses;

replication
{
	if ( bNetDirty )
		KFWeaponName, KFWeaponDefPath, KFStartingWeaponPath, perkUpgradesStr, skillUpgradesStr, skillUpgradesStr_Perk, specialWavesStr, grenadesStr,
		zedBuffStr, SpecialWaveID, bNewZedBuff, startingWeapon, newWeaponEachWave, maxWeapon, staticWeapon, ArmorPrice, TraderVoiceGroupIndex,
		perkPrice, perkMaxLevel, skillPrice, skillDeluxePrice, weaponMaxLevel, bZedBuffs,
		weaponUpgrade_WeaponStr_A, weaponUpgrade_UpgradeStr_A, weaponUpgrade_PriceRep_A,
		weaponUpgrade_WeaponStr_B, weaponUpgrade_UpgradeStr_B, weaponUpgrade_PriceRep_B,
		weaponUpgrade_WeaponStr_C, weaponUpgrade_UpgradeStr_C, weaponUpgrade_PriceRep_C,
		weaponUpgrade_WeaponStr_D, weaponUpgrade_UpgradeStr_D, weaponUpgrade_PriceRep_D,
		updateSkins, printVersion;
}

simulated event ReplicatedEvent(name VarName)
{
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
			if (TraderItems == none)
				TraderItems = new class'KFGFxObject_TraderItems';

			for (i = 0; i < 255; ++i)
			{
				if (KFWeaponDefPath[i] == "")
					break; //base case

				if (i == TraderItems.SaleItems.Length)
				{
					newWeapon.WeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(KFWeaponDefPath[i],class'Class'));
					newWeapon.ItemID = i;
					TraderItems.SaleItems.AddItem(newWeapon);
				}
			}

			if (TraderItems != none)
			{
				TraderItems.ArmorPrice = ArmorPrice;
				TraderItems.SetItemsInfo(TraderItems.SaleItems);
			}
			break;

		case 'KFStartingWeaponPath':
			for (i = 0; i < 255; ++i)
			{
				if (KFStartingWeaponPath[i] == "")
					break; //base case

				if (i == KFStartingWeapon.Length || KFStartingWeapon[i] == none || PathName(KFStartingWeapon[i]) != KFStartingWeaponPath[i])
					KFStartingWeapon[i] = class<KFWeapon>(DynamicLoadObject(KFStartingWeaponPath[i],class'Class'));
			}
			break;

		case 'perkUpgradesStr':
			for (i = 0; i < 255; ++i)
			{
				if (perkUpgradesStr[i] == "")
					break; //base case

				if (i == perkUpgrades.Length || perkUpgrades[i] == none || PathName(perkUpgrades[i]) != perkUpgradesStr[i])
					perkUpgrades[i] = class<WMUpgrade_Perk>(DynamicLoadObject(perkUpgradesStr[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_WeaponStr_A':
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_WeaponStr_A[i] == "")
					break; //base case

				if (i == weaponUpgrade_Weapon.Length || weaponUpgrade_Weapon[i] == none || PathName(weaponUpgrade_Weapon[i]) != weaponUpgrade_WeaponStr_A[i])
					weaponUpgrade_Weapon[i] = class<KFWeapon>(DynamicLoadObject(weaponUpgrade_WeaponStr_A[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_UpgradeStr_A':
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_UpgradeStr_A[i] == "")
					break; //base case

				if (i == weaponUpgrade_Upgrade.Length || weaponUpgrade_Upgrade[i] == none || PathName(weaponUpgrade_Upgrade[i]) != weaponUpgrade_UpgradeStr_A[i])
					weaponUpgrade_Upgrade[i] = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgrade_UpgradeStr_A[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_PriceRep_A':
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_PriceRep_A[i] == 0)
					break; //base case

				weaponUpgrade_Price[i] = weaponUpgrade_PriceRep_A[i];
			}
			break;

		case 'weaponUpgrade_WeaponStr_B':
			if (255 > weaponUpgrade_Weapon.Length)
				weaponUpgrade_Weapon.Length = 255;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_WeaponStr_B[i] == "")
					break; //base case

				if ((i + 255) == weaponUpgrade_Weapon.Length || weaponUpgrade_Weapon[i + 255] == none || PathName(weaponUpgrade_Weapon[i + 255]) != weaponUpgrade_WeaponStr_B[i])
					weaponUpgrade_Weapon[i + 255] = class<KFWeapon>(DynamicLoadObject(weaponUpgrade_WeaponStr_B[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_UpgradeStr_B':
			if (255 > weaponUpgrade_Upgrade.Length)
				weaponUpgrade_Upgrade.Length = 255;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_UpgradeStr_B[i] == "")
					break; //base case

				if ((i + 255) == weaponUpgrade_Upgrade.Length || weaponUpgrade_Upgrade[i + 255] == none || PathName(weaponUpgrade_Upgrade[i + 255]) != weaponUpgrade_UpgradeStr_B[i])
					weaponUpgrade_Upgrade[i + 255] = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgrade_UpgradeStr_B[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_PriceRep_B':
			if (255 > weaponUpgrade_Price.Length)
				weaponUpgrade_Price.Length = 255;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_PriceRep_B[i] == 0)
					break; //base case

				weaponUpgrade_Price[i + 255] = weaponUpgrade_PriceRep_B[i];
			}
			break;

		case 'weaponUpgrade_WeaponStr_C':
			if (510 > weaponUpgrade_Weapon.Length)
				weaponUpgrade_Weapon.Length = 510;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_WeaponStr_C[i] == "")
					break; //base case

				if ((i + 510) == weaponUpgrade_Weapon.Length || weaponUpgrade_Weapon[i + 510] == none || PathName(weaponUpgrade_Weapon[i + 510]) != weaponUpgrade_WeaponStr_C[i])
					weaponUpgrade_Weapon[i + 510] = class<KFWeapon>(DynamicLoadObject(weaponUpgrade_WeaponStr_C[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_UpgradeStr_C':
			if (510 > weaponUpgrade_Upgrade.Length)
				weaponUpgrade_Upgrade.Length = 510;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_UpgradeStr_C[i] == "")
					break; //base case

				if ((i + 510) == weaponUpgrade_Upgrade.Length || weaponUpgrade_Upgrade[i + 510] == none || PathName(weaponUpgrade_Upgrade[i + 510]) != weaponUpgrade_UpgradeStr_C[i])
					weaponUpgrade_Upgrade[i + 510] = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgrade_UpgradeStr_C[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_PriceRep_C':
			if (510 > weaponUpgrade_Price.Length)
				weaponUpgrade_Price.Length = 510;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_PriceRep_C[i] == 0)
					break; //base case

				weaponUpgrade_Price[i + 510] = weaponUpgrade_PriceRep_C[i];
			}
			break;

		case 'weaponUpgrade_WeaponStr_D':
			if (765 > weaponUpgrade_Weapon.Length)
				weaponUpgrade_Weapon.Length = 765;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_WeaponStr_D[i] == "")
					break; //base case

				if ((i + 765) == weaponUpgrade_Weapon.Length || weaponUpgrade_Weapon[i + 765] == none || PathName(weaponUpgrade_Weapon[i + 765]) != weaponUpgrade_WeaponStr_D[i])
					weaponUpgrade_Weapon[i + 765] = class<KFWeapon>(DynamicLoadObject(weaponUpgrade_WeaponStr_D[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_UpgradeStr_D':
			if (765 > weaponUpgrade_Upgrade.Length)
				weaponUpgrade_Upgrade.Length = 765;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_UpgradeStr_D[i] == "")
					break; //base case

				if ((i + 765) == weaponUpgrade_Upgrade.Length || weaponUpgrade_Upgrade[i + 765] == none || PathName(weaponUpgrade_Upgrade[i + 765]) != weaponUpgrade_UpgradeStr_D[i])
					weaponUpgrade_Upgrade[i + 765] = class<WMUpgrade_Weapon>(DynamicLoadObject(weaponUpgrade_UpgradeStr_D[i],class'Class'));
			}
			break;

		case 'weaponUpgrade_PriceRep_D':
			if (765 > weaponUpgrade_Price.Length)
				weaponUpgrade_Price.Length = 765;
			for (i = 0; i < 255; ++i)
			{
				if (weaponUpgrade_PriceRep_D[i] == 0)
					break; //base case

				weaponUpgrade_Price[i + 765] = weaponUpgrade_PriceRep_D[i];
			}
			break;

		case 'skillUpgradesStr':
			for (i = 0; i < 255; ++i)
			{
				if (skillUpgradesStr[i] == "")
					break; //base case

				if (i == skillUpgrades.Length || skillUpgrades[i] == none || PathName(skillUpgrades[i]) != skillUpgradesStr[i])
					skillUpgrades[i] = class<WMUpgrade_Skill>(DynamicLoadObject(skillUpgradesStr[i],class'Class'));
			}
			break;

		case 'skillUpgradesStr_Perk':
			for (i = 0; i < 255; ++i)
			{
				if (skillUpgradesStr_Perk[i] == "")
					break; //base case

				if (i == skillUpgrades_Perk.Length || skillUpgrades_Perk[i] == none || PathName(skillUpgrades_Perk[i]) != skillUpgradesStr_Perk[i])
					skillUpgrades_Perk[i] = class<WMUpgrade_Perk>(DynamicLoadObject(skillUpgradesStr_Perk[i],class'Class'));
			}
			break;

		case 'specialWavesStr':
			for (i = 0; i < 255; ++i)
			{
				if (specialWavesStr[i] == "")
					break; //base case

				if (i == specialWaves.Length || specialWaves[i] == none || PathName(specialWaves[i]) != specialWavesStr[i])
					specialWaves[i] = class<WMSpecialWave>(DynamicLoadObject(specialWavesStr[i],class'Class'));
			}
			break;

		case 'grenadesStr':
			for (i = 0; i < 255; ++i)
			{
				if (grenadesStr[i] == "")
					break; //base case

				if (i == Grenades.Length || Grenades[i] == none || PathName(Grenades[i]) != grenadesStr[i])
					Grenades[i] = class<KFWeaponDefinition>(DynamicLoadObject(grenadesStr[i],class'Class'));
			}
			break;

		case 'zedBuffStr':
			for (i = 0; i < 255; ++i)
			{
				if (zedBuffStr[i] == "")
					break; //base case

				if (i == zedBuffs.Length || zedBuffs[i] == none || PathName(zedBuffs[i]) != zedBuffStr[i])
					zedBuffs[i] = class<WMZedBuff>(DynamicLoadObject(zedBuffStr[i],class'Class'));
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

		case 'updateSkins':
			if (updateSkins)
				class'ZedternalReborn.WMCustomWeapon_Helper'.static.UpdateSkinsClient(KFWeaponDefPath);
			break;

		case 'printVersion':
			if (printVersion)
				class'ZedternalReborn.Config_Base'.static.PrintVersion();
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
			
			for (j = 0; j < KFStartingWeapon.length; ++j)
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

	++zedBuff_nextMusicTrackIndex;

	// cycle tracks
	if (zedBuff_nextMusicTrackIndex >= default.ZedBuffMusic.length)
		zedBuff_nextMusicTrackIndex = 0;
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
		++specialWaveIndexToShow;
		ShowSpecialWaveMessage();
	}
	else
	{
		KFPlayerController(GetALocalPlayerController()).MyGFxHUD.HideBossNamePlate();
		bDrawSpecialWave = true;
	}
}

simulated function bool IsItemAllowed(STraderItem Item)
{
	local int i;

	for (i = 0; i < min(maxWeapon - staticWeapon, (startingWeapon + staticWeapon + (WaveNum + 1) * newWeaponEachWave)); ++i)
	{
		if (Item.ClassName == KFWeaponName[i])
			return true;
		else if (Item.SingleClassName == KFWeaponName[i])
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
	ZedBuffMusic(4)=KFMusicTrackInfo'WW_MACT_Default.TI_Boss_Matriarch'
}
