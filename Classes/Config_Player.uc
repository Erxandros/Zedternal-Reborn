class Config_Player extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

struct SDamage
{
	var class<DamageType> DamageType;
	var float Factor;
};
struct SVampire
{
	var class<DamageType> DamageType;
	var int HealAmount;
};

var config bool Player_bDropAllWeaponsWhenDead;
var config int Player_Health;
var config int Player_Armor;
var config float Player_HealAmountFactor;
var config float Player_DamageTakenFactorWhileHoldingMelee;
var config int Player_Weight;
var config array<SDamage> Player_DamageGivenFactor;
var config array<SDamage> Player_DamageTakenFactor;
var config array<SVampire> Player_VampireEffect;

static function UpdateConfig()
{
	local SDamage DValue;

	if (default.MODEVERSION < 1)
	{
		default.Player_bDropAllWeaponsWhenDead = true;

		default.Player_Health = 100;
		default.Player_Armor = 100;
		default.Player_HealAmountFactor = 1.000000;
		default.Player_DamageTakenFactorWhileHoldingMelee = 0.900000;
		default.Player_Weight = 15;

		default.Player_DamageGivenFactor.Length = 6;
		default.Player_DamageGivenFactor[0].DamageType = class'KFGame.KFDT_Bludgeon';
		default.Player_DamageGivenFactor[0].Factor = 1.150000;
		default.Player_DamageGivenFactor[1].DamageType = class'KFGame.KFDT_Piercing';
		default.Player_DamageGivenFactor[1].Factor = 1.150000;
		default.Player_DamageGivenFactor[2].DamageType = class'KFGame.KFDT_Slashing';
		default.Player_DamageGivenFactor[2].Factor = 1.150000;
		default.Player_DamageGivenFactor[3].DamageType = class'KFGame.KFDT_Fire';
		default.Player_DamageGivenFactor[3].Factor = 1.100000;
		default.Player_DamageGivenFactor[4].DamageType = class'KFGameContent.KFDT_Freeze_FreezeThrower';
		default.Player_DamageGivenFactor[4].Factor = 1.150000;
		default.Player_DamageGivenFactor[5].DamageType = class'KFGame.KFDT_Toxic_MedicGrenade';
		default.Player_DamageGivenFactor[5].Factor = 0.800000;

		default.Player_DamageTakenFactor.Length = 5;
		default.Player_DamageTakenFactor[0].DamageType = class'KFGame.KFDT_Fire';
		default.Player_DamageTakenFactor[0].Factor = 0.900000;
		default.Player_DamageTakenFactor[1].DamageType = class'KFGameContent.KFDT_Explosive_HuskSuicide';
		default.Player_DamageTakenFactor[1].Factor = 0.750000;
		default.Player_DamageTakenFactor[2].DamageType = class'KFGameContent.KFDT_FleshpoundKing_ChestBeam';
		default.Player_DamageTakenFactor[2].Factor = 0.750000;
		default.Player_DamageTakenFactor[3].DamageType = class'KFGameContent.KFDT_Explosive_HansHEGrenade';
		default.Player_DamageTakenFactor[3].Factor = 0.750000;
		default.Player_DamageTakenFactor[4].DamageType = class'KFGameContent.KFDT_Explosive_PatMissile';
		default.Player_DamageTakenFactor[4].Factor = 0.750000;

		default.Player_VampireEffect.Length = 3;
		default.Player_VampireEffect[0].DamageType = class'KFGame.KFDT_Bludgeon';
		default.Player_VampireEffect[0].HealAmount = 3;
		default.Player_VampireEffect[1].DamageType = class'KFGame.KFDT_Piercing';
		default.Player_VampireEffect[1].HealAmount = 3;
		default.Player_VampireEffect[2].DamageType = class'KFGame.KFDT_Slashing';
		default.Player_VampireEffect[2].HealAmount = 3;
	}

	if (default.MODEVERSION < 2)
	{
		if (default.Player_DamageTakenFactor.Find('DamageType', class'KFGameContent.KFDT_EMP_MatriarchPlasmaCannon') == -1)
		{
			DValue.DamageType = class'KFGameContent.KFDT_EMP_MatriarchPlasmaCannon';
			DValue.Factor = 0.750000;
			default.Player_DamageTakenFactor.AddItem(DValue);
		}
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
}
