class WMGFxHUD_WaveInfo extends KFGFxHUD_WaveInfo;

function UpdateWaveCount()
{
	local int CurrentWaveMax, CurrentWave;

	if (KFGRI == None)
		KFGRI = KFGameReplicationInfo(GetPC().WorldInfo.GRI);

	if (KFGRI == None || WMGameReplicationInfo(KFGRI) == None)
		return;

	CurrentWaveMax = KFGRI.GetFinalWaveNum();
	if (LastWaveMax != CurrentWaveMax)
	{
		SetInt("maxWaves", WMGameReplicationInfo(KFGRI).HasFinalWave() ? CurrentWaveMax : INDEX_NONE);
		LastWaveMax = CurrentWaveMax;
	}

	CurrentWave = KFGRI.WaveNum;
	if (CurrentWave != LastWave)
	{
		SetInt("currentWave", CurrentWave);
		LastWave = CurrentWave;
	}
}

defaultproperties
{
	Name="Default__WMGFxHUD_WaveInfo"
}
