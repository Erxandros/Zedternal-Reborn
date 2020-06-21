class WMGFxHUD_PlayerBackpack extends KFGFxHUD_PlayerBackpack;

function UpdateGrenades()
{
	local int CurrentGrenades;

	if(WMPlayerController(MyKFPC) == None)
	{
		return;
	}

	if(MyKFInvManager != none)
	{
		CurrentGrenades = MyKFInvManager.GrenadeCount;
	}

	//Update the icon the for grenade type.
	if(WMPlayerController(MyKFPC).CurrentPerk != none)
	{
		if( WMPlayerController(MyKFPC).bShouldUpdateGrenadeIcon )
		{
			SetString("backpackGrenadeType", "img://" $ MyKFPC.CurrentPerk.GetGrenadeImagePath());
			WMPlayerController(MyKFPC).bShouldUpdateGrenadeIcon = false;
		}
	}
	// Update the grenades count value
	if(CurrentGrenades != LastGrenades)
	{
		SetInt("backpackGrenades" , CurrentGrenades);
		LastGrenades = CurrentGrenades;
	}
}

defaultproperties
{
	Name="Default__WMGFxHUD_PlayerBackpack"
}
