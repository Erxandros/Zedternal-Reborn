class Config_DifficultyNormal extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

var config S_Difficulty_Float ZedNormal_HealthModifier;
var config S_Difficulty_Float ZedNormal_ExtraHealthModifierPerPlayer;
var config S_Difficulty_Float ZedNormal_HeadHealthModifier;
var config S_Difficulty_Float ZedNormal_DamageModifier;
var config S_Difficulty_Float ZedNormal_SoloDamageModifier;
var config S_Difficulty_Float ZedNormal_SpeedModifier;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedNormal_HealthModifier.Normal = 0.85f;
		default.ZedNormal_HealthModifier.Hard = 0.9f;
		default.ZedNormal_HealthModifier.Suicidal = 1.0f;
		default.ZedNormal_HealthModifier.HoE = 1.0f;
		default.ZedNormal_HealthModifier.Custom = 1.0f;

		default.ZedNormal_ExtraHealthModifierPerPlayer.Normal = 0.04f;
		default.ZedNormal_ExtraHealthModifierPerPlayer.Hard = 0.04f;
		default.ZedNormal_ExtraHealthModifierPerPlayer.Suicidal = 0.04f;
		default.ZedNormal_ExtraHealthModifierPerPlayer.HoE = 0.04f;
		default.ZedNormal_ExtraHealthModifierPerPlayer.Custom = 0.04f;

		default.ZedNormal_HeadHealthModifier.Normal = 0.9f;
		default.ZedNormal_HeadHealthModifier.Hard = 0.95f;
		default.ZedNormal_HeadHealthModifier.Suicidal = 1.0f;
		default.ZedNormal_HeadHealthModifier.HoE = 1.0f;
		default.ZedNormal_HeadHealthModifier.Custom = 1.0f;

		default.ZedNormal_DamageModifier.Normal = 0.65f;
		default.ZedNormal_DamageModifier.Hard = 0.7f;
		default.ZedNormal_DamageModifier.Suicidal = 0.8f;
		default.ZedNormal_DamageModifier.HoE = 0.9f;
		default.ZedNormal_DamageModifier.Custom = 0.9f;

		default.ZedNormal_SoloDamageModifier.Normal = 0.6f;
		default.ZedNormal_SoloDamageModifier.Hard = 0.7f;
		default.ZedNormal_SoloDamageModifier.Suicidal = 0.8f;
		default.ZedNormal_SoloDamageModifier.HoE = 0.9f;
		default.ZedNormal_SoloDamageModifier.Custom = 0.9f;

		default.ZedNormal_SpeedModifier.Normal = 0.925f;
		default.ZedNormal_SpeedModifier.Hard = 0.95f;
		default.ZedNormal_SpeedModifier.Suicidal = 0.975f;
		default.ZedNormal_SpeedModifier.HoE = 1.0f;
		default.ZedNormal_SpeedModifier.Custom = 1.0f;
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
		if (GetStructValueFloat(default.ZedNormal_HealthModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for normal ZED health", "modifier",
				string(GetStructValueFloat(default.ZedNormal_HealthModifier, i)),
				"0.05", "5%", "ZedNormal_HealthModifier", 0);
			SetStructValueFloat(default.ZedNormal_HealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedNormal_ExtraHealthModifierPerPlayer, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Modifier for normal ZED extra health per player", "modifier",
				string(GetStructValueFloat(default.ZedNormal_ExtraHealthModifierPerPlayer, i)),
				"0.0", "0%", "ZedNormal_ExtraHealthModifierPerPlayer", 0);
			SetStructValueFloat(default.ZedNormal_ExtraHealthModifierPerPlayer, i, 0.0f);
		}

		if (GetStructValueFloat(default.ZedNormal_HeadHealthModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for normal ZED head health", "modifier",
				string(GetStructValueFloat(default.ZedNormal_HeadHealthModifier, i)),
				"0.05", "5%", "ZedNormal_HeadHealthModifier", 0);
			SetStructValueFloat(default.ZedNormal_HeadHealthModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedNormal_DamageModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for normal ZED damage", "modifier",
				string(GetStructValueFloat(default.ZedNormal_DamageModifier, i)),
				"0.05", "5%", "ZedNormal_DamageModifier", 0);
			SetStructValueFloat(default.ZedNormal_DamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedNormal_SoloDamageModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for normal ZED solo damage", "modifier",
				string(GetStructValueFloat(default.ZedNormal_SoloDamageModifier, i)),
				"0.05", "5%", "ZedNormal_SoloDamageModifier", 0);
			SetStructValueFloat(default.ZedNormal_SoloDamageModifier, i, 0.05f);
		}

		if (GetStructValueFloat(default.ZedNormal_SpeedModifier, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Modifier for normal ZED speed", "modifier",
				string(GetStructValueFloat(default.ZedNormal_SpeedModifier, i)),
				"0.05", "5%", "ZedNormal_SpeedModifier", 0);
			SetStructValueFloat(default.ZedNormal_SpeedModifier, i, 0.05f);
		}
	}
}

static function float GetZedHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedNormal_HealthModifier.Normal;
		case 1 : return default.ZedNormal_HealthModifier.Hard;
		case 2 : return default.ZedNormal_HealthModifier.Suicidal;
		case 3 : return default.ZedNormal_HealthModifier.HoE;
		default: return default.ZedNormal_HealthModifier.Custom;
	}
}

static function float GetExtraHealthModifierPerPlayer(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedNormal_ExtraHealthModifierPerPlayer.Normal;
		case 1 : return default.ZedNormal_ExtraHealthModifierPerPlayer.Hard;
		case 2 : return default.ZedNormal_ExtraHealthModifierPerPlayer.Suicidal;
		case 3 : return default.ZedNormal_ExtraHealthModifierPerPlayer.HoE;
		default: return default.ZedNormal_ExtraHealthModifierPerPlayer.Custom;
	}
}

static function float GetZedHeadHealthModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedNormal_HeadHealthModifier.Normal;
		case 1 : return default.ZedNormal_HeadHealthModifier.Hard;
		case 2 : return default.ZedNormal_HeadHealthModifier.Suicidal;
		case 3 : return default.ZedNormal_HeadHealthModifier.HoE;
		default: return default.ZedNormal_HeadHealthModifier.Custom;
	}
}

static function float GetZedDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedNormal_DamageModifier.Normal;
		case 1 : return default.ZedNormal_DamageModifier.Hard;
		case 2 : return default.ZedNormal_DamageModifier.Suicidal;
		case 3 : return default.ZedNormal_DamageModifier.HoE;
		default: return default.ZedNormal_DamageModifier.Custom;
	}
}

static function float GetZedSoloDamageModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedNormal_SoloDamageModifier.Normal;
		case 1 : return default.ZedNormal_SoloDamageModifier.Hard;
		case 2 : return default.ZedNormal_SoloDamageModifier.Suicidal;
		case 3 : return default.ZedNormal_SoloDamageModifier.HoE;
		default: return default.ZedNormal_SoloDamageModifier.Custom;
	}
}

static function float GetZedSpeedModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedNormal_SpeedModifier.Normal;
		case 1 : return default.ZedNormal_SpeedModifier.Hard;
		case 2 : return default.ZedNormal_SpeedModifier.Suicidal;
		case 3 : return default.ZedNormal_SpeedModifier.HoE;
		default: return default.ZedNormal_SpeedModifier.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_DifficultyNormal"
}
