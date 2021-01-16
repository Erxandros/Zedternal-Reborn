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

function UpdateArmor()
{
	local WMPawn_Human WMPH;

	if (MyPC.Pawn != None)
	{
		WMPH = WMPawn_Human(MyPC.Pawn);
	}
	if (WMPH == None)
	{
		LastArmor = 0;
		SetInt("playerArmor", LastArmor);
	}
	else if (LastArmor != WMPH.ZedternalArmor)
	{
		SetInt("playerArmor", WMPH.ZedternalArmor);
		LastArmor = WMPH.ZedternalArmor;
	}
}

defaultproperties
{
	Name="Default__WMGFxHUD_PlayerStatus"
}
