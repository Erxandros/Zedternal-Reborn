class Config_Difficulty extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

var config S_Difficulty_Float ZedMod_HealthModifier;
var config S_Difficulty_Float ZedMod_LargeZedHealthModifierPerPlayer;
var config S_Difficulty_Float ZedMod_HeadHealthModifier;
var config S_Difficulty_Float ZedMod_DamageModifier;
var config S_Difficulty_Float ZedMod_SoloDamageModifier;
var config S_Difficulty_Float ZedMod_SpeedModifier;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedMod_HealthModifier.Normal = 0.9f;
		default.ZedMod_HealthModifier.Hard = 1.0f;
		default.ZedMod_HealthModifier.Suicidal = 1.0f;
		default.ZedMod_HealthModifier.HoE = 1.0f;
		default.ZedMod_HealthModifier.Custom = 1.0f;

		default.ZedMod_LargeZedHealthModifierPerPlayer.Normal = 0.08f;
		default.ZedMod_LargeZedHealthModifierPerPlayer.Hard = 0.08f;
		default.ZedMod_LargeZedHealthModifierPerPlayer.Suicidal = 0.08f;
		default.ZedMod_LargeZedHealthModifierPerPlayer.HoE = 0.08f;
		default.ZedMod_LargeZedHealthModifierPerPlayer.Custom = 0.08f;

		default.ZedMod_HeadHealthModifier.Normal = 0.95f;
		default.ZedMod_HeadHealthModifier.Hard = 1.0f;
		default.ZedMod_HeadHealthModifier.Suicidal = 1.0f;
		default.ZedMod_HeadHealthModifier.HoE = 1.0f;
		default.ZedMod_HeadHealthModifier.Custom = 1.0f;

		default.ZedMod_DamageModifier.Normal = 0.65f;
		default.ZedMod_DamageModifier.Hard = 0.7f;
		default.ZedMod_DamageModifier.Suicidal = 0.8f;
		default.ZedMod_DamageModifier.HoE = 0.9f;
		default.ZedMod_DamageModifier.Custom = 0.9f;

		default.ZedMod_SoloDamageModifier.Normal = 0.6f;
		default.ZedMod_SoloDamageModifier.Hard = 0.7f;
		default.ZedMod_SoloDamageModifier.Suicidal = 0.8f;
		default.ZedMod_SoloDamageModifier.HoE = 0.9f;
		default.ZedMod_SoloDamageModifier.Custom = 0.9f;

		default.ZedMod_SpeedModifier.Normal = 0.925f;
		default.ZedMod_SpeedModifier.Hard = 0.95f;
		default.ZedMod_SpeedModifier.Suicidal = 0.975f;
		default.ZedMod_SpeedModifier.HoE = 1.0f;
		default.ZedMod_SpeedModifier.Custom = 1.0f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local byte i;

	for (i = 0; i < NumberOfDiffs; ++i)
	{
		if (GetStructValueFloat(default.ZedMod_HealthModifier, i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.ZedMod_HealthModifier, i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");
			SetStructValueFloat(default.ZedMod_HealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedMod_LargeZedHealthModifierPerPlayer, i) < 0.0f)
		{
			`log("ZR Config: Modifier for ZED large health bonus at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.ZedMod_LargeZedHealthModifierPerPlayer, i)
				@"which is not supported. Setting the modifier to the minimum value of 0.0 (0%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.ZedMod_LargeZedHealthModifierPerPlayer, i, 0.0f);
		}

		if (GetStructValueFloat(default.ZedMod_HeadHealthModifier, i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED head health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.ZedMod_HeadHealthModifier, i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");
			SetStructValueFloat(default.ZedMod_HeadHealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedMod_DamageModifier, i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED damage at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.ZedMod_DamageModifier, i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");
			SetStructValueFloat(default.ZedMod_DamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedMod_SoloDamageModifier, i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED solo damage at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.ZedMod_SoloDamageModifier, i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");
			SetStructValueFloat(default.ZedMod_SoloDamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedMod_SpeedModifier, i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED speed at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.ZedMod_SpeedModifier, i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");
			SetStructValueFloat(default.ZedMod_SpeedModifier, i, 0.05f);
		}
	}
}

static function float GetZedHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedMod_HealthModifier.Normal;
		case 1 : return default.ZedMod_HealthModifier.Hard;
		case 2 : return default.ZedMod_HealthModifier.Suicidal;
		case 3 : return default.ZedMod_HealthModifier.HoE;
		default: return default.ZedMod_HealthModifier.Custom;
	}
}

static function float GetLargeZedHealthModifierPerPlayer(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedMod_LargeZedHealthModifierPerPlayer.Normal;
		case 1 : return default.ZedMod_LargeZedHealthModifierPerPlayer.Hard;
		case 2 : return default.ZedMod_LargeZedHealthModifierPerPlayer.Suicidal;
		case 3 : return default.ZedMod_LargeZedHealthModifierPerPlayer.HoE;
		default: return default.ZedMod_LargeZedHealthModifierPerPlayer.Custom;
	}
}

static function float GetZedHeadHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedMod_HeadHealthModifier.Normal;
		case 1 : return default.ZedMod_HeadHealthModifier.Hard;
		case 2 : return default.ZedMod_HeadHealthModifier.Suicidal;
		case 3 : return default.ZedMod_HeadHealthModifier.HoE;
		default: return default.ZedMod_HeadHealthModifier.Custom;
	}
}

static function float GetZedDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedMod_DamageModifier.Normal;
		case 1 : return default.ZedMod_DamageModifier.Hard;
		case 2 : return default.ZedMod_DamageModifier.Suicidal;
		case 3 : return default.ZedMod_DamageModifier.HoE;
		default: return default.ZedMod_DamageModifier.Custom;
	}
}

static function float GetZedSoloDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedMod_SoloDamageModifier.Normal;
		case 1 : return default.ZedMod_SoloDamageModifier.Hard;
		case 2 : return default.ZedMod_SoloDamageModifier.Suicidal;
		case 3 : return default.ZedMod_SoloDamageModifier.HoE;
		default: return default.ZedMod_SoloDamageModifier.Custom;
	}
}

static function float GetZedSpeedModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedMod_SpeedModifier.Normal;
		case 1 : return default.ZedMod_SpeedModifier.Hard;
		case 2 : return default.ZedMod_SpeedModifier.Suicidal;
		case 3 : return default.ZedMod_SpeedModifier.HoE;
		default: return default.ZedMod_SpeedModifier.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Difficulty"
}
