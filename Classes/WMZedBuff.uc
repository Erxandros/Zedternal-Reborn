class WMZedBuff extends Info;

var string BuffDescription;
var Texture2D BuffIcon;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers);
static function ModifyZedHeadHealthMod(out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers);
static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty);
static function ModifyZedSoloDamageMod(out float SoloPlayDamageMod, KFPawn_Monster P, float GameDifficulty);
static function ModifyZedSpeedMod(out float SpeedMod, KFPawn_Monster P, float GameDifficulty);
static function ModifyZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty);
static function ModifyDamagedZedSprintChanceMod(out float SprintChanceMod, KFPawn_Monster P, float GameDifficulty);
static function ModifyZedDoshMod(out float DoshMod);
static function ModifyItemPickupMod(out float ItemPickupMod);
static function ModifyAmmoPickupMod(out float AmmoPickupMod);
static function ModifyWeakAttackChanceMod(out float WeakAttackChanceMod);
static function ModifyMediumAttackChanceMod(out float MediumAttackChanceMod);
static function ModifyHardAttackChanceMod(out float HardAttackChanceMod);
static function ModifySpawnRateMod(out float SpawnRateMod);
static function ModifyDamageResistanceMod(out float ResistanceMod, byte NumLivingPlayers);

static function KilledPawn(Pawn entity);

defaultproperties
{
	BuffDescription="Zeds are mutating..."
	BuffIcon=Texture2D'UI_Award_ZEDs.UI_Award_ZED_Kills'

	Name="Default__WMZedBuff"
}
