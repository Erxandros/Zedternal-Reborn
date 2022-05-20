class WMZedBuff_Clot_Stronger extends WMZedBuff;

var float Health, Damage;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedClot(P) != None)
		HealthMod += default.Health;
}

static function ModifyZedHeadHealthMod(out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (KFPawn_ZedClot(P) != None)
		HeadHealthMod += default.Health;
}

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (KFPawn_ZedClot(P) != None)
		PerZedDamageMod += default.Damage;
}

defaultproperties
{
	Health=0.24f
	Damage=0.15f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Clot_Stronger"
	BuffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_ClotHealth'

	Name="Default__WMZedBuff_Clot_Stronger"
}
