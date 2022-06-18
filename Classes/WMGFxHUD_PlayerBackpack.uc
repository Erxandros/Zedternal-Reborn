class WMGFxHUD_PlayerBackpack extends KFGFxHUD_PlayerBackpack;

function UpdateGrenades()
{
	local int CurrentGrenades;

	if (WMPlayerController(MyKFPC) == None)
	{
		return;
	}

	if (MyKFInvManager != None)
	{
		CurrentGrenades = MyKFInvManager.GrenadeCount;
	}

	//Update the icon the for grenade type.
	if (WMPlayerController(MyKFPC).CurrentPerk != None)
	{
		if (WMPlayerController(MyKFPC).bShouldUpdateGrenadeIcon)
		{
			SetString("backpackGrenadeType", "img://" $ MyKFPC.CurrentPerk.GetGrenadeImagePath());
			WMPlayerController(MyKFPC).bShouldUpdateGrenadeIcon = False;
		}
	}
	// Update the grenades count value
	if (CurrentGrenades != LastGrenades)
	{
		if (CurrentGrenades > 9)
			SetInt("backpackGrenades", 9);
		else
			SetInt("backpackGrenades", CurrentGrenades);

		LastGrenades = CurrentGrenades;
	}
}

defaultproperties
{
	Name="Default__WMGFxHUD_PlayerBackpack"
}
