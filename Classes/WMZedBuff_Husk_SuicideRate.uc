class WMZedBuff_Husk_SuicideRate extends WMZedBuff;

var float SuicideHealthRatio;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedHusk(P) != None)
	{
		if (KFAIController_ZedHusk(P.MyKFAIC) != None)
			KFAIController_ZedHusk(P.MyKFAIC).RequiredHealthPercentForSuicide += default.SuicideHealthRatio;
	}
}

defaultproperties
{
	SuicideHealthRatio=0.2f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Husk_SuicideRate"
	BuffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_HuskSuicideRate'

	Name="Default__WMZedBuff_Husk_SuicideRate"
}
