class WMGFxMenu_StartGame extends KFGFxMenu_StartGame
	dependson(TWOnlineLobby);

defaultproperties
{
   SubWidgetBindings(3)=(WidgetName="OverviewContainer",WidgetClass=Class'ZedternalReborn.WMGFxStartContainer_InGameOverview')
   Name="Default__WMGFxMenu_StartGame"
}
