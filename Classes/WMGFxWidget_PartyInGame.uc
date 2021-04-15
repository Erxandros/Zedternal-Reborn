class WMGFxWidget_PartyInGame extends KFGFxWidget_PartyInGame;

var WMGameReplicationInfo WMGRI;

function InitializeWidget()
{
	super.InitializeWidget();
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
}

function LocalizeText()
{
	super.LocalizeText();
	RefreshCycleButton();
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
	SetString("switchTeamsString", "Cycle List" @ WMGRI.LobbyCurrentPage $ "/" $ WMGRI.LobbyMaxPage);
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

function RefreshParty()
{
	local array<KFPlayerReplicationInfo> KFPRIArray;
	local int OffsetIndex, SlotIndex;
	local GFxObject DataProvider;

	DataProvider = CreateArray();
	if(!Manager.bStatsInitialized)
	{
		return;
	}
	super.RefreshParty();

	GetKFPRIArray(KFPRIArray);
	if (KFPRIArray.Length <= 0)
	{
		return;
	}
	if(PartyChatWidget != none)
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

	if (MemberSlots[SlotIndex].PRI != none)
	{
		WMPRI = WMPlayerReplicationInfo(MemberSlots[SlotIndex].PRI);
		if (WMPRI != none)
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
				MemberSlots[SlotIndex].MemberSlotObject.SetBool("isMuted", false);
		}
		else
		{
			PC.ServerMutePlayer(PlayerNetID, !class'WorldInfo'.static.IsConsoleBuild());
			if (MemberSlots[SlotIndex].MemberSlotObject != None)
				MemberSlots[SlotIndex].MemberSlotObject.SetBool("isMuted", true);
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
