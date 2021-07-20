class WMGFxHUD_SpectatorInfo extends KFGFxHUD_SpectatorInfo;

function UpdatePlayerInfo(optional bool bForceUpdate)
{
	local GFxObject TempObject;
	local byte CurrentPerkLevel;
	local byte CurrentPrestigeLevel;
	local GFxObject PerkIconObject;

	if (SpectatedKFPRI == None)
	{
		return;
	}

	CurrentPerkLevel = SpectatedKFPRI.GetActivePerkLevel();
	CurrentPrestigeLevel = SpectatedKFPRI.GetActivePerkPrestigeLevel();

	// Update the perk class.
	if (LastPerkClass != SpectatedKFPRI.CurrentPerkClass || LastPerkLevel != CurrentPerkLevel || LastPrestigeLevel != CurrentPrestigeLevel || bForceUpdate)
	{
		LastPerkLevel = CurrentPerkLevel;
		LastPerkClass = SpectatedKFPRI.CurrentPerkClass;
		LastPrestigeLevel = CurrentPrestigeLevel;

		TempObject = CreateObject("Object");
		if (TempObject != None)
		{
			TempObject.SetString("playerName", SpectatedKFPRI.PlayerName);
			if (WMPlayerReplicationInfo(SpectatedKFPRI) != None)
				TempObject.SetString("playerPerk", "Lv"@string(WMPlayerReplicationInfo(SpectatedKFPRI).PlayerLevel));
			else
				TempObject.SetString("playerPerk", "Lv"@string(SpectatedKFPRI.GetActivePerkLevel()));

			PerkIconObject = CreateObject("Object");
			PerkIconObject.SetString("perkIcon", "img://"$PathName(SpectatedKFPRI.GetCurrentIconToDisplay()));

			TempObject.SetObject("perkImageSource", PerkIconObject);

			SetObject("playerData", TempObject);
		}
	}
}

defaultproperties
{
	Name="Default__WMGFxHUD_SpectatorInfo"
}
