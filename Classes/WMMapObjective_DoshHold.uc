//Acts as a override, but we can not directly override KFMapObjective_DoshHold as it comes from the map, not unrealscript.
class WMMapObjective_DoshHold extends Actor
	implements(KFInterface_MapObjective);

var repnotify bool bActive;
var KFMapObjective_DoshHold Parent;

var float ActivatePctChances;
var float PctOfWaveZedsKilledForMaxRewardZedternal;
var int DoshRewardsZedternal;
var array<float> DoshDifficultyScalarsZedternal;

// Replication
replication
{
	if (bNetDirty)
		bActive;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(bActive))
	{
		if (!bActive)
		{
			DeactivateObjective();
		}
	}
}

// Status
simulated function ActivateObjective()
{
	local int PlayerCount;
	local int i;
	local KFSeqEvent_MapObjectiveActivated ActivationEvent;

	//KFMapObjective_VolumeBase super call
	bActive = true;

	for (i = 0; i < Parent.GeneratedEvents.Length; ++i)
	{
		ActivationEvent = KFSeqEvent_MapObjectiveActivated(Parent.GeneratedEvents[i]);
		if (ActivationEvent != none)
		{
			ActivationEvent.NotifyActivation(Parent, Parent);
		}
	}

	Parent.ActivateBoundarySplines();

	// delay this sound event by a little bit so that the unreliable RPC doesn't get lost
	Parent.SetTimer(1.0f, false, 'PlayActivationSoundEvent');
	//////////////

	//KFMapObjective_AreaDefense super call
	if (Parent.Role == ROLE_Authority)
	{
		bActive = true;
		Parent.CurrentRewardAmount = GetMaxDoshReward();
	}

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		Parent.UpdateMeshArrayState();

		if (Parent.bUseTrailToVolume)
		{
			if (Parent.TrailActor == none)
			{
				Parent.TrailActor = class'WorldInfo'.static.GetWorldInfo().Spawn(class'KFReplicatedShowPathActor', none);
			}
			if (Parent.TrailActor != none)
			{
				Parent.TrailActor.SetEmitterTemplate(ParticleSystem'FX_Gameplay_EMIT.FX_Objective_White_Trail');
				Parent.TrailActor.SetPathTarget(Parent, Parent, VCT_NotInVolume);
			}
		}
	}
	//////////////

	if (Parent.Role == ROLE_Authority)
	{
		// dosh hold reward starts at zero and counts up when a zed is killed
		Parent.CurrentRewardAmount = 0;

		// RewardPerZed will be set upon killing the first zed because this function (ActivateObjective)
		// is called before KFGRI.WaveTotalAICount is set for the current wave
		Parent.RewardPerZed = 0;

		PlayerCount = Clamp(KFGameInfo(WorldInfo.Game).GetLivingPlayerCount(), 1, 6) - 1;
		if (Parent.TouchingHumans.Length >= Parent.PlayerThresholds[PlayerCount])
		{
			StartPenaltyCheck();
		}
		else
		{
			SetTimer(Parent.PenaltyStartupTimer, false, 'StartPenaltyCheck');
		}

		//Because we're tired of dealing with bugs in the VO system in smart ways, delay by a frame
		//		to avoid first tick replication not having a controller.
		Parent.SetTimer(0.01f, false, 'ActivationVO');

		Parent.SetTimer(1.f, true, 'Timer_CheckPawnCount');
		Parent.SetTimer(1.f, true, 'Timer_CheckWaveProgress');
		Parent.PrevWaveProgress = 0;
		Parent.bRemindPlayers = true;
	}
}

