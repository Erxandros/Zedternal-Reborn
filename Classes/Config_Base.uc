class Config_Base extends Object;

const CurrentVersion = 15;
const CurrentHotfix = 0;

var array< class<Config_Common> > ConfigFiles;

static function LoadConfigs()
{
	local byte i;

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
	ConfigFiles(0)=class'ZedternalReborn.Config_DifficultyNormal'
	ConfigFiles(1)=class'ZedternalReborn.Config_DifficultyLarge'
	ConfigFiles(2)=class'ZedternalReborn.Config_DifficultyOmega'
	ConfigFiles(3)=class'ZedternalReborn.Config_DiffOverTime'
	ConfigFiles(4)=class'ZedternalReborn.Config_DifficultyGroup'
	ConfigFiles(5)=class'ZedternalReborn.Config_DifficultyGroupHealth'
	ConfigFiles(6)=class'ZedternalReborn.Config_DifficultyGroupHealthExtra'
	ConfigFiles(7)=class'ZedternalReborn.Config_DifficultyGroupHeadHealth'
	ConfigFiles(8)=class'ZedternalReborn.Config_DifficultyGroupDamage'
	ConfigFiles(9)=class'ZedternalReborn.Config_DifficultyGroupSoloDamage'
	ConfigFiles(10)=class'ZedternalReborn.Config_DifficultyGroupSpeed'

	//ZedternalReborn_Events
	ConfigFiles(11)=class'ZedternalReborn.Config_Objective'
	ConfigFiles(12)=class'ZedternalReborn.Config_SpecialWave'
	ConfigFiles(13)=class'ZedternalReborn.Config_SpecialWaveOverride'
	ConfigFiles(14)=class'ZedternalReborn.Config_ZedBuff'

	//ZedternalReborn_Game
	ConfigFiles(15)=class'ZedternalReborn.Config_GameOptions'
	ConfigFiles(16)=class'ZedternalReborn.Config_Dosh'
	ConfigFiles(17)=class'ZedternalReborn.Config_Player'
	ConfigFiles(18)=class'ZedternalReborn.Config_Trader'
	ConfigFiles(19)=class'ZedternalReborn.Config_TraderVoice'
	ConfigFiles(20)=class'ZedternalReborn.Config_Map'

	//ZedternalReborn_Upgrades
	ConfigFiles(21)=class'ZedternalReborn.Config_PerkUpgrade'
	ConfigFiles(22)=class'ZedternalReborn.Config_PerkUpgradeOptions'
	ConfigFiles(23)=class'ZedternalReborn.Config_SkillReroll'
	ConfigFiles(24)=class'ZedternalReborn.Config_SkillUpgrade'
	ConfigFiles(25)=class'ZedternalReborn.Config_SkillUpgradeOptions'
	ConfigFiles(26)=class'ZedternalReborn.Config_WeaponUpgrade'
	ConfigFiles(27)=class'ZedternalReborn.Config_WeaponUpgradeOptions'
	ConfigFiles(28)=class'ZedternalReborn.Config_EquipmentUpgrade'

	//ZedternalReborn_Weapons
	ConfigFiles(29)=class'ZedternalReborn.Config_WeaponStarting'
	ConfigFiles(30)=class'ZedternalReborn.Config_WeaponGrenade'
	ConfigFiles(31)=class'ZedternalReborn.Config_WeaponStatic'
	ConfigFiles(32)=class'ZedternalReborn.Config_WeaponCustom'
	ConfigFiles(33)=class'ZedternalReborn.Config_WeaponVariant'
	ConfigFiles(34)=class'ZedternalReborn.Config_WeaponDisable'

	//ZedternalReborn_ZedWaves
	ConfigFiles(35)=class'ZedternalReborn.Config_WaveOptions'
	ConfigFiles(36)=class'ZedternalReborn.Config_WaveValue'
	ConfigFiles(37)=class'ZedternalReborn.Config_WaveSpawnRate'
	ConfigFiles(38)=class'ZedternalReborn.Config_Zed'
	ConfigFiles(39)=class'ZedternalReborn.Config_ZedValue'
	ConfigFiles(40)=class'ZedternalReborn.Config_ZedVariant'
	ConfigFiles(41)=class'ZedternalReborn.Config_ZedInject'

	Name="Default__Config_Base"
}
