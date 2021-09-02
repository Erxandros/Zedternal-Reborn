class Config_Common extends Object;

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

static function UpdateConfig();
static function CheckBasicConfigValues();

defaultproperties
{
	Name="Default__Config_Common"
}
