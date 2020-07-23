Class WMZedBuff_Beefcake extends WMZedBuff;

var float Health, HeadHealth, Size, Damage, Speed, Prob;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (!P.bLargeZed && P.IntendedBodyScale == 1 && FRand() < default.Prob)
	{
		HealthMod += default.Health;
		P.IntendedBodyScale = default.Size;
	}
}

static function ModifyZedHeadHealthMod(out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers)
{
	if (P.IntendedBodyScale == default.Size)
		HeadHealthMod += default.HeadHealth;
}

static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty)
{
	if (P.IntendedBodyScale == default.Size)
		SpeedMod += default.Speed;
}

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	if (P.IntendedBodyScale == default.Size)
		PerZedDamageMod += default.Damage;
}

defaultproperties
{
	buffDescription="SOME ZEDS ARE STRONGER THAN USUAL"
	buffIcon=Texture2D'ZedternalReborn_Resource.zedBuffs.UI_ZedBuff_Beefcake'
	Health=0.750000
	HeadHealth=0.750000
	Size=1.178000
	Speed=0.100000
	Damage=0.100000
	Prob=0.090000
}
