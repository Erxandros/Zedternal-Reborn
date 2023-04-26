class WMVoteCollector extends KFVoteCollector;

function ServerStartVoteSkipTrader(PlayerReplicationInfo PRI)
{
	local int i;
	local array<KFPlayerReplicationInfo> PRIs;
	local KFGameInfo KFGI;
	local KFPlayerController KFPC;
	local KFGameReplicationInfo KFGRI;
	local int TraderTimeRemaining;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	KFGI = KFGameInfo(WorldInfo.Game);
	KFPC = KFPlayerController(PRI.Owner);

	// Spectators aren't allowed to vote
	if(PRI.bOnlySpectator)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', LMT_SkipTraderVoteNoSpectators);
		return;
	}

	// Trader is not open, we are not allowed to initiate a skip trader vote
	if(!KFGRI.bTraderIsOpen && !KFGRI.bForceShowSkipTrader)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', LMT_SkipTraderIsNotOpen);
		return;
	}

	// A skip trader vote is not allowed while another vote is active
	if(bIsKickVoteInProgress || bIsPauseGameVoteInProgress)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', LMT_OtherVoteInProgress);
		return;
	}

	// Not enough time to start a skip trader vote
	TraderTimeRemaining = KFGRI.GetTraderTimeRemaining();
	if(TraderTimeRemaining <= SkipTraderVoteLimit)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', LMT_SkipTraderNoEnoughTime);
		return;
	}

	if( !bIsSkipTraderVoteInProgress )
	{
		// Clear voter array
		PlayersThatHaveVoted.Length = 0;

		// Cache off these values in case player leaves before vote ends -- no cheating!
		CurrentSkipTraderVote.PlayerID = PRI.UniqueId;
		CurrentSkipTraderVote.PlayerPRI = PRI;
		CurrentSkipTraderVote.PlayerIPAddress = KFPC.GetPlayerNetworkAddress();

		bIsSkipTraderVoteInProgress = true;

		CurrentVoteTime = min(VoteTime, TraderTimeRemaining - SkipTraderVoteLimit);

		GetKFPRIArray(PRIs, , false);
		for (i = 0; i < PRIs.Length; i++)
		{
			PRIs[i].ShowSkipTraderVote(PRI, CurrentVoteTime, !(PRIs[i] == PRI) && PRI.GetTeamNum() != 255);
		}
		KFGI.BroadcastLocalized(KFGI, class'KFLocalMessage', LMT_SkipTraderVoteStarted, CurrentSkipTraderVote.PlayerPRI);
		SetTimer( CurrentVoteTime, false, nameof(ConcludeVoteSkipTrader), self );
		SetTimer( 1, true, nameof(UpdateTimer), self );
		// Cast initial vote
		RecieveVoteSkipTrader(PRI, true);

		KFPlayerReplicationInfo(PRI).bAlreadyStartedASkipTraderVote = true;
	}
	else
	{
		// Can't start a new vote until current one is over
		KFPlayerController(PRI.Owner).ReceiveLocalizedMessage(class'KFLocalMessage', LMT_SkipTraderVoteInProgress);
	}
}

function bool ShouldConcludeSkipTraderVote()
{
	local array<KFPlayerReplicationInfo> PRIs;
	local WMGameReplicationInfo WMGRI;
	local int NumPRIs, SkipVotesNeeded;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	GetKFPRIArray(PRIs, , False);
	NumPRIs = PRIs.Length;

	if (YesVotes + NoVotes >= NumPRIs)
	{
		return True;
	}
	else if (WMGRI != None)
	{
		SkipVotesNeeded = FCeil(float(NumPRIs) * class'ZedternalReborn.Config_GameOptions'.static.GetSkipTraderVotingPercentage(WMGRI.GameDifficulty));
		SkipVotesNeeded = Clamp(SkipVotesNeeded, 1, NumPRIs);

		if (YesVotes >= SkipVotesNeeded)
			return True;
		else if (NoVotes > (NumPRIs - SkipVotesNeeded))
			return True;
	}

	return False;
}

