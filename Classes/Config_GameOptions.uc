class Config_GameOptions extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config bool Game_bArmorSpawnOnMap;

var config bool Game_bAllowZedTeleport;
var config bool Game_bAllowFastSpawning;

var config bool Game_bAllowZedternalUpgradeMenuCommand;
var config bool Game_bZedternalUpgradeMenuCommandAllWave;

var config S_Difficulty_Int Game_TimeBetweenWave;
var config S_Difficulty_Int Game_TimeBetweenWaveIfPlayerDead;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Game_bArmorSpawnOnMap = True;

		default.Game_bAllowZedTeleport = False;
		default.Game_bAllowFastSpawning = True;

		default.Game_bAllowZedternalUpgradeMenuCommand = False;
		default.Game_bZedternalUpgradeMenuCommandAllWave = False;

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
