Class WMZedBuff_Siren_ScreamRate extends WMZedBuff;

var float Damage;

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedSiren(P) != none)
	{
		if (KFAIController_ZedSiren(P.MyKFAIC) != none)
			KFAIController_ZedSiren(P.MyKFAIC).ScreamCooldown = 2.750000;
	}
}

defaultproperties
{
	buffDescription="SIRENS SCREAM MORE OFTEN"
	buffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_SirenScreamRate'
}
