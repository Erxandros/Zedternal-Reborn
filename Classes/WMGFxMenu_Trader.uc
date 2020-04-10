class WMGFxMenu_Trader extends KFGFxMenu_Trader;

var WMUI_Menu UPGMenu;
var bool bBlinkPerkButton;

function InitializeMenu( KFGFxMoviePlayer_Manager InManager )
{
	super.InitializeMenu(InManager);
	
	SetString("exitMenuString", "PERK MENU");
	SetString("backPromptString",Localize("KFGFxWidget_ButtonPrompt","CancelString","KFGame"));
	LocalizeText();
}

event OnClose()
{
	CreateUPGMenu();
	super.OnClose();
}

//function Callback_Close()
//{
	//super.Callback_Close();
//}

function CreateUPGMenu()
{
	UPGMenu = new class'ZedternalReborn.WMUI_Menu';
	UPGMenu.Owner = KFPawn_Human(MyKFPC.Pawn);
	UPGMenu.KFPC = MyKFPC;
	UPGMenu.KFPRI = KFPlayerReplicationInfo(MyKFPC.PlayerReplicationInfo);
	UPGMenu.SetTimingMode(TM_Real);
	UPGMenu.Init(LocalPLayer(MyKFPC.Player));
}

defaultproperties
{
   SubWidgetBindings(1)=(WidgetName="FilterContainer",WidgetClass=Class'ZedternalReborn.WMGFxTraderContainer_Filter')
   SubWidgetBindings(2)=(WidgetName="ShopContainer",WidgetClass=Class'ZedternalReborn.WMGFxTraderContainer_Store')
   SubWidgetBindings(5)=(WidgetName="ItemDetailsContainer",WidgetClass=Class'ZedternalReborn.WMGFxTraderContainer_ItemDetails')
   bBlinkPerkButton=false
   Name="Default__WMGFxMenu_Trader"
}
