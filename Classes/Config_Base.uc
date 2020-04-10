class Config_Base extends info
	config(ZedternalReborn);
	
var int currentVersion;

var array< class< Config_Base > > ConfigFiles;

struct S_Difficulty_Int
{
	var int Normal;
	var int Hard;
	var int Suicidal;
	var int HoE;
	var int Custom;
};
struct S_Difficulty_Float
{
	var float Normal;
	var float Hard;
	var float Suicidal;
	var float HoE;
	var float Custom;
};

struct S_Length_Int
{
	var int Short;
	var int Normal;
	var int Long;
	var int Custom;
};
struct S_Length_Float
{
	var float Short;
	var float Normal;
	var float Long;
	var float Custom;
};

static function UpdateConfig();

static function CheckDefaultValue()
{
	local byte i;
	
	`log("ZedternalReborn GameMode Version " $ default.currentVersion);
	
	for (i=0;i<default.ConfigFiles.length;i++)
	{
		default.ConfigFiles[i].static.UpdateConfig();
	}
}

	
defaultproperties
{
	currentVersion = 14
	
	ConfigFiles(0) = class'ZedternalReborn.Config_Game'
	ConfigFiles(1) = class'ZedternalReborn.Config_Difficulty'
	ConfigFiles(2) = class'ZedternalReborn.Config_Waves'
	ConfigFiles(3) = class'ZedternalReborn.Config_Player'
	ConfigFiles(4) = class'ZedternalReborn.Config_Zed'
	ConfigFiles(5) = class'ZedternalReborn.Config_ZedBuff'
	ConfigFiles(6) = class'ZedternalReborn.Config_Weapon'
	ConfigFiles(7) = class'ZedternalReborn.Config_WeaponUpgrade'
	ConfigFiles(8) = class'ZedternalReborn.Config_SpecialWave'
	ConfigFiles(9) = class'ZedternalReborn.Config_PerkUpgrade'
	ConfigFiles(10) = class'ZedternalReborn.Config_SkillUpgrade'
	ConfigFiles(11) = class'ZedternalReborn.Config_WeaponUpgrade'
	ConfigFiles(12) = class'ZedternalReborn.Config_Map'
}