class Config_Player extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Bool Player_bDropAllWeaponsWhenDead;
var config S_Difficulty_Int Player_StartingWeaponAmount;
var config S_Difficulty_Int Player_StartingMaxHealth;
var config S_Difficulty_Int Player_StartingMaxArmor;
var config S_Difficulty_Int Player_StartingCarryWeight;
var config S_Difficulty_Int Player_StartingMaxGrenadeCount;
var config S_Difficulty_Float Player_HealAmountMultiplier;
var config S_Difficulty_Float Player_DamageTakenMultiplierWhileHoldingMelee;

struct S_Damage
{
	var string DamageType;
	var float Multiplier;
};
var config array<S_Damage> Player_DamageGiven;
var config array<S_Damage> Player_DamageTaken;

struct S_Vampire
{
	var string DamageType;
	var int HealAmount;
};
var config array<S_Vampire> Player_VampireEffect;

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

		default.Player_HealAmountMultiplier.Normal = 1.0f;
		default.Player_HealAmountMultiplier.Hard = 1.0f;
		default.Player_HealAmountMultiplier.Suicidal = 1.0f;
		default.Player_HealAmountMultiplier.HoE = 1.0f;
		default.Player_HealAmountMultiplier.Custom = 1.0f;

		default.Player_DamageTakenMultiplierWhileHoldingMelee.Normal = 0.9f;
		default.Player_DamageTakenMultiplierWhileHoldingMelee.Hard = 0.9f;
		default.Player_DamageTakenMultiplierWhileHoldingMelee.Suicidal = 0.9f;
		default.Player_DamageTakenMultiplierWhileHoldingMelee.HoE = 0.9f;
		default.Player_DamageTakenMultiplierWhileHoldingMelee.Custom = 0.9f;

		default.Player_DamageGiven.Length = 6;
		default.Player_DamageGiven[0].DamageType = "KFGame.KFDT_Bludgeon";
		default.Player_DamageGiven[0].Multiplier = 1.15f;
		default.Player_DamageGiven[1].DamageType = "KFGame.KFDT_Piercing";
		default.Player_DamageGiven[1].Multiplier = 1.15f;
		default.Player_DamageGiven[2].DamageType = "KFGame.KFDT_Slashing";
		default.Player_DamageGiven[2].Multiplier = 1.15f;
		default.Player_DamageGiven[3].DamageType = "KFGame.KFDT_Fire";
		default.Player_DamageGiven[3].Multiplier = 1.1f;
		default.Player_DamageGiven[4].DamageType = "KFGameContent.KFDT_Freeze_FreezeThrower";
		default.Player_DamageGiven[4].Multiplier = 1.15f;
		default.Player_DamageGiven[5].DamageType = "KFGame.KFDT_Toxic_MedicGrenade";
		default.Player_DamageGiven[5].Multiplier = 0.8f;

		default.Player_DamageTaken.Length = 6;
		default.Player_DamageTaken[0].DamageType = "KFGame.KFDT_Fire";
		default.Player_DamageTaken[0].Multiplier = 0.9f;
		default.Player_DamageTaken[1].DamageType = "KFGameContent.KFDT_Explosive_HuskSuicide";
		default.Player_DamageTaken[1].Multiplier = 0.75f;
		default.Player_DamageTaken[2].DamageType = "KFGameContent.KFDT_FleshpoundKing_ChestBeam";
		default.Player_DamageTaken[2].Multiplier = 0.75f;
		default.Player_DamageTaken[3].DamageType = "KFGameContent.KFDT_Explosive_HansHEGrenade";
		default.Player_DamageTaken[3].Multiplier = 0.75f;
		default.Player_DamageTaken[4].DamageType = "KFGameContent.KFDT_Explosive_PatMissile";
		default.Player_DamageTaken[4].Multiplier = 0.75f;
		default.Player_DamageTaken[5].DamageType = "KFGameContent.KFDT_EMP_MatriarchPlasmaCannon";
		default.Player_DamageTaken[5].Multiplier = 0.75f;

		default.Player_VampireEffect.Length = 3;
		default.Player_VampireEffect[0].DamageType = "KFGame.KFDT_Bludgeon";
		default.Player_VampireEffect[0].HealAmount = 3;
		default.Player_VampireEffect[1].DamageType = "KFGame.KFDT_Piercing";
		default.Player_VampireEffect[1].HealAmount = 3;
		default.Player_VampireEffect[2].DamageType = "KFGame.KFDT_Slashing";
		default.Player_VampireEffect[2].HealAmount = 3;
	}

	if (default.MODEVERSION < 18)
	{
		default.Player_StartingMaxGrenadeCount.Normal = 5;
		default.Player_StartingMaxGrenadeCount.Hard = 5;
		default.Player_StartingMaxGrenadeCount.Suicidal = 5;
		default.Player_StartingMaxGrenadeCount.HoE = 5;
		default.Player_StartingMaxGrenadeCount.Custom = 5;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i;

	for (i = 0; i < NumberOfDiffs; ++i)
	{
		if (GetStructValueInt(default.Player_StartingWeaponAmount, i) < 0)
		{
			LogBadStructConfigMessage(i, "Player_StartingWeaponAmount",
				string(GetStructValueInt(default.Player_StartingWeaponAmount, i)),
				"0", "0 weapons, no starting weapons", "value >= 0");
			SetStructValueInt(default.Player_StartingWeaponAmount, i, 0);
		}

		if (GetStructValueInt(default.Player_StartingMaxHealth, i) < 1)
		{
			LogBadStructConfigMessage(i, "Player_StartingMaxHealth",
				string(GetStructValueInt(default.Player_StartingMaxHealth, i)),
				"1", "1 max health", "value >= 1");
			SetStructValueInt(default.Player_StartingMaxHealth, i, 1);
		}

		if (GetStructValueInt(default.Player_StartingMaxArmor, i) < 1)
		{
			LogBadStructConfigMessage(i, "Player_StartingMaxArmor",
				string(GetStructValueInt(default.Player_StartingMaxArmor, i)),
				"1", "1 max armor", "value >= 1");
			SetStructValueInt(default.Player_StartingMaxArmor, i, 1);
		}

		if (GetStructValueInt(default.Player_StartingCarryWeight, i) < 1)
		{
			LogBadStructConfigMessage(i, "Player_StartingCarryWeight",
				string(GetStructValueInt(default.Player_StartingCarryWeight, i)),
				"1", "1 carry weight", "value >= 1");
			SetStructValueInt(default.Player_StartingCarryWeight, i, 1);
		}

		if (GetStructValueInt(default.Player_StartingMaxGrenadeCount, i) < 0)
		{
			LogBadStructConfigMessage(i, "Player_StartingMaxGrenadeCount",
				string(GetStructValueInt(default.Player_StartingMaxGrenadeCount, i)),
				"0", "0 grenades, no starting grenade capacity", "value >= 0");
			SetStructValueInt(default.Player_StartingMaxGrenadeCount, i, 0);
		}

		if (GetStructValueFloat(default.Player_HealAmountMultiplier, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Player_HealAmountMultiplier",
				string(GetStructValueFloat(default.Player_HealAmountMultiplier, i)),
				"0.0", "0%, no healing", "value >= 0.0");
			SetStructValueFloat(default.Player_HealAmountMultiplier, i, 0.0f);
		}

		if (GetStructValueFloat(default.Player_DamageTakenMultiplierWhileHoldingMelee, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Player_DamageTakenMultiplierWhileHoldingMelee",
				string(GetStructValueFloat(default.Player_DamageTakenMultiplierWhileHoldingMelee, i)),
				"0.0", "0%, no damage taken", "value >= 0.0");
			SetStructValueFloat(default.Player_DamageTakenMultiplierWhileHoldingMelee, i, 0.0f);
		}
	}

	for (i = 0; i < default.Player_DamageGiven.Length; ++i)
	{
		if (default.Player_DamageGiven[i].Multiplier < 0.0f)
		{
			LogBadConfigMessage("Player_DamageGiven - Line" @ string(i + 1) @ "- Multiplier",
				string(default.Player_DamageGiven[i].Multiplier),
				"0.0", "0%, no damage given", "value >= 0.0");
			default.Player_DamageGiven[i].Multiplier = 0.0f;
		}
	}

	for (i = 0; i < default.Player_DamageTaken.Length; ++i)
	{
		if (default.Player_DamageTaken[i].Multiplier < 0.0f)
		{
			LogBadConfigMessage("Player_DamageTaken - Line" @ string(i + 1) @ "- Multiplier",
				string(default.Player_DamageTaken[i].Multiplier),
				"0.0", "0%, no damage taken", "value >= 0.0");
			default.Player_DamageTaken[i].Multiplier = 0.0f;
		}
	}

	for (i = 0; i < default.Player_VampireEffect.Length; ++i)
	{
		if (default.Player_VampireEffect[i].HealAmount < 0)
		{
			LogBadConfigMessage("Player_VampireEffect - Line" @ string(i + 1) @ "- HealAmount",
				string(default.Player_VampireEffect[i].HealAmount),
				"0", "0 points, no healing", "value >= 0");
			default.Player_VampireEffect[i].HealAmount = 0;
		}
	}
}

