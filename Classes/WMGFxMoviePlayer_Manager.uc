class WMGFxMoviePlayer_Manager extends KFGFxMoviePlayer_Manager;

function bool ToggleMenus()
{
	`log(`location@`showvar(bMenusOpen)@`showvar(HUD.bShowHUD)@`showvar(bCanCloseMenu)@`showvar(bPostGameState)@`showvar(CurrentMenuIndex));
	if (!bMenusOpen || HUD.bShowHUD)
	{
		ManagerObject.SetBool("bOpenedInGame", True);
		if (CurrentMenuIndex >= MenuSWFPaths.length)
		{
			LaunchMenus();
		}
		else
		{
			OpenMenu(UI_Start);
			UpdateMenuBar();
			if (PartyWidget != None)
			{
				PartyWidget.UpdateReadyButtonVisibility();
			}
		}

		// set the timer to mark when the menu is completely open and we can close the menu down
		bCanCloseMenu = False;
		`TimerHelper.SetTimer(0.5f, False, NameOf(AllowCloseMenu), self);
		`TimerHelper.SetTimer(0.15f, False, NameOf(PlayOpeningSound), self);//Delay due to pause
	}
	else if(bCanCloseMenu) //check to make sure
	{
		if(GetPC().WorldInfo.GRI.bMatchIsOver && !bAfterLobby)
		{
			return False; // we are still in the lobby and the game has not proceeded to a point where we can use the esc key
		}

		if (CurrentMenu != TraderMenu)
		{
			PlaySoundFromTheme('MAINMENU_CLOSE', 'UI');
		}

		CloseMenus();
	}
	else if(bPostGameState)
	{
		if(CurrentMenu == PostGameMenu)
		{
			ManagerObject.SetBool("bOpenedInGame", True);
			bMenusOpen = False;
			OpenMenu(UI_Start);
			SetWidgetsVisible(True);
		}
		else
		{
			ManagerObject.SetBool("bOpenedInGame", False);
			OpenMenu(UI_PostGame);
			SetWidgetsVisible(False);
		}
	}

	return False;
}

defaultproperties
{
	WidgetPaths.Remove("../UI_Widgets/PartyWidget_SWF.swf")
	WidgetPaths.Add("../ZedternalReborn_Menus/ZedternalLobby/LobbyGUI.swf")
	InGamePartyWidgetClass=Class'ZedternalReborn.WMGFxWidget_PartyInGame'
	WidgetBindings(10)=(WidgetName="startMenu",WidgetClass=Class'ZedternalReborn.WMGFxMenu_StartGame')
	WidgetBindings(21)=(WidgetName="traderMenu",WidgetClass=Class'ZedternalReborn.WMGFxMenu_Trader')
	WidgetBindings(24)=(WidgetName="MenuBarWidget",WidgetClass=Class'ZedternalReborn.WMGFxWidget_MenuBar')

	Name="Default__WMGFxMoviePlayer_Manager"
}
