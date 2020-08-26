Class WMUI_Menu extends GFxMoviePlayer;

var GFxObject ManagerObject;
var WMUI_UPGMenu UPGMenu;
var KFPawn_Human Owner;
var KFPlayerController KFPC;
var KFPlayerReplicationInfo KFPRI;
var bool bUsingGamepad;

function Init(optional LocalPlayer LocPlay)
{
	Super.Init(LocPlay);

	ManagerObject.SetBool("backgroundVisible", False);
	ManagerObject.SetBool("IISMovieVisible", False);

	LoadMenu("../ZedternalReborn_Menus/ZedternalUpgrade/UpgradeMenu.swf", True);

	// controller?
	bUsingGamepad = class'WorldInfo'.static.IsConsoleBuild();
}

/** Tells actionscript which .swf to open up */
function LoadMenu(string Path, bool bShowWidgets)
{
	ManagerObject.ActionScriptVoid("loadCurrentMenu");
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch (WidgetName)
	{
	case 'root1':
		if (ManagerObject == None)
		{
			ManagerObject = Widget;
			// Let the menuManager know if we are on console.
			ManagerObject.SetBool("bConsoleBuild", class'WorldInfo'.static.IsConsoleBuild());
		}
		break;
	case 'inventoryMenu':
		if (UPGMenu == None)
		{
			UPGMenu = WMUI_UPGMenu(Widget);
			UPGMenu.Owner = Owner;
			UPGMenu.KFPC = KFPC;
			UPGMenu.KFPRI = KFPRI;
			UPGMenu.InitializeMenu(Self);
		}
		SetWidgetPathBinding(Widget, WidgetPath);
		SetExternalInterface(Widget);
		break;
	}
	return True;
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (UPGMenu != None)
	{
		CheckIfUsingGamepad();
	}

	// Handle closing out of currently active menu
	if (InputEvent == EInputEvent.IE_Pressed && (ButtonName == 'Escape' || ButtonName == 'XboxTypeS_Start'))
	{
		CloseMenu();
		return True;
	}
	return False;
}

// Checks if our form of input has changed
function CheckIfUsingGamepad()
{
	local bool bGamepad;

	bGamepad = GetUsingGamepad();
	if (bUsingGamepad != bGamepad)
		OnInputTypeChanged(bGamepad);
}

function OnInputTypeChanged(bool bGamePad)
{
	ManagerObject.SetBool("bUsingGamepad", bGamepad);
	bUsingGamepad = bGamepad;
}

/** Return whether the player input says we are currently using the gamepad */
function bool GetUsingGamepad()
{
	local PlayerController PC;
	PC = GetPC();

	if (class'WorldInfo'.static.IsConsoleBuild())
	{
		return True;
	}

	if (PC == None || PC.PlayerInput == None)
	{
		return False;
	}
	// Always using the gamepad if we are on console.
	return PC.PlayerInput.bUsingGamepad;
}

/** Called when the movie player is closed */
event OnClose()
{
}

final function CloseMenu(optional bool bExternal)
{
	SetMenuVisibility(False);

	WMPlayerController(GetPC()).bUpgradeMenuOpen = False;

	if (GetPC().PlayerInput != None)
		GetPC().PlayerInput.ResetInput();

	GetPC().SetTimer(0.1f, False, 'FinishedAnim', Self);
}

function SetMenuVisibility(bool bVisible)
{
	ManagerObject.ActionScriptVoid("setMenuVisibility");
}

function FinishedAnim()
{
	Close();
}

function UpdateDisplay()
{
	if (UPGMenu != None)
		UPGMenu.Refresh();
}

defaultproperties
{
	MovieInfo=SwfMovie'UI_Managers.LoaderManager_SWF'
	bAutoPlay=True
	bCaptureInput=True
	SoundThemes(0)=(ThemeName="SoundTheme_Crate",Theme=UISoundTheme'SoundsShared_UI.SoundTheme_Crate')
	SoundThemes(1)=(ThemeName="ButtonSoundTheme",Theme=UISoundTheme'SoundsShared_UI.SoundTheme_Buttons')
	SoundThemes(2)=(ThemeName="AAR",Theme=UISoundTheme'SoundsShared_UI.SoundTheme_AAR')
	Priority=10
	WidgetBindings(0)=(WidgetName="root1",WidgetClass=Class'GFxUI.GFxObject')
	WidgetBindings(1)=(WidgetName="InventoryMenu",WidgetClass=Class'ZedternalReborn.WMUI_UPGMenu')
	Name="Default__WMUI_Menu"
}
