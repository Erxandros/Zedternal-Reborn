class WMGFxWidget_PartyInGame extends KFGFxWidget_PartyInGame;

var WMGameReplicationInfo WMGRI;

var localized string CycleListString;

function InitializeWidget()
{
	super.InitializeWidget();
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
}

function LocalizeText()
{
	local GFxObject TextObject;
	local WorldInfo TempWorldInfo;

	TextObject = CreateObject("Object");

	TextObject.SetString("readyString", ReadyString);
	TextObject.SetString("leaveString", LeaveString);
	TextObject.SetString("createPartyString", CreatePartyString);
	TextObject.SetString("deployingString", DeployingString);
	TextObject.SetString("waitingString", WaitingString);
	TextObject.SetString("selectPromptString", Localize("KFGFxWidget_ButtonPrompt", "ConfirmString", "KFGame"));
	TextObject.SetString("backPromptString", Localize("KFGFxWidget_ButtonPrompt", "CancelString", "KFGame"));
	TextObject.SetString("matchOver", MatchOverString);

	if (WMGRI == None)
	{
		TempWorldInfo = class'WorldInfo'.static.GetWorldInfo();
		if (TempWorldInfo != None && TempWorldInfo.GRI != None)
			WMGRI = WMGameReplicationInfo(TempWorldInfo.GRI);
	}

	if (WMGRI != None)
		SetString("endlessPauseString", WMGRI.bIsPaused ? ResumeGameString : PauseGameString);

	SetObject("localizedText", TextObject);
	RefreshCycleButton();
}

function UpdateInLobby(bool bIsInLobby)
{
	local bool bShouldShowCreateParty;

	if (bIsInLobby != bInLobby)
	{
		bInLobby = bIsInLobby;
		RefreshParty();
	}

	if (Manager.StartMenu != None)
	{
		if (GetPC().WorldInfo.IsMenuLevel())
		{
			bShouldShowCreateParty = !bInLobby && EStartMenuState(Manager.StartMenu.GetStartMenuState()) != ESoloGame;
		}
		else if (class'WorldInfo'.static.IsConsoleBuild())
		{
			bShouldShowCreateParty = GetPC().WorldInfo.NetMode != NM_Standalone && !bInLobby;
		}

		if (bCreatePartyVisible != bShouldShowCreateParty)
		{
			bCreatePartyVisible = bShouldShowCreateParty;
			SetBool("partyButtonVisible",bCreatePartyVisible);
		}
	}

	SetBool("bInParty", bIsInLobby);
}

function UpdateEndlessPauseButtonText()
{
	local bool bIsConsole;

	if (EndlessPauseButton != None)
	{
		bIsConsole = GetPC().WorldInfo.IsConsoleBuild();
		if(bIsConsole)
			EndlessPauseButton.SetString("label", WMGRI.bIsPaused ? ("  "@default.ResumeGameString) : ("  "@default.PauseGameString));
		else
			EndlessPauseButton.SetString("label", WMGRI.bIsPaused ? default.ResumeGameString : default.PauseGameString);
	}
}

function RefreshCycleButton()
{
	local array<KFPlayerReplicationInfo> KFPRIArray;

	GetKFPRIArray(KFPRIArray);
	if (KFPRIArray.Length <= 0 || PlayerSlots <= 0 || WMGRI == None)
	{
		SetString("switchTeamsString", "NULL");
		return;
	}

	WMGRI.LobbyMaxPage = KFPRIArray.Length / PlayerSlots + Min(1, KFPRIArray.Length % PlayerSlots);
	SetString("switchTeamsString", "" $ default.CycleListString @ WMGRI.LobbyCurrentPage $ "/" $ WMGRI.LobbyMaxPage);
}

function OneSecondLoop()
{
	super.OneSecondLoop();
	if (WMGRI == None)
	{
		WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	}
	RefreshCycleButton();
}

function int GetOffsetRefreshParty(int Slots)
{
	local byte i;

	if (WMGRI != None)
	{
		for (i = WMGRI.LobbyCurrentPage - 1; i > 0; --i)
		{
			if (i * PlayerSlots < Slots)
				return i * PlayerSlots;
			else
				--WMGRI.LobbyCurrentPage;
		}
	}

	return 0;
}

function UpdateEndlessPauseButtonVisibility()
{
	if (KFGRI == None)
		return;

	//sanity check because this is happening
	if (MyKFPRI == None)
		MyKFPRI = KFPlayerReplicationInfo(GetPC().PlayerReplicationInfo);

	if (GetPC().WorldInfo.NetMode != NM_Standalone
		&& KFGRI.bMatchHasBegun
		&& (WMGameReplicationInfo(KFGRI) != None && WMGameReplicationInfo(KFGRI).bPauseButtonEnabled)
		&& (MyKFPRI != None && MyKFPRI.bHasSpawnedIn && !KFGRI.bWaveIsActive)
		&& !KFGRI.bMatchIsOver
		&& KFGRI.bEndlessMode)
	{
		UpdateEndlessPauseButtonText();
		SetBool("endlessPauseButtonVisible", True);
	}
	else
		SetBool("endlessPauseButtonVisible", False);

	if (EndlessPauseButton != None)
		EndlessPauseButton.SetBool("selected", False);
}

