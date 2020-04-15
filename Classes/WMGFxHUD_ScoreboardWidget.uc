class WMGFxHUD_ScoreboardWidget extends KFGFxHUD_ScoreboardWidget;

function UpdatePlayerData()
{
	local GFxObject DataProvider,TempData, PerkIconObject;
	local int i;
    local KFPlayerReplicationinfo KFPRI;
    local KFPlayerController KFPC;
    local int PlayerIndex;
	
    KFPC = KFPlayerController(GetPC());

    PlayerIndex=0;
    DataProvider = CreateArray();
	for(i = 0 ; i < CurrentPlayerList.length; i ++)
    {
        KFPRI = CurrentPlayerList[i];
        if(KFPRI.GetTeamNum() != 255 && KFPRI.bHasSpawnedIn)
        {
            TempData  = CreateObject("Object");

            TempData.SetString("playername", KFPRI.PlayerName);
            
            TempData.SetInt("dosh", KFPRI.Score);
            TempData.SetInt("assists", KFPRI.Assists);
            TempData.SetInt("kills", KFPRI.Kills);
            TempData.SetInt("ping", KFPRI.Ping * 4.f);
            TempData.SetInt("perkLevel", KFPRI.GetActivePerkLevel());
			TempData.SetInt("prestigeLevel", KFPRI.GetActivePerkPrestigeLevel());
            if( KFPRI.CurrentPerkClass != none )
            {
                TempData.SetString("perkName", KFPRI.CurrentPerkClass.default.PerkName);

				PerkIconObject = CreateObject("Object");
				PerkIconObject.SetString("perkIcon", "");
				PerkIconObject.SetString("prestigeIcon", "img://"$PathName(KFPRI.GetCurrentIconToDisplay()));

				TempData.SetObject("iconPath", PerkIconObject);
            }

			if( class'WorldInfo'.static.IsConsoleBuild( CONSOLE_Orbis ) )
			{
				TempData.SetString("avatar", "img://"$KFPC.GetPS4Avatar(KFPRI.PlayerName));
			}
			else
			{
				TempData.SetString("avatar", "img://"$KFPC.GetSteamAvatar(KFPRI.UniqueId));
			}
            if(KFPRI.PlayerHealth < 0)
            {
                TempData.SetFloat("health", 0);  
                TempData.SetFloat("healthPercent", 0);  
            }
            else
            {
                TempData.SetFloat("health", KFPRI.PlayerHealth);  
                TempData.SetFloat("healthPercent", ByteToFloat(KFPRI.PlayerHealthPercent) * 100);  
            }

            DataProvider.SetElementObject(PlayerIndex,TempData);
            PlayerIndex++;
        }
    }

    SetObject("playerData", DataProvider);
}

defaultproperties
{
   Name="Default__WMGFxHUD_ScoreboardWidget"
}
