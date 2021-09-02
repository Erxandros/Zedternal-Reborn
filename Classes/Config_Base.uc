class Config_Base extends Object;

const CurrentVersion = 9;
const CurrentHotfix = 3;

var array< class<Config_Common> > ConfigFiles;

static function LoadConfigs()
{
	local byte i;

	PrintVersion();

	for (i = 0; i < default.ConfigFiles.Length; ++i)
	{
		default.ConfigFiles[i].static.UpdateConfig();
		default.ConfigFiles[i].static.CheckBasicConfigValues();
	}
}

static function PrintVersion()
{
	if (CurrentHotfix == 0)
		`log("ZedternalReborn GameMode Version:" @ CurrentVersion);
	else
		`log("ZedternalReborn GameMode Version:" @ CurrentVersion @ "Hotfix:" @ CurrentHotfix);
}

defaultproperties
{
	//ZedternalReborn_Difficulty
	ConfigFiles(0)=class'ZedternalReborn.Config_Difficulty'
	ConfigFiles(1)=class'ZedternalReborn.Config_DiffOverTime'

	//ZedternalReborn_Events
	ConfigFiles(2)=class'ZedternalReborn.Config_Objective'
	ConfigFiles(3)=class'ZedternalReborn.Config_SpecialWave'
	ConfigFiles(4)=class'ZedternalReborn.Config_SpecialWaveOverride'
	ConfigFiles(5)=class'ZedternalReborn.Config_ZedBuff'

	//ZedternalReborn_Game
	ConfigFiles(6)=class'ZedternalReborn.Config_GameOptions'
	ConfigFiles(7)=class'ZedternalReborn.Config_Dosh'
	ConfigFiles(8)=class'ZedternalReborn.Config_Player'
	ConfigFiles(9)=class'ZedternalReborn.Config_Trader'
	ConfigFiles(10)=class'ZedternalReborn.Config_TraderVoice'
	ConfigFiles(11)=class'ZedternalReborn.Config_Map'

	//ZedternalReborn_Upgrades
	ConfigFiles(12)=class'ZedternalReborn.Config_PerkUpgrade'
	ConfigFiles(13)=class'ZedternalReborn.Config_PerkUpgradeOptions'
	ConfigFiles(14)=class'ZedternalReborn.Config_SkillReroll'
	ConfigFiles(15)=class'ZedternalReborn.Config_SkillUpgrade'
	ConfigFiles(16)=class'ZedternalReborn.Config_SkillUpgradeOptions'
	ConfigFiles(17)=class'ZedternalReborn.Config_WeaponUpgrade'
	ConfigFiles(18)=class'ZedternalReborn.Config_WeaponUpgradeOptions'
	ConfigFiles(19)=class'ZedternalReborn.Config_EquipmentUpgrade'

	//ZedternalReborn_Weapons
	ConfigFiles(20)=class'ZedternalReborn.Config_WeaponStarting'
	ConfigFiles(21)=class'ZedternalReborn.Config_WeaponGrenade'
	ConfigFiles(22)=class'ZedternalReborn.Config_WeaponStatic'
	ConfigFiles(23)=class'ZedternalReborn.Config_WeaponCustom'
	ConfigFiles(24)=class'ZedternalReborn.Config_WeaponVariant'

	//ZedternalReborn_ZedWaves
	ConfigFiles(25)=class'ZedternalReborn.Config_WaveOptions'
	ConfigFiles(26)=class'ZedternalReborn.Config_WaveValue'
	ConfigFiles(27)=class'ZedternalReborn.Config_WaveSpawnRate'
	ConfigFiles(28)=class'ZedternalReborn.Config_Zed'
	ConfigFiles(29)=class'ZedternalReborn.Config_ZedValue'
	ConfigFiles(30)=class'ZedternalReborn.Config_ZedVariant'
	ConfigFiles(31)=class'ZedternalReborn.Config_ZedInject'

	Name="Default__Config_Base"
}
