class WMGameReplicationInfo_AllWeapons extends WMGameReplicationInfo;

simulated function bool IsItemAllowed(STraderItem Item)
{
	return True;
}

defaultproperties
{
	Name="Default__WMGameReplicationInfo_AllWeapons"
}
