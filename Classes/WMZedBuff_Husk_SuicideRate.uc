Class WMZedBuff_Husk_SuicideRate extends WMZedBuff;

var float SuicideHealthRatio;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedHusk(P) != none)
	{
		if (KFAIController_ZedHusk(P.MyKFAIC) != none)
			KFAIController_ZedHusk(P.MyKFAIC).RequiredHealthPercentForSuicide = default.SuicideHealthRatio;
	}
}

defaultproperties
{
	buffDescription="HUSKS COMMIT SUICIDE MORE OFTEN"
	buffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_HuskSuicideRate'
	SuicideHealthRatio=0.350000
}