function RefreshParty()
{
	local array<KFPlayerReplicationInfo> KFPRIArray;
	local int OffsetIndex, SlotIndex;
	local GFxObject DataProvider;

	DataProvider = CreateArray();
	if (!Manager.bStatsInitialized)
	{
		return;
	}
	super.RefreshParty();

	GetKFPRIArray(KFPRIArray);
	if (KFPRIArray.Length <= 0)
	{
		return;
	}
	if (PartyChatWidget != None)
	{
		PartyChatWidget.SetLobbyChatVisible(KFPRIArray.Length > 1);
	}

	UpdateInLobby(KFPRIArray.Length > 1);

	OccupiedSlots = KFPRIArray.Length;
	OffsetIndex = GetOffsetRefreshParty(KFPRIArray.Length);

	for (SlotIndex = 0; SlotIndex < PlayerSlots; ++SlotIndex)
	{
		if (SlotIndex + OffsetIndex < KFPRIArray.Length)
		{
			DataProvider.SetElementObject(SlotIndex, RefreshSlot(SlotIndex, KFPRIArray[SlotIndex + OffsetIndex]));
		}
	}
	SetBool("bInParty", bInLobby || (GetPC().WorldInfo.NetMode != NM_Standalone));
	SetObject("squadInfo", DataProvider);
	UpdateSoloSquadText();
}

function GFxObject RefreshSlot(int SlotIndex, KFPlayerReplicationInfo KFPRI)
{
	local GFxObject WMPlayerInfoObject, WMPerkIconObject;
	local WMPlayerReplicationInfo WMPRI;

	WMPlayerInfoObject = super.RefreshSlot(SlotIndex, KFPRI);

	if (MemberSlots[SlotIndex].PRI != None)
	{
		WMPRI = WMPlayerReplicationInfo(MemberSlots[SlotIndex].PRI);
		if (WMPRI != None)
		{
			WMPlayerInfoObject.SetString("perkLevel", string(WMPRI.PlayerLevel));

			WMPerkIconObject = CreateObject("Object");
			WMPerkIconObject.SetString("perkIcon", "img://"$PathName(WMPRI.GetCurrentIconToDisplay()));
			WMPerkIconObject.SetString("prestigeIcon", "");

			WMPlayerInfoObject.SetObject("perkImageSource", WMPerkIconObject);
		}
	}

	return WMPlayerInfoObject;
}

function int GetPageOffset()
{
	if (WMGRI != None)
		return (WMGRI.LobbyCurrentPage - 1) * PlayerSlots;
	else
		return 0;
}

function ToggelMuteOnPlayer(int SlotIndex)
{
	local array<KFPlayerReplicationInfo> KFPRIArray;
	local UniqueNetId PlayerNetID;
	local PlayerController PC;
	local int offset;

	PC = GetPC();
	GetKFPRIArray(KFPRIArray);

	if (KFPRIArray.Length <= 0)
	{
		return;
	}

	offset = GetPageOffset();
	if (KFPRIArray.Length > SlotIndex + offset)
	{
		PlayerNetID = KFPRIArray[SlotIndex + offset].UniqueId;
		if (PC.IsPlayerMuted(PlayerNetID))
		{
			PC.ServerUnMutePlayer(PlayerNetID, !class'WorldInfo'.static.IsConsoleBuild());
			if (MemberSlots[SlotIndex].MemberSlotObject != None)
				MemberSlots[SlotIndex].MemberSlotObject.SetBool("isMuted", False);
		}
		else
		{
			PC.ServerMutePlayer(PlayerNetID, !class'WorldInfo'.static.IsConsoleBuild());
			if (MemberSlots[SlotIndex].MemberSlotObject != None)
				MemberSlots[SlotIndex].MemberSlotObject.SetBool("isMuted", True);
		}
	}
	super.ToggelMuteOnPlayer(SlotIndex);
}

function ViewProfile(int SlotIndex)
{
	super.ViewProfile(SlotIndex + GetPageOffset());
}

function AddFriend(int SlotIndex)
{
	super.AddFriend(SlotIndex + GetPageOffset());
}

function KickPlayer(int SlotIndex)
{
	super.KickPlayer(SlotIndex + GetPageOffset());
}

defaultproperties
{
	PlayerSlots=12
	Name="Default__WMGFxWidget_PartyInGame"
}
