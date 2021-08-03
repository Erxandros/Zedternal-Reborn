class WMGFxTraderContainer_GameInfo extends KFGFxTraderContainer_GameInfo;

function UpdateGameInfo()
{
	local WMGameReplicationInfo WMGRI;
	local string FinalWaveString;

	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	if (WMGRI != None)
	{
		if (WMGRI.IsBossWave())
		{
			FinalWaveString = BossWaveString;
		}
		else
		{
			if (!WMGRI.HasFinalWave())
				FinalWaveString = WaveString @ (WMGRI.WaveNum);
			else
				FinalWaveString = WaveString @ (WMGRI.WaveNum) $ "/" $ WMGRI.GetFinalWaveNum();
		}

		SetString("waveValue", FinalWaveString);
		SetString("timeLabel", TimeLeftString);
	}
	UpdateTraderTimer();
}

defaultproperties
{
	Name="Default__WMGFxTraderContainer_GameInfo"
}
