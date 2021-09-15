class Config_Player extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Bool Player_bDropAllWeaponsWhenDead;
var config S_Difficulty_Int Player_StartingWeaponAmount;
var config S_Difficulty_Int Player_StartingMaxHealth;
var config S_Difficulty_Int Player_StartingMaxArmor;
var config S_Difficulty_Int Player_StartingCarryWeight;
var config S_Difficulty_Float Player_HealAmountFactor;
var config S_Difficulty_Float Player_DamageTakenFactorWhileHoldingMelee;

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
		default.Player_bDropAllWeaponsWhenDead.Normal = True;
		default.Player_bDropAllWeaponsWhenDead.Hard = True;
		default.Player_bDropAllWeaponsWhenDead.Suicidal = True;
		default.Player_bDropAllWeaponsWhenDead.HoE = True;
		default.Player_bDropAllWeaponsWhenDead.Custom = True;

		default.Player_StartingWeaponAmount.Normal = 1;
		default.Player_StartingWeaponAmount.Hard = 1;
		default.Player_StartingWeaponAmount.Suicidal = 1;
		default.Player_StartingWeaponAmount.HoE = 1;
		default.Player_StartingWeaponAmount.Custom = 1;

		default.Player_StartingMaxHealth.Normal = 100;
		default.Player_StartingMaxHealth.Hard = 100;
		default.Player_StartingMaxHealth.Suicidal = 100;
		default.Player_StartingMaxHealth.HoE = 100;
		default.Player_StartingMaxHealth.Custom = 100;

		default.Player_StartingMaxArmor.Normal = 100;
		default.Player_StartingMaxArmor.Hard = 100;
		default.Player_StartingMaxArmor.Suicidal = 100;
		default.Player_StartingMaxArmor.HoE = 100;
		default.Player_StartingMaxArmor.Custom = 100;

		default.Player_StartingCarryWeight.Normal = 15;
		default.Player_StartingCarryWeight.Hard = 15;
		default.Player_StartingCarryWeight.Suicidal = 15;
		default.Player_StartingCarryWeight.HoE = 15;
		default.Player_StartingCarryWeight.Custom = 15;

		default.Player_HealAmountFactor.Normal = 1.0f;
		default.Player_HealAmountFactor.Hard = 1.0f;
		default.Player_HealAmountFactor.Suicidal = 1.0f;
		default.Player_HealAmountFactor.HoE = 1.0f;
		default.Player_HealAmountFactor.Custom = 1.0f;

		default.Player_DamageTakenFactorWhileHoldingMelee.Normal = 0.9f;
		default.Player_DamageTakenFactorWhileHoldingMelee.Hard = 0.9f;
		default.Player_DamageTakenFactorWhileHoldingMelee.Suicidal = 0.9f;
		default.Player_DamageTakenFactorWhileHoldingMelee.HoE = 0.9f;
		default.Player_DamageTakenFactorWhileHoldingMelee.Custom = 0.9f;

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

static function bool GetDropAllWeaponsWhenDead(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_bDropAllWeaponsWhenDead.Normal;
		case 1 : return default.Player_bDropAllWeaponsWhenDead.Hard;
		case 2 : return default.Player_bDropAllWeaponsWhenDead.Suicidal;
		case 3 : return default.Player_bDropAllWeaponsWhenDead.HoE;
		default: return default.Player_bDropAllWeaponsWhenDead.Custom;
	}
}

static function int GetStartingWeaponAmount(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_StartingWeaponAmount.Normal;
		case 1 : return default.Player_StartingWeaponAmount.Hard;
		case 2 : return default.Player_StartingWeaponAmount.Suicidal;
		case 3 : return default.Player_StartingWeaponAmount.HoE;
		default: return default.Player_StartingWeaponAmount.Custom;
	}
}

static function int GetStartingMaxHealth(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_StartingMaxHealth.Normal;
		case 1 : return default.Player_StartingMaxHealth.Hard;
		case 2 : return default.Player_StartingMaxHealth.Suicidal;
		case 3 : return default.Player_StartingMaxHealth.HoE;
		default: return default.Player_StartingMaxHealth.Custom;
	}
}

static function int GetStartingMaxArmor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_StartingMaxArmor.Normal;
		case 1 : return default.Player_StartingMaxArmor.Hard;
		case 2 : return default.Player_StartingMaxArmor.Suicidal;
		case 3 : return default.Player_StartingMaxArmor.HoE;
		default: return default.Player_StartingMaxArmor.Custom;
	}
}

static function int GetStartingCarryWeight(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_StartingCarryWeight.Normal;
		case 1 : return default.Player_StartingCarryWeight.Hard;
		case 2 : return default.Player_StartingCarryWeight.Suicidal;
		case 3 : return default.Player_StartingCarryWeight.HoE;
		default: return default.Player_StartingCarryWeight.Custom;
	}
}

static function float GetHealAmountFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_HealAmountFactor.Normal;
		case 1 : return default.Player_HealAmountFactor.Hard;
		case 2 : return default.Player_HealAmountFactor.Suicidal;
		case 3 : return default.Player_HealAmountFactor.HoE;
		default: return default.Player_HealAmountFactor.Custom;
	}
}

static function float GetDamageTakenFactorWhileHoldingMelee(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_DamageTakenFactorWhileHoldingMelee.Normal;
		case 1 : return default.Player_DamageTakenFactorWhileHoldingMelee.Hard;
		case 2 : return default.Player_DamageTakenFactorWhileHoldingMelee.Suicidal;
		case 3 : return default.Player_DamageTakenFactorWhileHoldingMelee.HoE;
		default: return default.Player_DamageTakenFactorWhileHoldingMelee.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Player"
}
