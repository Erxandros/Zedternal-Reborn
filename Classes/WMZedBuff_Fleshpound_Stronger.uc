Class WMZedBuff_Fleshpound_Stronger extends WMZedBuff;

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedFleshpound(P) != none)
		KFPawn_ZedFleshpound(P).SetEnraged(true);
}

defaultproperties
{
	buffDescription="FLESHPOUNDS ARE ENRAGED"
	buffIcon=Texture2D'ZED_Fleshpound_UI.ZED-VS_Icons_Fleshpound-HeavyAttack'
}
