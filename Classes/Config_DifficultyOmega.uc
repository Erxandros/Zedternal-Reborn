class Config_DifficultyOmega extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

var config S_Difficulty_Float ZedOmega_HealthModifier;
var config S_Difficulty_Float ZedOmega_ExtraHealthModifierPerPlayer;
var config S_Difficulty_Float ZedOmega_HeadHealthModifier;
var config S_Difficulty_Float ZedOmega_DamageModifier;
var config S_Difficulty_Float ZedOmega_SoloDamageModifier;
var config S_Difficulty_Float ZedOmega_SpeedModifier;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedOmega_HealthModifier.Normal = 0.85f;
		default.ZedOmega_HealthModifier.Hard = 0.9f;
		default.ZedOmega_HealthModifier.Suicidal = 1.0f;
		default.ZedOmega_HealthModifier.HoE = 1.0f;
		default.ZedOmega_HealthModifier.Custom = 1.0f;

		default.ZedOmega_ExtraHealthModifierPerPlayer.Normal = 0.02f;
		default.ZedOmega_ExtraHealthModifierPerPlayer.Hard = 0.02f;
		default.ZedOmega_ExtraHealthModifierPerPlayer.Suicidal = 0.02f;
		default.ZedOmega_ExtraHealthModifierPerPlayer.HoE = 0.02f;
		default.ZedOmega_ExtraHealthModifierPerPlayer.Custom = 0.02f;

		default.ZedOmega_HeadHealthModifier.Normal = 0.9f;
		default.ZedOmega_HeadHealthModifier.Hard = 0.95f;
		default.ZedOmega_HeadHealthModifier.Suicidal = 1.0f;
		default.ZedOmega_HeadHealthModifier.HoE = 1.0f;
		default.ZedOmega_HeadHealthModifier.Custom = 1.0f;

		default.ZedOmega_DamageModifier.Normal = 0.65f;
		default.ZedOmega_DamageModifier.Hard = 0.7f;
		default.ZedOmega_DamageModifier.Suicidal = 0.8f;
		default.ZedOmega_DamageModifier.HoE = 0.9f;
		default.ZedOmega_DamageModifier.Custom = 0.9f;

		default.ZedOmega_SoloDamageModifier.Normal = 0.6f;
		default.ZedOmega_SoloDamageModifier.Hard = 0.7f;
		default.ZedOmega_SoloDamageModifier.Suicidal = 0.8f;
		default.ZedOmega_SoloDamageModifier.HoE = 0.9f;
		default.ZedOmega_SoloDamageModifier.Custom = 0.9f;

		default.ZedOmega_SpeedModifier.Normal = 0.8f;
		default.ZedOmega_SpeedModifier.Hard = 0.8f;
		default.ZedOmega_SpeedModifier.Suicidal = 0.825f;
		default.ZedOmega_SpeedModifier.HoE = 0.85f;
		default.ZedOmega_SpeedModifier.Custom = 0.85f;
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
		if (GetStructValueFloat(default.ZedOmega_HealthModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for omega ZED health", "modifier",
				string(GetStructValueFloat(default.ZedOmega_HealthModifier, i)),
				"0.05", "5%", "ZedOmega_HealthModifier", 0);
			SetStructValueFloat(default.ZedOmega_HealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedOmega_ExtraHealthModifierPerPlayer, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Modifier for omega ZED extra health per player", "modifier",
				string(GetStructValueFloat(default.ZedOmega_ExtraHealthModifierPerPlayer, i)),
				"0.0", "0%", "ZedOmega_ExtraHealthModifierPerPlayer", 0);
			SetStructValueFloat(default.ZedOmega_ExtraHealthModifierPerPlayer, i, 0.0f);
		}

		if (GetStructValueFloat(default.ZedOmega_HeadHealthModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for omega ZED head health", "modifier",
				string(GetStructValueFloat(default.ZedOmega_HeadHealthModifier, i)),
				"0.05", "5%", "ZedOmega_HeadHealthModifier", 0);
			SetStructValueFloat(default.ZedOmega_HeadHealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedOmega_DamageModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for omega ZED damage", "modifier",
				string(GetStructValueFloat(default.ZedOmega_DamageModifier, i)),
				"0.05", "5%", "ZedOmega_DamageModifier", 0);
			SetStructValueFloat(default.ZedOmega_DamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedOmega_SoloDamageModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for omega ZED solo damage", "modifier",
				string(GetStructValueFloat(default.ZedOmega_SoloDamageModifier, i)),
				"0.05", "5%", "ZedOmega_SoloDamageModifier", 0);
			SetStructValueFloat(default.ZedOmega_SoloDamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedOmega_SpeedModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for omega ZED speed", "modifier",
				string(GetStructValueFloat(default.ZedOmega_SpeedModifier, i)),
				"0.05", "5%", "ZedOmega_SpeedModifier", 0);
			SetStructValueFloat(default.ZedOmega_SpeedModifier, i, 0.05f);
		}
	}
}

static function float GetZedHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedOmega_HealthModifier.Normal;
		case 1 : return default.ZedOmega_HealthModifier.Hard;
		case 2 : return default.ZedOmega_HealthModifier.Suicidal;
		case 3 : return default.ZedOmega_HealthModifier.HoE;
		default: return default.ZedOmega_HealthModifier.Custom;
	}
}

static function float GetExtraHealthModifierPerPlayer(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedOmega_ExtraHealthModifierPerPlayer.Normal;
		case 1 : return default.ZedOmega_ExtraHealthModifierPerPlayer.Hard;
		case 2 : return default.ZedOmega_ExtraHealthModifierPerPlayer.Suicidal;
		case 3 : return default.ZedOmega_ExtraHealthModifierPerPlayer.HoE;
		default: return default.ZedOmega_ExtraHealthModifierPerPlayer.Custom;
	}
}

static function float GetZedHeadHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedOmega_HeadHealthModifier.Normal;
		case 1 : return default.ZedOmega_HeadHealthModifier.Hard;
		case 2 : return default.ZedOmega_HeadHealthModifier.Suicidal;
		case 3 : return default.ZedOmega_HeadHealthModifier.HoE;
		default: return default.ZedOmega_HeadHealthModifier.Custom;
	}
}

static function float GetZedDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedOmega_DamageModifier.Normal;
		case 1 : return default.ZedOmega_DamageModifier.Hard;
		case 2 : return default.ZedOmega_DamageModifier.Suicidal;
		case 3 : return default.ZedOmega_DamageModifier.HoE;
		default: return default.ZedOmega_DamageModifier.Custom;
	}
}

static function float GetZedSoloDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedOmega_SoloDamageModifier.Normal;
		case 1 : return default.ZedOmega_SoloDamageModifier.Hard;
		case 2 : return default.ZedOmega_SoloDamageModifier.Suicidal;
		case 3 : return default.ZedOmega_SoloDamageModifier.HoE;
		default: return default.ZedOmega_SoloDamageModifier.Custom;
	}
}

static function float GetZedSpeedModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedOmega_SpeedModifier.Normal;
		case 1 : return default.ZedOmega_SpeedModifier.Hard;
		case 2 : return default.ZedOmega_SpeedModifier.Suicidal;
		case 3 : return default.ZedOmega_SpeedModifier.HoE;
		default: return default.ZedOmega_SpeedModifier.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_DifficultyOmega"
}
