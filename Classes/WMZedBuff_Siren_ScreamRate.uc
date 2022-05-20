class WMZedBuff_Siren_ScreamRate extends WMZedBuff;

var float ScreamReduce;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedSiren(P) != None)
	{
		if (KFAIController_ZedSiren(P.MyKFAIC) != None)
			KFAIController_ZedSiren(P.MyKFAIC).ScreamCooldown -= default.ScreamReduce;
	}
}

defaultproperties
{
	ScreamReduce=1.25f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Siren_ScreamRate"
	BuffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_SirenScreamRate'

	Name="Default__WMZedBuff_Siren_ScreamRate"
}
