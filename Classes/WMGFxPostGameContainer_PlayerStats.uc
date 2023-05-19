class WMGFxPostGameContainer_PlayerStats extends KFGFxPostGameContainer_PlayerStats;

function GFxObject MakeZedKillObject(class<KFPawn_Monster> MonsterClass, string SecondaryText)
{
	local GFxObject TempObject;
	local string MonsterName;

	if (MonsterClass != None)
		MonsterName = MonsterClass.static.GetLocalizedName();
	else
		MonsterName = "NULL";

	TempObject = CreateObject("Object");

	TempObject.SetString("typeString", "ZED_KILL");
	TempObject.SetString("title", MonsterName);
	TempObject.SetString("value", SecondaryText);
	TempObject.SetBool("bSkipAnim", True);
	ItemCount++;

	return TempObject;
}

defaultproperties
{
	Name="Default__WMGFxPostGameContainer_PlayerStats"
}