simulated function DeactivateObjective()
{
	local KFPawn_Human KFPH;
	local KFPlayerController KFPC;
	local bool bOneHumanAlive;
	local int i, j;
	local KFSeqEvent_MapObjectiveActivated ActivationEvent;

	//KFMapObjective_VolumeBase super call
	bActive = false;

	for (i = 0; i < Parent.GeneratedEvents.Length; ++i)
	{
		ActivationEvent = KFSeqEvent_MapObjectiveActivated(Parent.GeneratedEvents[i]);
		if (ActivationEvent != none)
		{
			ActivationEvent.NotifyDeactivation(Parent, Parent);
		}
	}

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		for (i = 0; i < Parent.ZoneBoundariesEmitter.Length; ++i)
		{
			if (Parent.ZoneBoundariesEmitter[i] != none)
			{
				Parent.ZoneBoundariesEmitter[i].ParticleSystemComponent.DeactivateSystem();
				Parent.ZoneBoundariesEmitter[i].bCurrentlyActive = false;
			}
		}

		for (i = 0; i < Parent.ZoneBoundaryMeshes.Length; ++i)
		{
			if (Parent.ZoneBoundaryMeshes[i] != none)
			{
				Parent.ZoneBoundaryMeshes[i].StaticMeshComponent.SetHidden(true);
			}
		}

		for (i = 0; i < Parent.ZoneBoundarySplines.length; ++i)
		{
			if (Parent.ZoneBoundarySplines[i] != none)
			{
				for (j = 0; j < Parent.ZoneBoundarySplines[i].SplineMeshComps.length; ++j)
				{
					if (Parent.ZoneBoundarySplines[i].SplineMeshComps[j] != none)
					{
						Parent.ZoneBoundarySplines[i].SplineMeshComps[j].SetHidden(true);
					}
				}
			}
		}
	}
	//////////////

	//KFMapObjective_AreaDefense super call
	if (Parent.Role == ROLE_Authority)
	{
		bActive = false;
	}

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		Parent.UpdateMeshArrayState();

		if (Parent.bUseTrailToVolume && Parent.TrailActor != none)
		{
			Parent.TrailActor.Destroy();
			Parent.TrailActor = none;
		}
	}
	//////////////

	if (Parent.Role == ROLE_Authority)
	{
		Parent.ClearTimer('CheckBonusState');
		ClearTimer('StartPenaltyCheck');
		Parent.ClearTimer('Timer_AllowRemindPlayers');
		Parent.ClearTimer('Timer_CheckWaveProgress');
		Parent.ClearTimer('Timer_CheckPawnCount');

		bOneHumanAlive = false;

		foreach WorldInfo.AllPawns(class'KFPawn_Human', KFPH)
		{
			if (KFPH.IsAliveAndWell())
			{
				bOneHumanAlive = true;
			}
		}

		// give the dosh hold reward to a player even if they died
		if (Parent.CurrentRewardAmount > 0 && bOneHumanAlive)
		{
			foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
			{
				GrantReward(KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo), KFPC);
			}
		}

		if (bOneHumanAlive)
		{
			PlayDeactivationDialog();
		}
	}

	KFPC = KFPlayerController(GetALocalPlayerController());
	if (KFPC != none && KFPC.MyGFxHUD != none)
	{
		KFPC.MyGFxHUD.WaveInfoWidget.ObjectiveContainer.SetFailState(Parent.CurrentRewardAmount <= 0);
	}
}

