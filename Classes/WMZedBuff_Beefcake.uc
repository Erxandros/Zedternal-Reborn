class WMZedBuff_Beefcake extends WMZedBuff;

var float Health, HeadHealth, Size, Damage, Speed, Prob;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (!P.bLargeZed && (FRand() <= default.Prob || P.bAmbientCreature))
	{
		HealthMod += default.Health;
		P.IntendedBodyScale += default.Size;
		P.bAmbientCreature = True;
	}
}

static function ModifyZedHeadHealthMod(out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (P.bAmbientCreature)
		HeadHealthMod += default.HeadHealth;
}

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (P.bAmbientCreature)
		SpeedMod += default.Speed;
}

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (P.bAmbientCreature)
		PerZedDamageMod += default.Damage;
}

defaultproperties
{
	Health=0.75f
	HeadHealth=0.75f
	Size=0.178f
	Speed=0.1f
	Damage=0.1f
	Prob=0.1f

	bShouldLocalize=True
	BuffDescription="ZedternalReborn.WMZedBuff_Beefcake"
	BuffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_Beefcake'

	Name="Default__WMZedBuff_Beefcake"
}
