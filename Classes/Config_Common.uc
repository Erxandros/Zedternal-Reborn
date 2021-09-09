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

static function int GetStructValueInt(const out S_Difficulty_Int StructInt, int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return StructInt.Normal;
		case 1 : return StructInt.Hard;
		case 2 : return StructInt.Suicidal;
		case 3 : return StructInt.HoE;
		default: return StructInt.Custom;
	}
}

static function SetStructValueInt(out S_Difficulty_Int StructInt, int Difficulty, int Value)
{
	switch (Difficulty)
	{
		case 0 : StructInt.Normal = Value; break;
		case 1 : StructInt.Hard = Value; break;
		case 2 : StructInt.Suicidal = Value; break;
		case 3 : StructInt.HoE = Value; break;
		default: StructInt.Custom = Value; break;
	}
}

static function float GetStructValueFloat(const out S_Difficulty_Float StructFloat, int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return StructFloat.Normal;
		case 1 : return StructFloat.Hard;
		case 2 : return StructFloat.Suicidal;
		case 3 : return StructFloat.HoE;
		default: return StructFloat.Custom;
	}
}

static function SetStructValueFloat(out S_Difficulty_Float StructFloat, int Difficulty, float Value)
{
	switch (Difficulty)
	{
		case 0 : StructFloat.Normal = Value; break;
		case 1 : StructFloat.Hard = Value; break;
		case 2 : StructFloat.Suicidal = Value; break;
		case 3 : StructFloat.HoE = Value; break;
		default: StructFloat.Custom = Value; break;
	}
}

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
