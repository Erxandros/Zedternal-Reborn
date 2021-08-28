class Config_Player extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config bool Player_bDropAllWeaponsWhenDead;
var config int Player_StartingWeaponAmount;
var config int Player_StartingMaxHealth;
var config int Player_StartingMaxArmor;
var config int Player_StartingCarryWeight;
var config float Player_HealAmountFactor;
var config float Player_DamageTakenFactorWhileHoldingMelee;

struct SDamage
{
	var class<DamageType> DamageType;
	var float Factor;
};
var config array<SDamage> Player_DamageGivenFactor;
var config array<SDamage> Player_DamageTakenFactor;

struct SVampire
{
	var class<DamageType> DamageType;
	var int HealAmount;
};
var config array<SVampire> Player_VampireEffect;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Player_bDropAllWeaponsWhenDead = True;

		default.Player_StartingWeaponAmount = 1;
		default.Player_StartingMaxHealth = 100;
		default.Player_StartingMaxArmor = 100;
		default.Player_StartingCarryWeight = 15;
		default.Player_HealAmountFactor = 1.0f;
		default.Player_DamageTakenFactorWhileHoldingMelee = 0.9f;

		default.Player_DamageGivenFactor.Length = 6;
		default.Player_DamageGivenFactor[0].DamageType = class'KFGame.KFDT_Bludgeon';
		default.Player_DamageGivenFactor[0].Factor = 1.15f;
		default.Player_DamageGivenFactor[1].DamageType = class'KFGame.KFDT_Piercing';
		default.Player_DamageGivenFactor[1].Factor = 1.15f;
		default.Player_DamageGivenFactor[2].DamageType = class'KFGame.KFDT_Slashing';
		default.Player_DamageGivenFactor[2].Factor = 1.15f;
		default.Player_DamageGivenFactor[3].DamageType = class'KFGame.KFDT_Fire';
		default.Player_DamageGivenFactor[3].Factor = 1.1f;
		default.Player_DamageGivenFactor[4].DamageType = class'KFGameContent.KFDT_Freeze_FreezeThrower';
		default.Player_DamageGivenFactor[4].Factor = 1.15f;
		default.Player_DamageGivenFactor[5].DamageType = class'KFGame.KFDT_Toxic_MedicGrenade';
		default.Player_DamageGivenFactor[5].Factor = 0.8f;

		default.Player_DamageTakenFactor.Length = 6;
		default.Player_DamageTakenFactor[0].DamageType = class'KFGame.KFDT_Fire';
		default.Player_DamageTakenFactor[0].Factor = 0.9f;
		default.Player_DamageTakenFactor[1].DamageType = class'KFGameContent.KFDT_Explosive_HuskSuicide';
		default.Player_DamageTakenFactor[1].Factor = 0.75f;
		default.Player_DamageTakenFactor[2].DamageType = class'KFGameContent.KFDT_FleshpoundKing_ChestBeam';
		default.Player_DamageTakenFactor[2].Factor = 0.75f;
		default.Player_DamageTakenFactor[3].DamageType = class'KFGameContent.KFDT_Explosive_HansHEGrenade';
		default.Player_DamageTakenFactor[3].Factor = 0.75f;
		default.Player_DamageTakenFactor[4].DamageType = class'KFGameContent.KFDT_Explosive_PatMissile';
		default.Player_DamageTakenFactor[4].Factor = 0.75f;
		default.Player_DamageTakenFactor[5].DamageType = class'KFGameContent.KFDT_EMP_MatriarchPlasmaCannon';
		default.Player_DamageTakenFactor[5].Factor = 0.75f;

		default.Player_VampireEffect.Length = 3;
		default.Player_VampireEffect[0].DamageType = class'KFGame.KFDT_Bludgeon';
		default.Player_VampireEffect[0].HealAmount = 3;
		default.Player_VampireEffect[1].DamageType = class'KFGame.KFDT_Piercing';
		default.Player_VampireEffect[1].HealAmount = 3;
		default.Player_VampireEffect[2].DamageType = class'KFGame.KFDT_Slashing';
		default.Player_VampireEffect[2].HealAmount = 3;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_Player"
}
