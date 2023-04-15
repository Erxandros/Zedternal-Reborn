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

function ServerStartVotePauseGame(PlayerReplicationInfo PRI)
{
	local int i;
	local array<KFPlayerReplicationInfo> PRIs;
	local KFGameInfo KFGI;
	local KFPlayerController KFPC;
	local KFGameReplicationInfo KFGRI;
	local int WaveTimeRemaining;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	KFGI  = KFGameInfo(WorldInfo.Game);
	KFPC  = KFPlayerController(PRI.Owner);

	// Spectators aren't allowed to vote
	if(PRI.bOnlySpectator)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', KFGRI.bIsEndlessPaused ? LMT_ResumeVoteNoSpectators : LMT_PauseVoteNoSpectators);
		return;
	}

	// Only pause the game if there's no wave active
	if(KFGRI.bWaveIsActive)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', KFGRI.bIsEndlessPaused ? LMT_ResumeVoteWaveActive : LMT_PauseVoteWaveActive);
		return;
	}

	if(!KFGRI.bEndlessMode)
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

	WaveTimeRemaining = KFGRI.GetTraderTimeRemaining();
	if(WaveTimeRemaining <= PauseGameVoteLimit)
	{
		KFPC.ReceiveLocalizedMessage(class'KFLocalMessage', KFGRI.bIsEndlessPaused ? LMT_ResumeVoteNoEnoughTime : LMT_PauseVoteNoEnoughTime);
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

		KFGI.BroadcastLocalized(KFGI, class'KFLocalMessage', KFGRI.bIsEndlessPaused ? LMT_ResumeVoteStarted : LMT_PauseVoteStarted, CurrentPauseGameVote.PlayerPRI);
		SetTimer( CurrentVoteTime, false, nameof(ConcludeVotePauseGame), self );
		SetTimer( 1, true, nameof(UpdatePauseGameTimer), self );
		// Cast initial vote
		ReceiveVotePauseGame(PRI, true);

		KFPlayerReplicationInfo(PRI).bAlreadyStartedAPauseGameVote = true;
	}
	else
	{
		// Can't start a new vote until current one is over
		KFPlayerController(PRI.Owner).ReceiveLocalizedMessage(class'KFLocalMessage', KFGRI.bIsEndlessPaused ? LMT_ResumeVoteInProgress : LMT_PauseVoteInProgress);
	}
}

defaultproperties
{
	Name="Default__WMVoteCollector"
}
