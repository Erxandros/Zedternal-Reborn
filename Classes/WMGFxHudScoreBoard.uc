class WMGFxHudScoreBoard extends WMGFxScoreBoardStyleBase;

var transient float PerkXPos, PlayerXPos, KillsXPos, AssistXPos, CashXPos, HealthXPos, ArmorXPos, PingXPos, PlatformXPos;

var localized string PlayersString;
var localized string AliveString;
var localized string SpectatorsString;
var localized string PerkString;
var localized string HealthString;
var localized string ArmorString;
var localized string PlatformString;
var localized string SpectatorString;
var localized string LobbyString;
var localized string DeadString;
var localized string BotPlatformString;
var localized string EpicPlatformString;
var localized string SteamPlatformString;
var localized string UnknownPlatformString;

final function PlayerController GetPlayer()
{
	return GetALocalPlayerController();
}

static final function string FormatTimeSMH(float TotalSeconds)
{
	local int Hours, Minutes, Seconds;

	TotalSeconds = int(Abs(TotalSeconds));
	Hours = TotalSeconds / 3600;
	Minutes = (TotalSeconds / 60) % 60;
	Seconds = TotalSeconds % 60;

	return ((Hours < 10) ? "0" $ Hours : string(Hours)) @ ":" @ ((Minutes < 10) ? "0" $ Minutes : string(Minutes)) @ ":" @ ((Seconds < 10) ? "0" $ Seconds : string(Seconds));
}

function bool InOrder(PlayerReplicationInfo A, PlayerReplicationInfo B)
{
	if (A.Kills != B.Kills)
		return (A.Kills < B.Kills);

	if (A.Score != B.Score)
		return (A.Score < B.Score);

	return (A.PlayerID < B.PlayerID);
}

//For QuickSort
final function int QuickPartition(out array<PlayerReplicationInfo> PRIArray, int low, int high)
{
	local PlayerReplicationInfo pivot, temp;
	local int i, j;

	pivot = PRIArray[high];
	i = low - 1;

	for (j = low; j < high; ++j)
	{
		if (!InOrder(PRIArray[j], pivot))
		{
			++i;

			temp = PRIArray[i];
			PRIArray[i] = PRIArray[j];
			PRIArray[j] = temp;
		}
	}

	temp = PRIArray[i + 1];
	PRIArray[i + 1] = PRIArray[high];
	PRIArray[high] = temp;

	return i + 1;
}

final function QuickSort(out array<PlayerReplicationInfo> PRIArray, int low, int high)
{
	local int pivot;

	if (low < high)
	{
		pivot = QuickPartition(PRIArray, low, high);

		QuickSort(PRIArray, low, pivot - 1);
		QuickSort(PRIArray, pivot + 1, high);
	}
}

