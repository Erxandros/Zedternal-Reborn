class WMGFxMenu_PostGameReport extends KFGFxMenu_PostGameReport;

function SetSumarryInfo()
{
	local string GameDifficultyString;
	local string GameTypeString;
	local string CurrentMapName;
	local WMGameReplicationInfo WMGRI;
	local GFxObject TextObject;
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(GetPC());

	TextObject = CreateObject("Object");

	CurrentMapName = GetPC().WorldInfo.GetMapName(True);

	GameTypeString = class'KFCommon_LocalizedStrings'.static.GetGameModeString(0);

	if (KFPC.WorldInfo.GRI != None)
	{
		WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
		if (KFPC.BeginningRoundVaultAmount > INDEX_NONE)
		{
			TextObject.SetInt("voshDelta", KFPC.GetTotalDoshCount() - KFPC.BeginningRoundVaultAmount);
		}

		GameDifficultyString = class'KFCommon_LocalizedStrings'.static.GetDifficultyString(WMGRI.GameDifficulty);
		GameTypeString = WMGRI.GameClass.default.GameName;

		TextObject.SetString("mapName", class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(CurrentMapName));
		TextObject.SetString("typeDifficulty", GameTypeString @ "-" @ GameDifficultyString);
		if (WMGRI.WaveNum == WMGRI.WaveMax)
		{
			TextObject.SetString("waveTime", class'KFGFxHUD_WaveInfo'.default.BossWaveString @ "-" @ FormatTime(WMGRI.ElapsedTime));
		}
		else
		{
			if (!WMGRI.HasFinalWave())
				TextObject.SetString("waveTime", WaveString @ WMGRI.WaveNum @ "-" @ FormatTime(WMGRI.ElapsedTime));
			else
				TextObject.SetString("waveTime", WaveString @ WMGRI.WaveNum $ "/" $ WMGRI.GetFinalWaveNum() @ "-" @ FormatTime(WMGRI.ElapsedTime));
		}

		TextObject.SetString("winLost", WMGRI.bMatchVictory ? VictoryString : DefeatString);
	}

	SetObject("gameSummary", TextObject);

	if (KFPC.WorldInfo.NetMode == NM_Client)
		KFPC.WorldInfo.ForceGarbageCollection(False);
}

defaultproperties
{
	SubWidgetBindings(0)=(WidgetName="playerStatsContainer",WidgetClass=class'ZedternalReborn.WMGFxPostGameContainer_PlayerStats')

	Name="Default__WMGFxMenu_PostGameReport"
}
