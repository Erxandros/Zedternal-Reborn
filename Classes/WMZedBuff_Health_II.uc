Class WMZedBuff_Health_II extends WMZedBuff;

var float Health, LargeZedHealth, HeadHealth;

static function ModifyZedHealthMod( out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (P.bLargeZed)
		HealthMod += default.LargeZedHealth;
	else
		HealthMod += default.Health;
}
static function ModifyZedHeadHealthMod( out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	HeadHealthMod += default.HeadHealth;
}


defaultproperties
{
	buffDescription="ZEDS HAVE MORE HEALTH"
	buffIcon=Texture2D'ZED_Patriarch_UI.ZED-VS_Icons_Patriarch-Heal'
	Health = 0.180000;
	LargeZedHealth = 0.135000;
	HeadHealth = 0.135000;
}