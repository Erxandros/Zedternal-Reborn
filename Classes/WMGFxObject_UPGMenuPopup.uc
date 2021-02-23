class WMGFxObject_UPGMenuPopup extends GFxObject;

var WMUI_Menu Manager;

function Callback_ClosedPopup()
{
	ClosePopUp();
}

function ClosePopUp()
{
	ClearDelegates();
	Manager.UnloadCurrentPopup();
}

delegate LeftButtonPress();
delegate MiddleButtonPress();
delegate RightButtonPress();

function AssignLeftButtonDelegate(delegate<LeftButtonPress> LeftDelegate)
{
	LeftButtonPress = LeftDelegate;
}

function AssignMiddleButtonDelegate(delegate<MiddleButtonPress> MiddleDelegate)
{
	MiddleButtonPress = MiddleDelegate;
}

function AssignRightButtonDelegate(delegate<RightButtonPress> RightDelegate)
{
	RightButtonPress = RightDelegate;
}

function ClearDelegates()
{
	LeftButtonPress = None;
	MiddleButtonPress = None;
	RightButtonPress = None;
}

function Callback_ClickedLeftOption()
{
	if (LeftButtonPress != None)
		LeftButtonPress();

	ClosePopUp();
}

function Callback_ClickedMiddleOption()
{
	if (MiddleButtonPress != None)
		MiddleButtonPress();

	ClosePopUp();
}

function Callback_ClickedRightOption()
{
	if (RightButtonPress != None)
		RightButtonPress();

	ClosePopUp();
}

function UpdateDescritionText(string newDescription)
{
	SetString("descriptionText", newDescription);
}

function OnClosed()
{
	if (Manager.UPGMenuObject != None)
		Manager.SetExternalInterface(Manager.UPGMenuObject);
}

function InitializePopup(WMUI_Menu InManager)
{
	Manager = InManager;
}

defaultproperties
{
	Name="Default__WMGFxObject_UPGMenuPopup"
}
