class Config_DifficultyLarge extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

var config S_Difficulty_Float ZedLarge_HealthModifier;
var config S_Difficulty_Float ZedLarge_ExtraHealthModifierPerPlayer;
var config S_Difficulty_Float ZedLarge_HeadHealthModifier;
var config S_Difficulty_Float ZedLarge_DamageModifier;
var config S_Difficulty_Float ZedLarge_SoloDamageModifier;
var config S_Difficulty_Float ZedLarge_SpeedModifier;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedLarge_HealthModifier.Normal = 0.85f;
		default.ZedLarge_HealthModifier.Hard = 0.9f;
		default.ZedLarge_HealthModifier.Suicidal = 1.0f;
		default.ZedLarge_HealthModifier.HoE = 1.0f;
		default.ZedLarge_HealthModifier.Custom = 1.0f;

		default.ZedLarge_ExtraHealthModifierPerPlayer.Normal = 0.08f;
		default.ZedLarge_ExtraHealthModifierPerPlayer.Hard = 0.08f;
		default.ZedLarge_ExtraHealthModifierPerPlayer.Suicidal = 0.08f;
		default.ZedLarge_ExtraHealthModifierPerPlayer.HoE = 0.08f;
		default.ZedLarge_ExtraHealthModifierPerPlayer.Custom = 0.08f;

		default.ZedLarge_HeadHealthModifier.Normal = 0.9f;
		default.ZedLarge_HeadHealthModifier.Hard = 0.95f;
		default.ZedLarge_HeadHealthModifier.Suicidal = 1.0f;
		default.ZedLarge_HeadHealthModifier.HoE = 1.0f;
		default.ZedLarge_HeadHealthModifier.Custom = 1.0f;

		default.ZedLarge_DamageModifier.Normal = 0.65f;
		default.ZedLarge_DamageModifier.Hard = 0.7f;
		default.ZedLarge_DamageModifier.Suicidal = 0.8f;
		default.ZedLarge_DamageModifier.HoE = 0.9f;
		default.ZedLarge_DamageModifier.Custom = 0.9f;

		default.ZedLarge_SoloDamageModifier.Normal = 0.6f;
		default.ZedLarge_SoloDamageModifier.Hard = 0.7f;
		default.ZedLarge_SoloDamageModifier.Suicidal = 0.8f;
		default.ZedLarge_SoloDamageModifier.HoE = 0.9f;
		default.ZedLarge_SoloDamageModifier.Custom = 0.9f;

		default.ZedLarge_SpeedModifier.Normal = 0.85f;
		default.ZedLarge_SpeedModifier.Hard = 0.9f;
		default.ZedLarge_SpeedModifier.Suicidal = 0.95f;
		default.ZedLarge_SpeedModifier.HoE = 1.0f;
		default.ZedLarge_SpeedModifier.Custom = 1.0f;
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
		if (GetStructValueFloat(default.ZedLarge_HealthModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "ZedLarge_HealthModifier",
				string(GetStructValueFloat(default.ZedLarge_HealthModifier, i)),
				"0.05", "5%", "value >= 0.05");
			SetStructValueFloat(default.ZedLarge_HealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedLarge_ExtraHealthModifierPerPlayer, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "ZedLarge_ExtraHealthModifierPerPlayer",
				string(GetStructValueFloat(default.ZedLarge_ExtraHealthModifierPerPlayer, i)),
				"0.0", "0%", "value >= 0.0");
			SetStructValueFloat(default.ZedLarge_ExtraHealthModifierPerPlayer, i, 0.0f);
		}

		if (GetStructValueFloat(default.ZedLarge_HeadHealthModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "ZedLarge_HeadHealthModifier",
				string(GetStructValueFloat(default.ZedLarge_HeadHealthModifier, i)),
				"0.05", "5%", "value >= 0.05");
			SetStructValueFloat(default.ZedLarge_HeadHealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedLarge_DamageModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "ZedLarge_DamageModifier",
				string(GetStructValueFloat(default.ZedLarge_DamageModifier, i)),
				"0.05", "5%", "value >= 0.05");
			SetStructValueFloat(default.ZedLarge_DamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedLarge_SoloDamageModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "ZedLarge_SoloDamageModifier",
				string(GetStructValueFloat(default.ZedLarge_SoloDamageModifier, i)),
				"0.05", "5%", "value >= 0.05");
			SetStructValueFloat(default.ZedLarge_SoloDamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedLarge_SpeedModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "ZedLarge_SpeedModifier",
				string(GetStructValueFloat(default.ZedLarge_SpeedModifier, i)),
				"0.05", "5%", "value >= 0.05");
			SetStructValueFloat(default.ZedLarge_SpeedModifier, i, 0.05f);
		}
	}
}

static function float GetZedHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedLarge_HealthModifier.Normal;
		case 1 : return default.ZedLarge_HealthModifier.Hard;
		case 2 : return default.ZedLarge_HealthModifier.Suicidal;
		case 3 : return default.ZedLarge_HealthModifier.HoE;
		default: return default.ZedLarge_HealthModifier.Custom;
	}
}

static function float GetExtraHealthModifierPerPlayer(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedLarge_ExtraHealthModifierPerPlayer.Normal;
		case 1 : return default.ZedLarge_ExtraHealthModifierPerPlayer.Hard;
		case 2 : return default.ZedLarge_ExtraHealthModifierPerPlayer.Suicidal;
		case 3 : return default.ZedLarge_ExtraHealthModifierPerPlayer.HoE;
		default: return default.ZedLarge_ExtraHealthModifierPerPlayer.Custom;
	}
}

static function float GetZedHeadHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedLarge_HeadHealthModifier.Normal;
		case 1 : return default.ZedLarge_HeadHealthModifier.Hard;
		case 2 : return default.ZedLarge_HeadHealthModifier.Suicidal;
		case 3 : return default.ZedLarge_HeadHealthModifier.HoE;
		default: return default.ZedLarge_HeadHealthModifier.Custom;
	}
}

static function float GetZedDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedLarge_DamageModifier.Normal;
		case 1 : return default.ZedLarge_DamageModifier.Hard;
		case 2 : return default.ZedLarge_DamageModifier.Suicidal;
		case 3 : return default.ZedLarge_DamageModifier.HoE;
		default: return default.ZedLarge_DamageModifier.Custom;
	}
}

static function float GetZedSoloDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedLarge_SoloDamageModifier.Normal;
		case 1 : return default.ZedLarge_SoloDamageModifier.Hard;
		case 2 : return default.ZedLarge_SoloDamageModifier.Suicidal;
		case 3 : return default.ZedLarge_SoloDamageModifier.HoE;
		default: return default.ZedLarge_SoloDamageModifier.Custom;
	}
}

static function float GetZedSpeedModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedLarge_SpeedModifier.Normal;
		case 1 : return default.ZedLarge_SpeedModifier.Hard;
		case 2 : return default.ZedLarge_SpeedModifier.Suicidal;
		case 3 : return default.ZedLarge_SpeedModifier.HoE;
		default: return default.ZedLarge_SpeedModifier.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_DifficultyLarge"
}
