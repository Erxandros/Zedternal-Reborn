class WMZedBuff_Health_II extends WMZedBuff;

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
	Health=0.18f
	LargeZedHealth=0.135f
	HeadHealth=0.135f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Health_II"
	BuffIcon=Texture2D'ZED_Patriarch_UI.ZED-VS_Icons_Patriarch-Heal'

	Name="Default__WMZedBuff_Health_II"
}
