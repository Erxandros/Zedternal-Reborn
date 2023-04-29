class WMZedBuff_Health extends WMZedBuff;

var float Health, LargeZedHealth, HeadHealth;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (P.static.IsLargeZed() || P.static.IsABoss())
		HealthMod += default.LargeZedHealth;
	else
		HealthMod += default.Health;
}

static function ModifyZedHeadHealthMod(out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	HeadHealthMod += default.HeadHealth;
}

defaultproperties
{
	Health=0.125f
	LargeZedHealth=0.09f
	HeadHealth=0.1f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Health"
	BuffIcon=Texture2D'ZED_Patriarch_UI.ZED-VS_Icons_Patriarch-Heal'

	Name="Default__WMZedBuff_Health"
}