reliable server function ConcludeVoteSkipTrader()
{
	local array<KFPlayerReplicationInfo> PRIs;
	local WMGameReplicationInfo WMGRI;
	local int i, SkipVotesNeeded;
	local KFGameInfo KFGI;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	KFGI = KFGameInfo(WorldInfo.Game);

	if (bIsSkipTraderVoteInProgress)
	{
		GetKFPRIArray(PRIs, , False);

		for (i = 0; i < PRIs.Length; ++i)
		{
			PRIs[i].HideSkipTraderVote();
		}

		SkipVotesNeeded = FCeil(float(PRIs.Length) * class'ZedternalReborn.Config_GameOptions'.static.GetSkipTraderVotingPercentage(WMGRI.GameDifficulty));
		SkipVotesNeeded = Clamp(SkipVotesNeeded, 1, PRIs.Length);
		SetTimer(0.0f, True, NameOf(UpdateTimer), self);

		if (YesVotes >= SkipVotesNeeded)
		{
			//skip trader
			SkipTraderTime();

			//clear everything
			ResetSkipTraderVote();

			//tell server to skip trader
			KFGI.BroadcastLocalized(KFGI, class'KFLocalMessage', LMT_SkipTraderTimeSuccess);
		}
		else
		{
			//Set timer so that votes cannot be spammed
			bIsFailedVoteTimerActive = True;
			SetTimer(KFGI.TimeBetweenFailedVotes, False, NameOf(ClearFailedVoteFlag), self);
			KFGI.BroadcastLocalized(KFGI, class'KFLocalMessage', LMT_SkipTraderVoteFailed);
		}

		bIsSkipTraderVoteInProgress = False;
		CurrentSkipTraderVote.PlayerPRI = None;
		CurrentSkipTraderVote.PlayerID = class'PlayerReplicationInfo'.default.UniqueId;
		YesVotes = 0;
		NoVotes = 0;
	}
}

function ServerStartVotePauseGame(PlayerReplicationInfo PRI)
{
	local int i;
	local array<KFPlayerReplicationInfo> PRIs;
	local KFGameInfo KFGI;
	local KFPlayerController KFPC;
	local WMGameReplicationInfo WMGRI;
	local int WaveTimeRemaining;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	KFGI  = KFGameInfo(WorldInfo.Game);
	KFPC  = KFPlayerController(PRI.Owner);

	// Spectators aren't allowed to vote
	if(PRI.bOnlySpectator)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteNoSpectators : LMT_PauseVoteNoSpectators);
		return;
	}

	// Only pause the game if there's no wave active
	if(WMGRI.bWaveIsActive)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteWaveActive : LMT_PauseVoteWaveActive);
		return;
	}

	if(!WMGRI.bEndlessMode)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', LMT_PauseVoteWrongMode);
		return;
	}

	// A pause vote is not allowed while another vote is active
	if(bIsKickVoteInProgress || bIsSkipTraderVoteInProgress)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', LMT_OtherVoteInProgress);
		return;
	}

	WaveTimeRemaining = WMGRI.GetTraderTimeRemaining();
	if(WaveTimeRemaining <= PauseGameVoteLimit)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteNoEnoughTime : LMT_PauseVoteNoEnoughTime);
		return;
	}

	if( !bIsPauseGameVoteInProgress )
	{
		// Clear voter array
		PlayersThatHaveVoted.Length = 0;

		// Cache off these values in case player leaves before vote ends -- no cheating!
		CurrentPauseGameVote.PlayerID = PRI.UniqueId;
		CurrentPauseGameVote.PlayerPRI = PRI;
		CurrentPauseGameVote.PlayerIPAddress = KFPC.GetPlayerNetworkAddress();

		bIsPauseGameVoteInProgress = true;

		CurrentVoteTime = min(VoteTime, WaveTimeRemaining - PauseGameVoteLimit);

		GetKFPRIArray(PRIs);
		for (i = 0; i < PRIs.Length; i++)
		{
			PRIs[i].ShowPauseGameVote(PRI, CurrentVoteTime, !(PRIs[i] == PRI));
		}

		KFGI.BroadcastLocalized(KFGI, class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteStarted : LMT_PauseVoteStarted, CurrentPauseGameVote.PlayerPRI);
		SetTimer( CurrentVoteTime, false, nameof(ConcludeVotePauseGame), self );
		SetTimer( 1, true, nameof(UpdatePauseGameTimer), self );
		// Cast initial vote
		ReceiveVotePauseGame(PRI, true);

		KFPlayerReplicationInfo(PRI).bAlreadyStartedAPauseGameVote = true;
	}
	else
	{
		// Can't start a new vote until current one is over
		KFPlayerController(PRI.Owner).ReceiveLocalizedMessage(class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteInProgress : LMT_PauseVoteInProgress);
	}
}

