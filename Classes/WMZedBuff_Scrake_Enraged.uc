class WMZedBuff_Scrake_Enraged extends WMZedBuff;

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedScrake(P) != None)
		KFPawn_ZedScrake(P).SetEnraged(True);
}

defaultproperties
{
	BuffDescription="SCRAKES ARE ENRAGED"
	BuffIcon=Texture2D'ZED_Scrake_UI.ZED-VS_Icons_Scrake-HeavyLunge'

	Name="Default__WMZedBuff_Scrake_Enraged"
}
