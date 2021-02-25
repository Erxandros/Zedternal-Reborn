Class WMUI_Menu extends GFxMoviePlayer;

var GFxObject ManagerObject;
var WMUI_UPGMenu UPGMenuObject;
var WMPawn_Human Owner;
var WMPlayerController WMPC;
var WMPlayerReplicationInfo WMPRI;
var bool bUsingGamepad;

// Pop-up support
var WMGFxObject_UPGMenuPopup CurrentPopup;
var name SoundThemeName;

delegate PendingRightButtonDelegate();
delegate PendingMiddleButtonDelegate();
delegate PendingLeftButtonDelegate();

function Init(optional LocalPlayer LocPlay)
{
	Super.Init(LocPlay);

	ManagerObject.SetBool("backgroundVisible", False);
	ManagerObject.SetBool("IISMovieVisible", False);

	LoadMenu("../ZedternalReborn_Menus/ZedternalUpgrade/UpgradeMenu.swf", True);

	// controller?
	bUsingGamepad = class'WorldInfo'.static.IsConsoleBuild();
}

// Tells actionscript which .swf to open up
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
				// Let the menu manager know if we are on console.
				ManagerObject.SetBool("bConsoleBuild", class'WorldInfo'.static.IsConsoleBuild());
			}
			break;

		case 'InventoryMenu':
			InitializeUPGMenu(WidgetPath, WMUI_UPGMenu(Widget));
			break;

		case 'ConfirmationPopup':
			InitializeUPGMenuPopup(WidgetPath, WMGFxObject_UPGMenuPopup(Widget));
			break;
	}

	return True;
}

function InitializeUPGMenu(name WidgetPath, WMUI_UPGMenu Widget)
{
	UPGMenuObject = Widget;

	if (UPGMenuObject != None)
	{
		SetWidgetPathBinding(Widget, WidgetPath);
		SetExternalInterface(Widget);
		UPGMenuObject.Owner = Owner;
		UPGMenuObject.WMPC = WMPC;
		UPGMenuObject.WMPRI = WMPRI;
		UPGMenuObject.InitializeMenu(self);
	}
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if (UPGMenuObject != None)
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

// Return whether the player input says we are currently using the gamepad
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

// Called when the movie player is closed
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
	if (UPGMenuObject != None)
		UPGMenuObject.Refresh();
}

// Initialize confirmation pop-up
function InitializeUPGMenuPopup(name WidgetPath, WMGFxObject_UPGMenuPopup Widget)
{
	CurrentPopup = Widget;

	if (CurrentPopup != None)
	{
		SetWidgetPathBinding(Widget, WidgetPath);
		SetExternalInterface(Widget);
		CurrentPopup.InitializePopup(self);
		CurrentPopup.AssignLeftButtonDelegate(PendingLeftButtonDelegate);
		CurrentPopup.AssignMiddleButtonDelegate(PendingMiddleButtonDelegate);
		CurrentPopup.AssignRightButtonDelegate(PendingRightButtonDelegate);

		PendingLeftButtonDelegate = None;
		PendingMiddleButtonDelegate = None;
		PendingRightButtonDelegate = None;
	}
}

// Open the confirmation pop-up and set the response delegates to its buttons
function OpenUPGMenuPopup(string TitleString, string DescriptionString, optional string LeftButtonString, optional string RightButtonString,
	optional delegate<PendingLeftButtonDelegate> LeftButtonDelegate, optional delegate<PendingRightButtonDelegate> RightButtonDelegate,
	optional string MiddleButtonString, optional delegate<PendingMiddleButtonDelegate> MiddleButtonDelegate,
	optional name OverridingSoundEffect)
{
	UnloadCurrentPopup();

	LoadPopup("../UI_PopUps/ConfirmationPopup_SWF.swf", TitleString, DescriptionString, LeftButtonString, RightButtonString, MiddleButtonString);

	bBlurLesserMovies = True;

	PendingLeftButtonDelegate = LeftButtonDelegate;
	PendingMiddleButtonDelegate = MiddleButtonDelegate;
	PendingRightButtonDelegate = RightButtonDelegate;

	// Play Alert Sound
	if (OverridingSoundEffect == '')
		PlaySoundFromTheme('Alert_Popup', SoundThemeName);
	else
		PlaySoundFromTheme(OverridingSoundEffect, SoundThemeName);
}

// Tell actionscript to load the pop-up
function LoadPopup(string Path, optional string TitleString, optional string DescriptionString,
	optional string LeftButtonString, optional string RightButtonString, optional string MiddleButtonString)
{
	ManagerObject.ActionScriptVoid("loadCurrentPopup");
	ManagerObject.ActionScriptVoid("currentFocus");
}

// Tell actionscript to remove this pop-up
function UnloadCurrentPopup()
{
	ManagerObject.ActionScriptVoid("unloadCurrentPopup");

	if (CurrentPopup != None)
	{
		CurrentPopup.OnClosed();
		CurrentPopup = None;
		bBlurLesserMovies = False;
	}
}

defaultproperties
{
	MovieInfo=SwfMovie'UI_Managers.LoaderManager_SWF'
	bAutoPlay=True
	bCaptureInput=True
	SoundThemeName=ButtonSoundTheme
	SoundThemes(0)=(ThemeName="SoundTheme_Crate",Theme=UISoundTheme'SoundsShared_UI.SoundTheme_Crate')
	SoundThemes(1)=(ThemeName="ButtonSoundTheme",Theme=UISoundTheme'SoundsShared_UI.SoundTheme_Buttons')
	SoundThemes(2)=(ThemeName="AAR",Theme=UISoundTheme'SoundsShared_UI.SoundTheme_AAR')
	Priority=10
	WidgetBindings(0)=(WidgetName="root1",WidgetClass=Class'GFxUI.GFxObject')
	WidgetBindings(1)=(WidgetName="InventoryMenu",WidgetClass=Class'ZedternalReborn.WMUI_UPGMenu')
	WidgetBindings(2)=(WidgetName="ConfirmationPopup",WidgetClass=Class'ZedternalReborn.WMGFxObject_UPGMenuPopup')
	Name="Default__WMUI_Menu"
}
