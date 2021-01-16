class WMGFxHUD_PlayerStatus extends KFGFxHUD_PlayerStatus;

function UpdatePerk()
{
	local int CurrentPerkLevel;
	local GFxObject PerkIconObject;

	if (WMPlayerController(MyPC) == None || MyPC.CurrentPerk == None)
	{
		return;
	}

	CurrentPerkLevel = WMPlayerController(MyPC).GetCurrentLevel();

	// Update perk Icon
	if (WMPlayerController(MyPC).bShouldUpdateHUDPerkIcon)
	{
		PerkIconObject = CreateObject("Object");
		PerkIconObject.SetString("perkIcon", "");
		PerkIconObject.SetString("prestigeIcon", "img://"$ WMPlayerController(MyPC).GetPerkIconPath());
		SetObject("playerPerkIcon", PerkIconObject);
	}

	// Update the perk class.
	if( LastPerkLevel != CurrentPerkLevel )
	{
		LastPerkClass = MyPC.CurrentPerk.class;

		SetInt("playerPerkLevel" , CurrentPerkLevel);
		LastPerkLevel = CurrentPerkLevel;

		SetInt("playerPerkXPPercent", 0);
	}
}

defaultproperties
{
	Name="Default__WMGFxHUD_PlayerStatus"
}
