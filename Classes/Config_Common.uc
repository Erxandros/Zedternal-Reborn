class Config_Common extends Object;

const NumberOfDiffs = 5;

struct S_Difficulty_Bool
{
	var bool Normal;
	var bool Hard;
	var bool Suicidal;
	var bool HoE;
	var bool Custom;
};

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

static function bool GetStructValueBool(const out S_Difficulty_Bool StructBool, int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return StructBool.Normal;
		case 1 : return StructBool.Hard;
		case 2 : return StructBool.Suicidal;
		case 3 : return StructBool.HoE;
		default: return StructBool.Custom;
	}
}

static function SetStructValueBool(out S_Difficulty_Bool StructBool, int Difficulty, bool Value)
{
	switch (Difficulty)
	{
		case 0 : StructBool.Normal = Value; break;
		case 1 : StructBool.Hard = Value; break;
		case 2 : StructBool.Suicidal = Value; break;
		case 3 : StructBool.HoE = Value; break;
		default: StructBool.Custom = Value; break;
	}
}

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

static function string GetSignString(int Sign)
{
	switch (Sign)
	{
		case 0 : return "greater than or equal to";
		case 1 : return "lesser than or equal to";
		case 2 : return "greater than";
		case 3 : return "lesser than";
		default: return "equal to";
	}
}

static function LogBadStructConfigMessage(int Difficulty, string Description, string DataType, string OriginalData,
	string CorrectData, string CorrectDataFormatted, string ConfigVariableName, int Sign)
{
	`log("ZR Config:" @Description @"at difficulty" @GetDiffString(Difficulty)
		@"is set to" @OriginalData @"which is not supported."
		@"Setting the" @DataType @"to the value of" @CorrectData @"(" $CorrectDataFormatted $") temporarily."
		@"Please change the value in the config," @ConfigVariableName $", to a value" @GetSignString(Sign) @CorrectData);
}

defaultproperties
{
	Name="Default__Config_Common"
}
