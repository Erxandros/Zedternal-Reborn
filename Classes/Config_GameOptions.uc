class Config_GameOptions extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Bool Game_bArmorSpawnOnMap;

var config S_Difficulty_Bool Game_bAllowZedternalUpgradeMenuCommand;
var config S_Difficulty_Bool Game_bZedternalUpgradeMenuCommandAllWave;

var config S_Difficulty_Int Game_TimeBetweenWave;
var config S_Difficulty_Int Game_TimeBetweenWaveIfPlayerDead;

var config S_Difficulty_Int Game_DoshPickupDespawnTime;
var config S_Difficulty_Int Game_ProjectilePickupDespawnTime;
var config S_Difficulty_Int Game_WeaponPickupDespawnTime;

var config S_Difficulty_Bool Game_bEnableDamageIndicators;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Game_bArmorSpawnOnMap.Normal = True;
		default.Game_bArmorSpawnOnMap.Hard = True;
		default.Game_bArmorSpawnOnMap.Suicidal = True;
		default.Game_bArmorSpawnOnMap.HoE = True;
		default.Game_bArmorSpawnOnMap.Custom = True;

		default.Game_bAllowZedternalUpgradeMenuCommand.Normal = False;
		default.Game_bAllowZedternalUpgradeMenuCommand.Hard = False;
		default.Game_bAllowZedternalUpgradeMenuCommand.Suicidal = False;
		default.Game_bAllowZedternalUpgradeMenuCommand.HoE = False;
		default.Game_bAllowZedternalUpgradeMenuCommand.Custom = False;

		default.Game_bZedternalUpgradeMenuCommandAllWave.Normal = False;
		default.Game_bZedternalUpgradeMenuCommandAllWave.Hard = False;
		default.Game_bZedternalUpgradeMenuCommandAllWave.Suicidal = False;
		default.Game_bZedternalUpgradeMenuCommandAllWave.HoE = False;
		default.Game_bZedternalUpgradeMenuCommandAllWave.Custom = False;

		default.Game_TimeBetweenWave.Normal = 90;
		default.Game_TimeBetweenWave.Hard = 80;
		default.Game_TimeBetweenWave.Suicidal = 70;
		default.Game_TimeBetweenWave.HoE = 70;
		default.Game_TimeBetweenWave.Custom = 70;

		default.Game_TimeBetweenWaveIfPlayerDead.Normal = 100;
		default.Game_TimeBetweenWaveIfPlayerDead.Hard = 100;
		default.Game_TimeBetweenWaveIfPlayerDead.Suicidal = 80;
		default.Game_TimeBetweenWaveIfPlayerDead.HoE = 80;
		default.Game_TimeBetweenWaveIfPlayerDead.Custom = 80;
	}

	if (default.MODEVERSION < 14)
	{
		default.Game_DoshPickupDespawnTime.Normal = 90;
		default.Game_DoshPickupDespawnTime.Hard = 90;
		default.Game_DoshPickupDespawnTime.Suicidal = 90;
		default.Game_DoshPickupDespawnTime.HoE = 90;
		default.Game_DoshPickupDespawnTime.Custom = 90;

		default.Game_ProjectilePickupDespawnTime.Normal = 150;
		default.Game_ProjectilePickupDespawnTime.Hard = 150;
		default.Game_ProjectilePickupDespawnTime.Suicidal = 150;
		default.Game_ProjectilePickupDespawnTime.HoE = 150;
		default.Game_ProjectilePickupDespawnTime.Custom = 150;

		default.Game_WeaponPickupDespawnTime.Normal = 14400;
		default.Game_WeaponPickupDespawnTime.Hard = 14400;
		default.Game_WeaponPickupDespawnTime.Suicidal = 14400;
		default.Game_WeaponPickupDespawnTime.HoE = 14400;
		default.Game_WeaponPickupDespawnTime.Custom = 14400;
	}

	if (default.MODEVERSION < 15)
	{
		default.Game_bEnableDamageIndicators.Normal = True;
		default.Game_bEnableDamageIndicators.Hard = True;
		default.Game_bEnableDamageIndicators.Suicidal = True;
		default.Game_bEnableDamageIndicators.HoE = True;
		default.Game_bEnableDamageIndicators.Custom = True;
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
		if (GetStructValueInt(default.Game_TimeBetweenWave, i) < 10)
		{
			LogBadStructConfigMessage(i, "Game_TimeBetweenWave",
				string(GetStructValueInt(default.Game_TimeBetweenWave, i)),
				"10", "10 seconds", "value >= 10");
			SetStructValueInt(default.Game_TimeBetweenWave, i, 10);
		}

		if (GetStructValueInt(default.Game_TimeBetweenWaveIfPlayerDead, i) < 10)
		{
			LogBadStructConfigMessage(i, "Game_TimeBetweenWaveIfPlayerDead",
				string(GetStructValueInt(default.Game_TimeBetweenWaveIfPlayerDead, i)),
				"10", "10 seconds", "value >= 10");
			SetStructValueInt(default.Game_TimeBetweenWaveIfPlayerDead, i, 10);
		}

		if (GetStructValueInt(default.Game_DoshPickupDespawnTime, i) < 0)
		{
			LogBadStructConfigMessage(i, "Game_DoshPickupDespawnTime",
				string(GetStructValueInt(default.Game_DoshPickupDespawnTime, i)),
				"0", "default timeout", "value >= 0");
			SetStructValueInt(default.Game_DoshPickupDespawnTime, i, 0);
		}

		if (GetStructValueInt(default.Game_ProjectilePickupDespawnTime, i) < 0)
		{
			LogBadStructConfigMessage(i, "Game_ProjectilePickupDespawnTime",
				string(GetStructValueInt(default.Game_ProjectilePickupDespawnTime, i)),
				"0", "default timeout", "value >= 0");
			SetStructValueInt(default.Game_ProjectilePickupDespawnTime, i, 0);
		}

		if (GetStructValueInt(default.Game_WeaponPickupDespawnTime, i) < 0)
		{
			LogBadStructConfigMessage(i, "Game_WeaponPickupDespawnTime",
				string(GetStructValueInt(default.Game_WeaponPickupDespawnTime, i)),
				"0", "default timeout", "value >= 0");
			SetStructValueInt(default.Game_WeaponPickupDespawnTime, i, 0);
		}
	}
}

