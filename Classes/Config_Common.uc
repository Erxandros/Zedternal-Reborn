class Config_Common extends Object;

const NumberOfDiffs = 5;

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

static function string GetDiffString(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return "Normal";
		case 1 : return "Hard";
		case 2 : return "Suicidal";
		case 3 : return "HoE";
		default: return "Custom";
	}
}

defaultproperties
{
	Name="Default__Config_Common"
}
