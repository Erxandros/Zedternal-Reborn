class Config_GameOptions extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Bool Game_bArmorSpawnOnMap;

var config S_Difficulty_Bool Game_bAllowZedternalUpgradeMenuCommand;
var config S_Difficulty_Bool Game_bZedternalUpgradeMenuCommandAllWave;

var config S_Difficulty_Int Game_TimeBetweenWave;
var config S_Difficulty_Int Game_TimeBetweenWaveIfPlayerDead;

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

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
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

defaultproperties
{
	Name="Default__Config_GameOptions"
}