function PlayDeactivationDialog()
{
	if (Parent.CurrentRewardAmount <= 0)
	{
		if (Parent.FailureSoundEventOverride != none)
		{
			PlaySoundBase(Parent.FailureSoundEventOverride, false, WorldInfo.NetMode == NM_DedicatedServer);
		}
		else
		{
			class'KFTraderDialogManager'.static.PlayGlobalDialog(60, WorldInfo, true); //TRAD_ObjDefendAFailed
		}
		BroadcastLocalizedMessage(class'KFLocalMessage_Priority', GMT_ObjectiveLost);
	}
	else
	{
		if (GetProgress() <= Parent.JustWinThreshold)
		{
			if (Parent.SuccessSoundEvent25pctOverride != none)
			{
				PlaySoundBase(Parent.SuccessSoundEvent25pctOverride, false, WorldInfo.NetMode == NM_DedicatedServer);
			}
			else
			{
				class'KFTraderDialogManager'.static.PlayGlobalDialog(111, WorldInfo, true); //TRAD_ObjDefendAWonJust
			}
		}
		else if (GetProgress() <= Parent.StandardWinThreshold)
		{
			if (Parent.SuccessSoundEvent50pctOverride != none)
			{
				PlaySoundBase(Parent.SuccessSoundEvent50pctOverride, false, WorldInfo.NetMode == NM_DedicatedServer);
			}
			else
			{
				class'KFTraderDialogManager'.static.PlayGlobalDialog(58, WorldInfo, true); //TRAD_ObjDefendAWon
			}
		}
		else if (GetProgress() <= Parent.GoodWinThreshold)
		{
			if (Parent.SuccessSoundEvent85pctOverride != none)
			{
				PlaySoundBase(Parent.SuccessSoundEvent85pctOverride, false, WorldInfo.NetMode == NM_DedicatedServer);
			}
			else
			{
				class'KFTraderDialogManager'.static.PlayGlobalDialog(112, WorldInfo, true); //TRAD_ObjDefendAWonGood
			}
		}
		else
		{
			if (Parent.SuccessSoundEvent100pctOverride != none)
			{
				PlaySoundBase(Parent.SuccessSoundEvent100pctOverride, false, WorldInfo.NetMode == NM_DedicatedServer);
			}
			else
			{
				class'KFTraderDialogManager'.static.PlayGlobalDialog(113, WorldInfo, true); //TRAD_ObjDefendAWonPerf
			}
		}
	}
}

simulated function GrantReward(KFPlayerReplicationInfo KFPRI, KFPlayerController KFPC)
{
	if (KFPRI == none)
	{
		return;
	}

	if (KFPRI.bOnlySpectator)
	{
		return;
	}

	KFPRI.AddDosh(GetDoshReward());

	if (KFPC != none)
	{
		KFPC.ClientMapObjectiveCompleted(GetXPReward());
	}
}

simulated function bool IsActive()
{
	return bActive;
}

simulated function bool UsesProgress()
{
	return Parent.UsesProgress();
}

simulated function int GetDoshReward()
{
	return Parent.GetDoshReward();
}

simulated function int GetMaxDoshReward()
{
	local KFGameReplicationInfo KFGRI;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if (KFGRI != none)
	{
		return DoshRewardsZedternal * DoshDifficultyScalarsZedternal[KFGRI.GameDifficulty];
	}

	return DoshRewardsZedternal;
}

simulated function int GetVoshReward()
{
	return 0;
}

simulated function int GetMaxVoshReward()
{
	return 0;
}

simulated function int GetXPReward()
{
	return 0;
}

simulated function int GetMaxXPReward()
{
	return 0;
}

simulated function bool IsBonus()
{
	return Parent.IsBonus();
}

simulated function string GetLocalizedName()
{
	return Parent.GetLocalizedName();
}

simulated function string GetLocalizedShortName()
{
	return Parent.GetLocalizedShortName();
}

function bool CanActivateObjective()
{
	return Parent.CanActivateObjective();
}

simulated function float GetProgress()
{
	local int MaxDoshReward;

	MaxDoshReward = GetMaxDoshReward();
	if (MaxDoshReward == 0)
	{
		return 0;
	}

	return Parent.CurrentRewardAmount / float(MaxDoshReward);
}

simulated function bool IsComplete()
{
	return GetProgress() > 0.f && !bActive;
}

simulated function bool HasFailedObjective()
{
	return Parent.HasFailedObjective();
}

simulated function float GetActivationPctChance()
{
	local KFGameReplicationInfo KFGRI;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if (KFGRI != none && KFGRI.WaveNum == 0)
	{
		return 0.0f; //Do not spawn an objective on the start round	
	}

	return ActivatePctChances;
}

