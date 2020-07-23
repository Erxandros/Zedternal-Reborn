Class WMZedBuff_Hostility extends WMZedBuff;

var float Damage, WeakAttack, HardAttack, SprintChance;

static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty)
{
	PerZedDamageMod += default.Damage;
}

static function ModifyWeakAttackChanceMod(out float WeakAttackChanceMod)
{
	WeakAttackChanceMod -= default.WeakAttack;
}

static function ModifyHardAttackChanceMod(out float HardAttackChanceMod)
{
	HardAttackChanceMod += default.HardAttack;
}

static function ModifyDamagedZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty)
{
	SprintChanceMod += default.SprintChance;
}

defaultproperties
{
	buffDescription="ZEDS ARE MORE AGGRESSIVE"
	buffIcon=Texture2D'ZED_Husk_UI.ZED-VS_Icons_Husk-Explode'
	Damage = 0.100000;
	WeakAttack = 0.300000;
	HardAttack = 0.600000;
	SprintChance = 0.300000;
}
