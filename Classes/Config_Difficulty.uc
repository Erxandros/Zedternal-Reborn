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
		if (GetZedHealthModifier(i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetZedHealthModifier(i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");

			switch (i)
			{
				case 0 : default.ZedMod_HealthModifier.Normal = 0.05f; break;
				case 1 : default.ZedMod_HealthModifier.Hard = 0.05f; break;
				case 2 : default.ZedMod_HealthModifier.Suicidal = 0.05f; break;
				case 3 : default.ZedMod_HealthModifier.HoE = 0.05f; break;
				default: default.ZedMod_HealthModifier.Custom = 0.05f; break;
			}
		}

		if (GetLargeZedHealthModifierPerPlayer(i) < 0.0f)
		{
			`log("ZR Config: Modifier for ZED large health bonus at difficulty" @ GetDiffString(i)
				@"is set to" @ GetLargeZedHealthModifierPerPlayer(i)
				@"which is not supported. Setting the modifier to the minimum value of 0.0 (0%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");

			switch (i)
			{
				case 0 : default.ZedMod_LargeZedHealthModifierPerPlayer.Normal = 0.0f; break;
				case 1 : default.ZedMod_LargeZedHealthModifierPerPlayer.Hard = 0.0f; break;
				case 2 : default.ZedMod_LargeZedHealthModifierPerPlayer.Suicidal = 0.0f; break;
				case 3 : default.ZedMod_LargeZedHealthModifierPerPlayer.HoE = 0.0f; break;
				default: default.ZedMod_LargeZedHealthModifierPerPlayer.Custom = 0.0f; break;
			}
		}

		if (GetZedHeadHealthModifier(i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED head health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetZedHeadHealthModifier(i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");

			switch (i)
			{
				case 0 : default.ZedMod_HeadHealthModifier.Normal = 0.05f; break;
				case 1 : default.ZedMod_HeadHealthModifier.Hard = 0.05f; break;
				case 2 : default.ZedMod_HeadHealthModifier.Suicidal = 0.05f; break;
				case 3 : default.ZedMod_HeadHealthModifier.HoE = 0.05f; break;
				default: default.ZedMod_HeadHealthModifier.Custom = 0.05f; break;
			}
		}

		if (GetZedDamageModifier(i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED damage at difficulty" @ GetDiffString(i)
				@"is set to" @ GetZedDamageModifier(i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");

			switch (i)
			{
				case 0 : default.ZedMod_DamageModifier.Normal = 0.05f; break;
				case 1 : default.ZedMod_DamageModifier.Hard = 0.05f; break;
				case 2 : default.ZedMod_DamageModifier.Suicidal = 0.05f; break;
				case 3 : default.ZedMod_DamageModifier.HoE = 0.05f; break;
				default: default.ZedMod_DamageModifier.Custom = 0.05f; break;
			}
		}

		if (GetZedSoloDamageModifier(i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED solo damage at difficulty" @ GetDiffString(i)
				@"is set to" @ GetZedSoloDamageModifier(i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");

			switch (i)
			{
				case 0 : default.ZedMod_SoloDamageModifier.Normal = 0.05f; break;
				case 1 : default.ZedMod_SoloDamageModifier.Hard = 0.05f; break;
				case 2 : default.ZedMod_SoloDamageModifier.Suicidal = 0.05f; break;
				case 3 : default.ZedMod_SoloDamageModifier.HoE = 0.05f; break;
				default: default.ZedMod_SoloDamageModifier.Custom = 0.05f; break;
			}
		}

		if (GetZedSpeedModifier(i) < 0.05f)
		{
			`log("ZR Config: Modifier for ZED speed at difficulty" @ GetDiffString(i)
				@"is set to" @ GetZedSpeedModifier(i)
				@"which is not supported. Setting the modifier to the minimum value of 0.05 (5%) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.05.");

			switch (i)
			{
				case 0 : default.ZedMod_SpeedModifier.Normal = 0.05f; break;
				case 1 : default.ZedMod_SpeedModifier.Hard = 0.05f; break;
				case 2 : default.ZedMod_SpeedModifier.Suicidal = 0.05f; break;
				case 3 : default.ZedMod_SpeedModifier.HoE = 0.05f; break;
				default: default.ZedMod_SpeedModifier.Custom = 0.05f; break;
			}
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
