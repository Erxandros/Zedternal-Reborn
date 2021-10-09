class WMZedBuff_Hostility extends WMZedBuff;

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
	Damage=0.1f
	WeakAttack=0.3f
	HardAttack=0.6f
	SprintChance=0.3f

	BuffDescription="ZEDS ARE MORE AGGRESSIVE"
	BuffIcon=Texture2D'ZED_Husk_UI.ZED-VS_Icons_Husk-Explode'

	Name="Default__WMZedBuff_Hostility"
}
