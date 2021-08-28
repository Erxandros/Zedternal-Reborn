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
		default.ConfigFiles[i].static.CheckConfigValues();
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
	//ZedternalReborn_Game
	ConfigFiles(0)=class'ZedternalReborn.Config_GameOptions'
	ConfigFiles(1)=class'ZedternalReborn.Config_Dosh'
	ConfigFiles(2)=class'ZedternalReborn.Config_Trader'
	ConfigFiles(3)=class'ZedternalReborn.Config_TraderVoice'
	ConfigFiles(4)=class'ZedternalReborn.Config_Map'

	//ZedternalReborn_Difficulty
	ConfigFiles(5)=class'ZedternalReborn.Config_Difficulty'
	ConfigFiles(6)=class'ZedternalReborn.Config_DiffOverTime'

	ConfigFiles(7)=class'ZedternalReborn.Config_Waves'
	ConfigFiles(8)=class'ZedternalReborn.Config_Player'
	ConfigFiles(9)=class'ZedternalReborn.Config_Zed'
	ConfigFiles(10)=class'ZedternalReborn.Config_ZedBuff'
	ConfigFiles(11)=class'ZedternalReborn.Config_Weapon'
	ConfigFiles(12)=class'ZedternalReborn.Config_SpecialWave'

	//ZedternalReborn_Upgrades
	ConfigFiles(13)=class'ZedternalReborn.Config_PerkUpgrade'
	ConfigFiles(14)=class'ZedternalReborn.Config_PerkUpgradeOptions'
	ConfigFiles(15)=class'ZedternalReborn.Config_SkillReroll'
	ConfigFiles(16)=class'ZedternalReborn.Config_SkillUpgrade'
	ConfigFiles(17)=class'ZedternalReborn.Config_SkillUpgradeOptions'
	ConfigFiles(18)=class'ZedternalReborn.Config_WeaponUpgrade'
	ConfigFiles(19)=class'ZedternalReborn.Config_WeaponUpgradeOptions'
	ConfigFiles(20)=class'ZedternalReborn.Config_EquipmentUpgrade'

	ConfigFiles(21)=class'ZedternalReborn.Config_Objective'

	Name="Default__Config_Base"
}
