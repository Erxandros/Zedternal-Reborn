class WMZedBuff extends Object;

var string BuffDescription;
var Texture2D BuffIcon;

//Set this variable to True in the default properties of your zed buff to read the BuffDescription as the localization key and not as raw text.
var bool bShouldLocalize;

static function ModifyZedHealthMod(out float HealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers);
static function ModifyZedHeadHealthMod(out float HeadHealthMod, KFPawn_Monster P, float GameDifficulty, byte NumLivingPlayers);
static function ModifyZedDamageMod(out float PerZedDamageMod, KFPawn_Monster P, float GameDifficulty);
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Localization functions
static function string GetBuffDescription()
{
	return GetBuffLocalization("BuffDescription");
}

static function string GetBuffLocalization(string KeyName)
{
	local array<string> Strings;
	ParseStringIntoArray(default.BuffDescription, Strings, ".", True);
	return Localize(Strings[1], KeyName, Strings[0]);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
	bShouldLocalize=False
	BuffDescription="Zeds are mutating..."
	BuffIcon=Texture2D'UI_Award_ZEDs.UI_Award_ZED_Kills'

	Name="Default__WMZedBuff"
}
