class Config_Base extends info
	config(Zedternal);
	
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
	
	`log("Zedternal GameMode Version " $ default.currentVersion);
	
	for (i=0;i<default.ConfigFiles.length;i++)
	{
		default.ConfigFiles[i].static.UpdateConfig();
	}
}

	
defaultproperties
{
	currentVersion = 14
	
	ConfigFiles(0) = class'Zedternal.Config_Game'
	ConfigFiles(1) = class'Zedternal.Config_Difficulty'
	ConfigFiles(2) = class'Zedternal.Config_Waves'
	ConfigFiles(3) = class'Zedternal.Config_Player'
	ConfigFiles(4) = class'Zedternal.Config_Zed'
	ConfigFiles(5) = class'Zedternal.Config_ZedBuff'
	ConfigFiles(6) = class'Zedternal.Config_Weapon'
	ConfigFiles(7) = class'Zedternal.Config_WeaponUpgrade'
	ConfigFiles(8) = class'Zedternal.Config_SpecialWave'
	ConfigFiles(9) = class'Zedternal.Config_PerkUpgrade'
	ConfigFiles(10) = class'Zedternal.Config_SkillUpgrade'
	ConfigFiles(11) = class'Zedternal.Config_WeaponUpgrade'
	ConfigFiles(12) = class'Zedternal.Config_Map'
}