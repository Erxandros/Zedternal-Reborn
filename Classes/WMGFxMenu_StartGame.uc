class WMGFxMenu_StartGame extends KFGFxMenu_StartGame
	dependson(TWOnlineLobby);

function Callback_RequestPageChange()
{
	local WMGameReplicationInfo WMGRI;
	WMGRI = WMGameReplicationInfo(GetPC().WorldInfo.GRI);
	if (WMGRI != None)
	{
		if (WMGRI.LobbyCurrentPage < WMGRI.LobbyMaxPage)
			++WMGRI.LobbyCurrentPage;
		else
			WMGRI.LobbyCurrentPage = 1;
	}
}

defaultproperties
{
   SubWidgetBindings(3)=(WidgetName="OverviewContainer",WidgetClass=Class'ZedternalReborn.WMGFxStartContainer_InGameOverview')
   Name="Default__WMGFxMenu_StartGame"
}