static function LoadConfigObjects_DamageGiven(out array<S_Damage> ValidDT, out array< class<DamageType> > DTObjects)
{
	local int i;
	local class<DamageType> Obj;

	ValidDT.Length = 0;
	DTObjects.Length = 0;

	for (i = 0; i < default.Player_DamageGiven.Length; ++i)
	{
		Obj = class<DamageType>(DynamicLoadObject(default.Player_DamageGiven[i].DamageType, class'Class', True));
		if (Obj == None)
		{
			LogBadLoadObjectConfigMessage("Player_DamageGiven", i + 1, default.Player_DamageGiven[i].DamageType);
		}
		else
		{
			ValidDT.AddItem(default.Player_DamageGiven[i]);
			DTObjects.AddItem(Obj);
		}
	}
}

static function LoadConfigObjects_DamageTaken(out array<S_Damage> ValidDT, out array< class<DamageType> > DTObjects)
{
	local int i;
	local class<DamageType> Obj;

	ValidDT.Length = 0;
	DTObjects.Length = 0;

	for (i = 0; i < default.Player_DamageTaken.Length; ++i)
	{
		Obj = class<DamageType>(DynamicLoadObject(default.Player_DamageTaken[i].DamageType, class'Class', True));
		if (Obj == None)
		{
			LogBadLoadObjectConfigMessage("Player_DamageTaken", i + 1, default.Player_DamageTaken[i].DamageType);
		}
		else
		{
			ValidDT.AddItem(default.Player_DamageTaken[i]);
			DTObjects.AddItem(Obj);
		}
	}
}