event Draw(Canvas canvas)
{
	local String S;
	local PlayerController PC;
	local KFGameReplicationInfo KFGRI;
	local WMPlayerReplicationInfo WMPRI;
	local array<WMPlayerReplicationInfo> WMPRIArray;
	local float XPos, YPos, XL, YL, FontScalar, XPosCenter;
	local int i, j, PlayerIndex, NumSpec, NumPlayer, NumAlivePlayer, Width;

	// Get the current KFGameReplicationInfo
	PC = GetPlayer();
	if (KFGRI == None)
	{
		KFGRI = KFGameReplicationInfo(PC.WorldInfo.GRI);
		if (KFGRI == None)
			return;
	}

	// Sort player list
	QuickSort(KFGRI.PRIArray, 0, KFGRI.PRIArray.Length - 1);

	////// Check players
	PlayerIndex = INDEX_NONE;
	NumPlayer = 0;
	for (i = (KFGRI.PRIArray.Length - 1); i >= 0; --i)
	{
		WMPRI = WMPlayerReplicationInfo(KFGRI.PRIArray[i]);
		if (WMPRI == None)
			continue;

		if (WMPRI.bOnlySpectator)
		{
			++NumSpec;
			continue;
		}

		if (WMPRI.PlayerHealthInt > 0 && WMPRI.GetTeamNum() == 0)
			++NumAlivePlayer;

		++NumPlayer;
	}
	//////

	////// Build WMPRIArray for scoreboard
	WMPRIArray.Length = NumSpec + NumPlayer;

	j = WMPRIArray.Length;
	for (i = (KFGRI.PRIArray.Length - 1); i >= 0; --i)
	{
		WMPRI = WMPlayerReplicationInfo(KFGRI.PRIArray[i]);
		if (WMPRI != None)
		{
			WMPRIArray[--j] = WMPRI;
			if (WMPRI == PC.PlayerReplicationInfo)
				PlayerIndex = j;
		}
	}
	//////

	////// Header font info
	ScoreBoardCanvas = canvas;
	ScoreBoardCanvas.Font = DrawFont;

	PickDefaultFontSize(canvas.SizeX, canvas.SizeY, FontScalar);

	YL = DefaultHeight;
	XPosCenter = (ScoreBoardCanvas.ClipX * 0.5);
	//////

	////// ServerName
	XPos = XPosCenter;
	YPos = ScoreBoardCanvas.ClipY * 0.05;

	if (PC.WorldInfo.NetMode != NM_Standalone)
		S = " " $KFGRI.ServerName $" ";
	else
		S = " ZedternalReborn" @class'KFCommon_LocalizedStrings'.default.DiscordSoloMatchString $" ";

	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos -= (XL * 0.5);

	ScoreBoardCanvas.SetDrawColor(10, 10, 10, 150);
	DrawRectBox(XPos, YPos, XL, YL, 4);

	ScoreBoardCanvas.DrawColor = MakeColor(178, 15, 15, 255);
	XPos += 5;

	if (PC.WorldInfo.NetMode != NM_Standalone)
		S = KFGRI.ServerName;
	else
		S = "ZedternalReborn" @class'KFCommon_LocalizedStrings'.default.DiscordSoloMatchString;

	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	//////

	////// Difficulty | Wave | MapName | ElapsedTime
	XPos = XPosCenter;
	YPos += YL;

	S = Class'KFCommon_LocalizedStrings'.Static.GetDifficultyString(KFGRI.GameDifficulty);
	// Change for Custom difficulty
	if (S ~= class'KFCommon_LocalizedStrings'.default.NoPreferenceString)
		S = class'KFCommon_LocalizedStrings'.default.CustomString;

	S = " " $S $"  |  " $class'KFGFxHUD_ScoreboardMapInfoContainer'.default.WaveString @KFGRI.WaveNum $"  |  " $PC.WorldInfo.Title $"  |  00 : 00 : 00 ";
	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos -= (XL * 0.5);

	ScoreBoardCanvas.SetDrawColor(10, 10, 10, 150);
	DrawRectBox(XPos, YPos, XL, YL, 4);

	ScoreBoardCanvas.DrawColor = MakeColor(98, 83, 62, 255);
	XPos += 5;

	S = Class'KFCommon_LocalizedStrings'.Static.GetDifficultyString(KFGRI.GameDifficulty);
	// Change for Custom difficulty
	if (S ~= class'KFCommon_LocalizedStrings'.default.NoPreferenceString)
		S = class'KFCommon_LocalizedStrings'.default.CustomString;
	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos += XL;
	S = "  |  " $class'KFGFxHUD_ScoreboardMapInfoContainer'.default.WaveString @KFGRI.WaveNum;
	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos += XL;
	S = "  |  " $PC.WorldInfo.Title;
	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos += XL;
	S = "  |  " $FormatTimeSMH(KFGRI.ElapsedTime);
	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	//////

	////// Players | Alive | Spectators
	XPos = XPosCenter;
	YPos += YL;

	S = " " $default.PlayersString $" : " $NumPlayer $"  |  " $default.AliveString $" : " $NumAlivePlayer $"  |  " $default.SpectatorsString $" : " $NumSpec $" ";
	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos -= (XL * 0.5);

	ScoreBoardCanvas.SetDrawColor(10, 10, 10, 150);
	DrawRectBox(XPos, YPos, XL, YL, 4);

	ScoreBoardCanvas.DrawColor = MakeColor(255, 145, 0, 255);
	XPos += 5;

	S = default.PlayersString $" : " $NumPlayer;
	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos += XL;
	S = "  |  " $default.AliveString $" : " $NumAlivePlayer;
	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	ScoreBoardCanvas.TextSize(S, XL, YL, FontScalar, FontScalar);

	XPos += XL;
	S = "  |  " $default.SpectatorsString $" : " $NumSpec;
	ScoreBoardCanvas.SetPos(XPos, YPos);
	ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
	//////

	////// ScoreBoardCanvas spacing
	Width = ScoreBoardCanvas.ClipX * 0.7;

	XPos = (ScoreBoardCanvas.ClipX - Width) * 0.5;
	YPos += YL * 2.0;

	ScoreBoardCanvas.SetDrawColor(10, 10, 10, 150);
	DrawRectBox(XPos, YPos, Width, YL, 4);

	ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 255, 255);

	// Calculate X offsets
	PerkXPos = Width * 0.0125;
	PlayerXPos = Width * 0.100;
	KillsXPos = Width * 0.300;
	AssistXPos = Width * 0.400;
	CashXPos = Width * 0.500;
	HealthXPos = Width * 0.600;
	ArmorXPos = Width * 0.700;
	PingXPos = Width * 0.800;
	PlatformXPos = Width * 0.8625;

	// Header texts
	ScoreBoardCanvas.SetPos(XPos + PerkXPos, YPos);
	ScoreBoardCanvas.DrawText(default.PerkString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + PlayerXPos, YPos);
	ScoreBoardCanvas.DrawText(class'KFGFxHUD_ScoreboardWidget'.default.PlayerString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + KillsXPos, YPos);
	ScoreBoardCanvas.DrawText(class'KFGFxHUD_ScoreboardWidget'.default.KillsString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + AssistXPos, YPos);
	ScoreBoardCanvas.DrawText(class'KFGFxHUD_ScoreboardWidget'.default.AssistsString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + CashXPos, YPos);
	ScoreBoardCanvas.DrawText(class'KFGFxHUD_ScoreboardWidget'.default.DoshString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + HealthXPos, YPos);
	ScoreBoardCanvas.DrawText(default.HealthString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + ArmorXPos, YPos);
	ScoreBoardCanvas.DrawText(default.ArmorString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + PingXPos, YPos);
	ScoreBoardCanvas.DrawText(class'KFGFxHUD_ScoreboardWidget'.default.PingString, , FontScalar, FontScalar);

	ScoreBoardCanvas.SetPos(XPos + PlatformXPos, YPos);
	ScoreBoardCanvas.DrawText(default.PlatformString, , FontScalar, FontScalar);
	//////

	for (i = 0; i < WMPRIArray.length; ++i)
	{
		////// Player slot
		WMPRI = WMPRIArray[i];

		Width = ScoreBoardCanvas.ClipX * 0.7;

		XPos = (ScoreBoardCanvas.ClipX - Width) * 0.5;
		YPos += YL + 4;

		if (i == PlayerIndex)
			ScoreBoardCanvas.SetDrawColor(121, 121, 121, 150);
		else
			ScoreBoardCanvas.SetDrawColor(30, 30, 30, 150);

		DrawRectBox(XPos, YPos, Width, YL, 4);

		ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 255, 255);
		//////

		////// Perk
		ScoreBoardCanvas.SetPos(XPos + PerkXPos, YPos);

		if (WMPRI.bOnlySpectator)
			S = default.SpectatorString;
		else if (WMPRI.bWaitingPlayer)
			S = default.LobbyString;
		else
			S = " Lv" @string(WMPRI.PlayerLevel);

		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
		//////

		////// Player
		ScoreBoardCanvas.SetPos(XPos + PlayerXPos, YPos);

		if (Len(WMPRI.PlayerName) > 32)
			S = Left(WMPRI.PlayerName, 32);
		else
			S = WMPRI.PlayerName;

		ScoreBoardCanvas.DrawText(S, , AdjustPlayerNameScaler(FontScalar, Len(S), DefaultFontSize), FontScalar);
		//////

		////// Kills
		if (WMPRI.bOnlySpectator || WMPRI.bWaitingPlayer)
			S = "-";
		else
			S = string(WMPRI.Kills);

		ScoreBoardCanvas.SetPos(XPos + KillsXPos, YPos);
		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
		//////

		////// Assists
		if (WMPRI.bOnlySpectator || WMPRI.bWaitingPlayer)
			S = "-";
		else
			S = string(WMPRI.Assists);

		ScoreBoardCanvas.SetPos(XPos + AssistXPos, YPos);
		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
		//////

		////// Dosh
		if (WMPRI.bOnlySpectator || WMPRI.bWaitingPlayer)
			S = "-";
		else
			S = string(int(WMPRI.Score));

		ScoreBoardCanvas.SetPos(XPos + CashXPos, YPos);
		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
		//////

		////// Health
		if (WMPRI.bOnlySpectator || WMPRI.bWaitingPlayer)
		{
			S = "-";
		}
		else if (WMPRI.PlayerHealthInt <= 0)
		{
			ScoreBoardCanvas.DrawColor = MakeColor(255, 0, 0, 255);
			S = default.DeadString;
		}
		else
		{
			if (WMPRI.PlayerHealthInt >= 150)
				ScoreBoardCanvas.DrawColor = MakeColor(46, 139, 87, 255);
			else if (WMPRI.PlayerHealthInt >= 70)
				ScoreBoardCanvas.DrawColor = MakeColor(0, 255, 0, 255);
			else if (WMPRI.PlayerHealthInt >= 30)
				ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 0, 255);
			else
				ScoreBoardCanvas.DrawColor = MakeColor(255, 99, 71, 255);

			S = string(WMPRI.PlayerHealthInt) @"HP";
		}

		ScoreBoardCanvas.SetPos(XPos + HealthXPos, YPos);
		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);

		ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 255, 255);
		//////

		////// Armor
		if (WMPRI.bOnlySpectator || WMPRI.bWaitingPlayer)
		{
			S = "-";
		}
		else if (WMPRI.PlayerArmorInt <= 0 || WMPRI.PlayerHealthInt <= 0)
		{
			ScoreBoardCanvas.DrawColor = MakeColor(255, 0, 0, 255);
			if (WMPRI.PlayerHealthInt <= 0)
				S = default.DeadString;
			else
				S = string(0) @"AP";
		}
		else
		{
			if (WMPRI.PlayerArmorInt >= 150)
				ScoreBoardCanvas.DrawColor = MakeColor(147, 112, 219, 255);
			else if (WMPRI.PlayerArmorInt >= 70)
				ScoreBoardCanvas.DrawColor = MakeColor(0, 255, 255, 255);
			else if (WMPRI.PlayerArmorInt >= 30)
				ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 0, 255);
			else
				ScoreBoardCanvas.DrawColor = MakeColor(255, 99, 71, 255);

			S = string(WMPRI.PlayerArmorInt) @"AP";
		}

		ScoreBoardCanvas.SetPos(XPos + ArmorXPos, YPos);
		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);

		ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 255, 255);
		//////

		////// Ping
		if (WMPRI.bBot || WMPRI.bOnlySpectator || WMPRI.bWaitingPlayer)
		{
			S = "-";
		}
		else
		{
			if (WMPRI.UncompressedPing <= 100)
				ScoreBoardCanvas.DrawColor = MakeColor(0, 255, 0, 255);
			else if (WMPRI.UncompressedPing <= 200)
				ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 0, 255);
			else if (WMPRI.UncompressedPing <= 300)
				ScoreBoardCanvas.DrawColor = MakeColor(255, 99, 71, 255);
			else
				ScoreBoardCanvas.DrawColor = MakeColor(255, 0, 0, 255);

			S = string(WMPRI.UncompressedPing);
		}

		ScoreBoardCanvas.SetPos(XPos + PingXPos, YPos);
		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);

		ScoreBoardCanvas.DrawColor = MakeColor(255, 255, 255, 255);
		//////

		////// Platform
		if (WMPRI.bBot)
			S = default.BotPlatformString;
		else if (WMPRI.PlatformType == 2)
			S = default.EpicPlatformString;
		else if (WMPRI.PlatformType == 1)
			S = default.SteamPlatformString;
		else
			S = default.UnknownPlatformString;

		ScoreBoardCanvas.SetPos(XPos + PlatformXPos, YPos);
		ScoreBoardCanvas.DrawText(S, , FontScalar, FontScalar);
		//////
	}
}

defaultproperties
{
	Name="Default__WMGFxHudScoreBoard"
}