static function bool GetShouldArmorSpawnOnMap(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_bArmorSpawnOnMap.Normal;
		case 1 : return default.Game_bArmorSpawnOnMap.Hard;
		case 2 : return default.Game_bArmorSpawnOnMap.Suicidal;
		case 3 : return default.Game_bArmorSpawnOnMap.HoE;
		default: return default.Game_bArmorSpawnOnMap.Custom;
	}
}

static function bool GetAllowUpgradeCommand(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_bAllowZedternalUpgradeMenuCommand.Normal;
		case 1 : return default.Game_bAllowZedternalUpgradeMenuCommand.Hard;
		case 2 : return default.Game_bAllowZedternalUpgradeMenuCommand.Suicidal;
		case 3 : return default.Game_bAllowZedternalUpgradeMenuCommand.HoE;
		default: return default.Game_bAllowZedternalUpgradeMenuCommand.Custom;
	}
}

static function bool GetAllowUpgradeCommandAllWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_bZedternalUpgradeMenuCommandAllWave.Normal;
		case 1 : return default.Game_bZedternalUpgradeMenuCommandAllWave.Hard;
		case 2 : return default.Game_bZedternalUpgradeMenuCommandAllWave.Suicidal;
		case 3 : return default.Game_bZedternalUpgradeMenuCommandAllWave.HoE;
		default: return default.Game_bZedternalUpgradeMenuCommandAllWave.Custom;
	}
}

static function int GetTimeBetweenWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_TimeBetweenWave.Normal;
		case 1 : return default.Game_TimeBetweenWave.Hard;
		case 2 : return default.Game_TimeBetweenWave.Suicidal;
		case 3 : return default.Game_TimeBetweenWave.HoE;
		default: return default.Game_TimeBetweenWave.Custom;
	}
}

static function int GetTimeBetweenWaveHumanDied(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_TimeBetweenWaveIfPlayerDead.Normal;
		case 1 : return default.Game_TimeBetweenWaveIfPlayerDead.Hard;
		case 2 : return default.Game_TimeBetweenWaveIfPlayerDead.Suicidal;
		case 3 : return default.Game_TimeBetweenWaveIfPlayerDead.HoE;
		default: return default.Game_TimeBetweenWaveIfPlayerDead.Custom;
	}
}

static function int GetDoshPickupDespawnTime(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_DoshPickupDespawnTime.Normal;
		case 1 : return default.Game_DoshPickupDespawnTime.Hard;
		case 2 : return default.Game_DoshPickupDespawnTime.Suicidal;
		case 3 : return default.Game_DoshPickupDespawnTime.HoE;
		default: return default.Game_DoshPickupDespawnTime.Custom;
	}
}

static function int GetProjectilePickupDespawnTime(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_ProjectilePickupDespawnTime.Normal;
		case 1 : return default.Game_ProjectilePickupDespawnTime.Hard;
		case 2 : return default.Game_ProjectilePickupDespawnTime.Suicidal;
		case 3 : return default.Game_ProjectilePickupDespawnTime.HoE;
		default: return default.Game_ProjectilePickupDespawnTime.Custom;
	}
}

static function int GetWeaponPickupDespawnTime(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_WeaponPickupDespawnTime.Normal;
		case 1 : return default.Game_WeaponPickupDespawnTime.Hard;
		case 2 : return default.Game_WeaponPickupDespawnTime.Suicidal;
		case 3 : return default.Game_WeaponPickupDespawnTime.HoE;
		default: return default.Game_WeaponPickupDespawnTime.Custom;
	}
}

static function bool GetShouldEnableDamageIndicators(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Game_bEnableDamageIndicators.Normal;
		case 1 : return default.Game_bEnableDamageIndicators.Hard;
		case 2 : return default.Game_bEnableDamageIndicators.Suicidal;
		case 3 : return default.Game_bEnableDamageIndicators.HoE;
		default: return default.Game_bEnableDamageIndicators.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_GameOptions"
}
