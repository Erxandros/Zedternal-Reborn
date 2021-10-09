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

	BuffDescription="SIRENS SCREAM MORE OFTEN"
	BuffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_SirenScreamRate'

	Name="Default__WMZedBuff_Siren_ScreamRate"
}
