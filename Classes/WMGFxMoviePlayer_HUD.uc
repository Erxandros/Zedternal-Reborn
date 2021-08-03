class WMGFxMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

function DisplayExpandedWaveInfo()
{
	local WMGameReplicationInfo WMGRI;
	local KFWeeklyOutbreakInformation WeeklyInfo;
	local GFxObject PriorityMessageObject;
	local int ModifierIndex;

	switch (LastMessageType)
	{
		case GMT_WaveStart:
		case GMT_WaveStartWeekly:
		case GMT_WaveStartSpecial:
		case GMT_WaveSBoss:
			break;
		default:
			return;
	}

	PriorityMessageObject = CreateObject("Object");

	WMGRI = WMGameReplicationInfo(KFPC.WorldInfo.GRI);
	if (PriorityMessageContainer != None && WMGRI != None)
	{
		PriorityMessageObject = CreateObject("Object");
		if (!WMGRI.HasFinalWave())
		{
			PriorityMessageObject.SetString("waveNum", String(WMGRI.WaveNum));
		}
		else
		{
			if (WMGRI.IsBossWave())
			{
				PriorityMessageObject.SetString("waveNum", class'KFGFxHUD_WaveInfo'.default.BossWaveString);
			}
			else
			{
				if (WMGRI.IsFinalWave())
					PriorityMessageObject.SetString("waveNum", class'KFGFxHUD_WaveInfo'.default.FinalWaveString);
				else
					PriorityMessageObject.SetString("waveNum", WMGRI.WaveNum $ "/" @ WMGRI.GetFinalWaveNum());
			}
		}

		PriorityMessageObject.SetString("waveString", class'KFGFxHUD_WaveInfo'.default.WaveString);

		PriorityMessageObject.SetInt("waveTier", GetWaveTier());
		if (WMGRI.IsWeeklyWave(ModifierIndex))
		{
			WeeklyInfo = class'KFMission_LocalizedStrings'.static.GetWeeklyOutbreakInfoByIndex(ModifierIndex);
			PriorityMessageObject.SetString("waveType", WeeklyInfo.FriendlyName);
			PriorityMessageObject.SetString("waveImage", "img://" $ WeeklyInfo.IconPath);
		}
		else if (WMGRI.IsSpecialWave(ModifierIndex))
		{
			PriorityMessageObject.SetString("waveType", Localize("Zeds", SpecialWaveLocKey[ModifierIndex], "KFGame"));
			PriorityMessageObject.SetString("waveImage", "img://" $ SpecialWaveIconPath[ModifierIndex]);
		}

		PriorityMessageContainer.SetObject("waveNumberMessage", PriorityMessageObject);
	}
}

defaultproperties
{
	WidgetBindings(1)=(WidgetName="SpectatorInfoWidget",WidgetClass=class'ZedternalReborn.WMGFxHUD_SpectatorInfo')
	WidgetBindings(2)=(WidgetName="PlayerStatWidgetMC",WidgetClass=Class'ZedternalReborn.WMGFxHUD_PlayerStatus')
	WidgetBindings(3)=(WidgetName="PlayerBackpackWidget",WidgetClass=Class'ZedternalReborn.WMGFxHUD_PlayerBackpack')
	WidgetBindings(10)=(WidgetName="WaveInfoContainer",WidgetClass=class'ZedternalReborn.WMGFxHUD_WaveInfo')

	Name="Default__WMGFxMoviePlayer_HUD"
}
