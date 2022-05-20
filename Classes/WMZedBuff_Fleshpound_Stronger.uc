class WMZedBuff_Fleshpound_Stronger extends WMZedBuff;

static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedFleshpound(P) != None)
		KFPawn_ZedFleshpound(P).SetEnraged(True);
}

defaultproperties
{
	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Fleshpound_Stronger"
	BuffIcon=Texture2D'ZED_Fleshpound_UI.ZED-VS_Icons_Fleshpound-HeavyAttack'

	Name="Default__WMZedBuff_Fleshpound_Stronger"
}