static function LoadConfigObjects_Vampire(out array<S_Vampire> ValidDT, out array< class<DamageType> > DTObjects)
{
	local int i;
	local class<DamageType> Obj;

	ValidDT.Length = 0;
	DTObjects.Length = 0;

	for (i = 0; i < default.Player_VampireEffect.Length; ++i)
	{
		Obj = class<DamageType>(DynamicLoadObject(default.Player_VampireEffect[i].DamageType, class'Class', True));
		if (Obj == None)
		{
			LogBadLoadObjectConfigMessage("Player_VampireEffect", i + 1, default.Player_VampireEffect[i].DamageType);
		}
		else
		{
			ValidDT.AddItem(default.Player_VampireEffect[i]);
			DTObjects.AddItem(Obj);
		}
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

static function int GetStartingMaxGrenadeCount(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_StartingMaxGrenadeCount.Normal;
		case 1 : return default.Player_StartingMaxGrenadeCount.Hard;
		case 2 : return default.Player_StartingMaxGrenadeCount.Suicidal;
		case 3 : return default.Player_StartingMaxGrenadeCount.HoE;
		default: return default.Player_StartingMaxGrenadeCount.Custom;
	}
}

static function float GetHealAmountMultiplier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_HealAmountMultiplier.Normal;
		case 1 : return default.Player_HealAmountMultiplier.Hard;
		case 2 : return default.Player_HealAmountMultiplier.Suicidal;
		case 3 : return default.Player_HealAmountMultiplier.HoE;
		default: return default.Player_HealAmountMultiplier.Custom;
	}
}

static function float GetDamageTakenMultiplierWhileHoldingMelee(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Player_DamageTakenMultiplierWhileHoldingMelee.Normal;
		case 1 : return default.Player_DamageTakenMultiplierWhileHoldingMelee.Hard;
		case 2 : return default.Player_DamageTakenMultiplierWhileHoldingMelee.Suicidal;
		case 3 : return default.Player_DamageTakenMultiplierWhileHoldingMelee.HoE;
		default: return default.Player_DamageTakenMultiplierWhileHoldingMelee.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Player"
}