reliable server function ReceiveVotePauseGame(PlayerReplicationInfo PRI, bool bSkip)
{
	local KFPlayerController KFPC;
	local WMGameReplicationInfo WMGRI;

	if(PlayersThatHaveVoted.Find(PRI) == INDEX_NONE)
	{
		//accept their vote
		PlayersThatHaveVoted.AddItem(PRI);
		if(bSkip)
		{
			yesVotes++;
		}
		else
		{
			noVotes++;
		}

		KFPC = KFPlayerController(PRI.Owner);
		if(KFPC != none)
		{
			WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
			if(bSkip)
			{
				KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteYesReceived : LMT_PauseVoteYesReceived);
			}
			else
			{
				KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteNoReceived : LMT_PauseVoteNoReceived);
			}
		}

		if( ShouldConcludePauseGameVote() )
		{
			ConcludeVotePauseGame();
		}
		else
		{
			ReplicatePauseGameVotes();
		}
	}
}

function bool ShouldConcludePauseGameVote()
{
	local array<KFPlayerReplicationInfo> PRIs;
	local WMGameReplicationInfo WMGRI;
	local int NumPRIs, PauseVotesNeeded;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	GetKFPRIArray(PRIs, , False);
	NumPRIs = PRIs.Length;

	if (YesVotes + NoVotes >= NumPRIs)
	{
		return True;
	}
	else if (WMGRI != None)
	{
		PauseVotesNeeded = FCeil(float(NumPRIs) * class'ZedternalReborn.Config_GameOptions'.static.GetPauseGameVotingPercentage(WMGRI.GameDifficulty));
		PauseVotesNeeded = Clamp(PauseVotesNeeded, 1, NumPRIs);

		if (YesVotes >= PauseVotesNeeded)
			return True;
		else if (NoVotes > (NumPRIs - PauseVotesNeeded))
			return True;
	}

	return False;
}

reliable server function ConcludeVotePauseGame()
{
	local array<KFPlayerReplicationInfo> PRIs;
	local WMGameReplicationInfo WMGRI;
	local int i, PauseVotesNeeded;
	local KFGameInfo KFGI;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);
	KFGI  = KFGameInfo(WorldInfo.Game);

	if (bIsPauseGameVoteInProgress)
	{
		GetKFPRIArray(PRIs, , False);

		for (i = 0; i < PRIs.Length; ++i)
		{
			PRIs[i].HidePauseGameVote();
		}

		PauseVotesNeeded = FCeil(float(PRIs.Length) * class'ZedternalReborn.Config_GameOptions'.static.GetPauseGameVotingPercentage(WMGRI.GameDifficulty));
		PauseVotesNeeded = Clamp(PauseVotesNeeded, 1, PRIs.Length);
		SetTimer(0.0f, True, NameOf(UpdatePauseGameTimer), self);

		if (YesVotes >= PauseVotesNeeded)
		{
			//pause game
			if (WMGRI.bIsPaused)
			{
				WMGRI.bIsPaused = False;
				WMGRI.bNoTraderDuringPause = False;
				WMGRI.bIsEndlessPaused = False;
				WMGRI.bStopCountDown = False;
				KFGI.ResumeEndlessGame();
			}
			else
			{
				WMGRI.bIsPaused = True;
				WMGRI.bNoTraderDuringPause = !class'ZedternalReborn.Config_GameOptions'.static.GetShouldAllowTraderDuringPause(WMGRI.GameDifficulty);
				WMGRI.bIsEndlessPaused = !class'ZedternalReborn.Config_GameOptions'.static.GetShouldAllowPickupsDuringPause(WMGRI.GameDifficulty);
				WMGRI.bStopCountDown = True;
				KFGI.PauseEndlessGame();
			}

			//clear everything
			ResetPauseGameVote();

			//tell server to skip trader
			KFGI.BroadcastLocalized(KFGI, class'KFLocalMessage',  WMGRI.bIsPaused ? LMT_PauseVoteSuccess : LMT_ResumeVoteSuccess);
		}
		else
		{
			//Set timer so that votes cannot be spammed
			bIsFailedVoteTimerActive = True;
			SetTimer(KFGI.TimeBetweenFailedVotes, False, NameOf(ClearFailedVoteFlag), self);
			KFGI.BroadcastLocalized(KFGI, class'KFLocalMessage', WMGRI.bIsPaused ? LMT_ResumeVoteFailed : LMT_PauseVoteFailed);
		}

		bIsPauseGameVoteInProgress = False;
		CurrentPauseGameVote.PlayerPRI = None;
		CurrentPauseGameVote.PlayerID = class'PlayerReplicationInfo'.default.UniqueId;
		YesVotes = 0;
		NoVotes = 0;
	}
}

defaultproperties
{
	Name="Default__WMVoteCollector"
}
