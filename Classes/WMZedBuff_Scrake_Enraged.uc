Class WMZedBuff_Scrake_Enraged extends WMZedBuff;

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedScrake(P) != none)
		KFPawn_ZedScrake(P).SetEnraged(true);
}

defaultproperties
{
	buffDescription="SCRAKES ARE ENRAGED"
	buffIcon=Texture2D'ZED_Scrake_UI.ZED-VS_Icons_Scrake-HeavyLunge'
}