simulated function float GetSpawnRateMod()
{
	return Parent.GetSpawnRateMod();
}


simulated function string GetProgressText()
{
	return string(GetMaxDoshReward());
}
simulated function bool GetProgressTextIsDosh()
{
	return Parent.GetProgressTextIsDosh();
}


simulated function string GetLocalizedDescription()
{
	return Parent.GetLocalizedDescription();
}
simulated function string GetLocalizedShortDescription()
{
	return Parent.GetLocalizedShortDescription();
}
simulated function string GetLocalizedRequirements()
{
	return Parent.GetLocalizedRequirements();
}
simulated function GetLocalizedStatus(out string statusMessage, out int bWarning, out int bNotification)
{
	Parent.GetLocalizedStatus(statusMessage, bWarning, bNotification);
}


simulated function bool GetIsMissionCritical()
{
	return Parent.GetIsMissionCritical();
}

simulated function float GetDoshValueModifier()
{
	return Parent.GetDoshValueModifier();
}

function StartPenaltyCheck()
{
	ClearTimer('StartPenaltyCheck');
	if(bActive)
	{
		Parent.SetTimer(Parent.DoshPenaltyCheckTimer, true, 'CheckBonusState');
	}
}

function NotifyZedKilled(Controller Killer, Pawn KilledPawn, bool bIsBoss)
{
	local int i;
	local KFGameInfo KFGI;
	local KFGameReplicationInfo KFGRI;

	if (Parent.ROLE == Role_Authority)
	{
		if (bActive)
		{
			KFGI = KFGameInfo(WorldInfo.Game);
			if (KFGI != none)
			{
				for (i = 0; i < Parent.TouchingHumans.Length; i++)
				{
					if (Killer == Parent.TouchingHumans[i].Controller)
					{
						if (Parent.RewardPerZed == 0)
						{
							KFGRI = KFGameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
							Parent.RewardPerZed = GetMaxDoshReward() / (PctOfWaveZedsKilledForMaxRewardZedternal * KFGRI.WaveTotalAICount);
						}
						Parent.CurrentRewardAmount = FMin(Parent.CurrentRewardAmount + Parent.RewardPerZed, float(GetMaxDoshReward()));
						break;
					}
				}
			}

			if (GetProgress() >= 1.0f)
			{
				DeactivateObjective();
			}
		}
	}
}

simulated function NotifyObjectiveSelected()
{
	Parent.NotifyObjectiveSelected();
}


// HUD
simulated function bool ShouldDrawIcon()
{
	return Parent.ShouldDrawIcon();
}

simulated function Vector GetIconLocation()
{
	return Parent.GetIconLocation();
}

simulated function Texture2D GetIcon()
{
	return Parent.GetIcon();
}

simulated function color GetIconColor()
{
	return Parent.GetIconColor();
}

simulated function DrawHUD(KFHUDBase hud, Canvas drawCanvas)
{
	Parent.DrawHUD(hud, drawCanvas);
}

simulated function bool HasObjectiveDrawDistance()
{
	return Parent.HasObjectiveDrawDistance();
}

simulated function bool ShouldShowObjectiveHUD()
{
	return !IsComplete();
}

simulated function bool ShouldShowObjectiveContainer()
{
	return Parent.ShouldShowObjectiveContainer();
}

// Kismet
simulated function TriggerObjectiveProgressEvent(optional int EventType = -1, optional float ProgressMade = -1.f)
{
	Parent.TriggerObjectiveProgressEvent(EventType, ProgressMade);
}

defaultproperties
{
	SupportedEvents.Add(class'KFSeqEvent_MapObjectiveActivated')
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy

	//Needed so object can spawn
	bStatic=False
	bNoDelete=False

	Name="Default__WMMapObjective_DoshHold"
}
