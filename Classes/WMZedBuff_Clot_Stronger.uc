Class WMZedBuff_Clot_Stronger extends WMZedBuff;

var float Health, Damage;

static function ModifyZedHealthMod( out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedClot(P) != none)
		HealthMod += default.Health;
}
static function ModifyZedHeadHealthMod( out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedClot(P) != none)
		HeadHealthMod += default.Health;
}
static function ModifyZedDamageMod( out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot(P) != none)
		PerZedDamageMod += default.Damage;
}



defaultproperties
{
	Health=0.240000
	Damage=0.150000
	buffDescription="CLOTS ARE STRONGER"
	buffIcon=Texture2D'Zedternal_Resource.zedBuffs.UI_ZedBuff_ClotHealth'
}