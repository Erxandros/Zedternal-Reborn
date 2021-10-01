class Config_SpecialWaveOverride extends Config_Common
	config(ZedternalReborn_Events);

var config int MODEVERSION;

var config S_Difficulty_Bool SpecialWaveOverride_bAllowed;

struct S_SpecialWaveOverride
{
	var int Wave;
	var string FirstPath, SecondPath;
	var float Probability;
};
var config array<S_SpecialWaveOverride> SpecialWaveOverride_SpecialWaves;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.SpecialWaveOverride_bAllowed.Normal = False;
		default.SpecialWaveOverride_bAllowed.Hard = False;
		default.SpecialWaveOverride_bAllowed.Suicidal = False;
		default.SpecialWaveOverride_bAllowed.HoE = False;
		default.SpecialWaveOverride_bAllowed.Custom = False;

		default.SpecialWaveOverride_SpecialWaves.Length = 3;
		default.SpecialWaveOverride_SpecialWaves[0].Wave = 5;
		default.SpecialWaveOverride_SpecialWaves[0].FirstPath = "ZedternalReborn.WMSpecialWave_TheHorde";
		default.SpecialWaveOverride_SpecialWaves[0].SecondPath = "ZedternalReborn.WMSpecialWave_UnlimitedAmmo";
		default.SpecialWaveOverride_SpecialWaves[0].Probability = 0.8f;
		default.SpecialWaveOverride_SpecialWaves[1].Wave = 10;
		default.SpecialWaveOverride_SpecialWaves[1].FirstPath = "ZedternalReborn.WMSpecialWave_Pesticide";
		default.SpecialWaveOverride_SpecialWaves[1].SecondPath = "";
		default.SpecialWaveOverride_SpecialWaves[1].Probability = 0.65f;
		default.SpecialWaveOverride_SpecialWaves[2].Wave = 15;
		default.SpecialWaveOverride_SpecialWaves[2].FirstPath = "ZedternalReborn.WMSpecialWave_Fireworks";
		default.SpecialWaveOverride_SpecialWaves[2].SecondPath = "ZedternalReborn.WMSpecialWave_Chaos";
		default.SpecialWaveOverride_SpecialWaves[2].Probability = 0.4f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i;

	for (i = 0; i < default.SpecialWaveOverride_SpecialWaves.Length; ++i)
	{
		if (default.SpecialWaveOverride_SpecialWaves[i].Wave < 0)
		{
			LogBadConfigMessage("SpecialWaveOverride_SpecialWaves - Line" @ string(i + 1) @ "- Wave",
				string(default.SpecialWaveOverride_SpecialWaves[i].Wave),
				"0", "wave 0, never activated", "value >= 0");
			default.SpecialWaveOverride_SpecialWaves[i].Wave = 0;
		}

		if (default.SpecialWaveOverride_SpecialWaves[i].Probability < 0.0f)
		{
			LogBadConfigMessage("SpecialWaveOverride_SpecialWaves - Line" @ string(i + 1) @ "- Probability",
				string(default.SpecialWaveOverride_SpecialWaves[i].Probability),
				"0.0", "0%, never activates", "1.0 >= value >= 0.0");
			default.SpecialWaveOverride_SpecialWaves[i].Probability = 0.0f;
		}

		if (default.SpecialWaveOverride_SpecialWaves[i].Probability > 1.0f)
		{
			LogBadConfigMessage("SpecialWaveOverride_SpecialWaves - Line" @ string(i + 1) @ "- Probability",
				string(default.SpecialWaveOverride_SpecialWaves[i].Probability),
				"1.0", "100%, always activates", "1.0 >= value >= 0.0");
			default.SpecialWaveOverride_SpecialWaves[i].Probability = 1.0f;
		}

		if (default.SpecialWaveOverride_SpecialWaves[i].SecondPath ~= default.SpecialWaveOverride_SpecialWaves[i].FirstPath)
		{
			`log("ZR Config: SpecialWaveOverride_SpecialWaves - Line" @ string(i + 1) @ "- FirstPath and SecondPath are"
				@ "equal which is an invalid configuration. FirstPath and SecondPath must be unique (no duplicates)."
				@ "Temporarily removing SecondPath.");
			default.SpecialWaveOverride_SpecialWaves[i].SecondPath = "";
		}
	}
}

static function LoadConfigObjects(out array<S_SpecialWaveOverride> ValidWaves, out array< class<WMSpecialWave> > WaveObjects)
{
	local bool First, Second;
	local int i, Ins;
	local class<WMSpecialWave> Obj;

	ValidWaves.Length = 0;
	WaveObjects.Length = 0;

	for (i = 0; i < default.SpecialWaveOverride_SpecialWaves.Length; ++i)
	{
		First = False;
		if (default.SpecialWaveOverride_SpecialWaves[i].FirstPath != "")
		{
			Obj = class<WMSpecialWave>(DynamicLoadObject(default.SpecialWaveOverride_SpecialWaves[i].FirstPath, class'Class', True));
			if (Obj == None)
			{
				LogBadLoadObjectConfigMessage("SpecialWaveOverride_SpecialWaves - FirstPath", i + 1,
					default.SpecialWaveOverride_SpecialWaves[i].FirstPath);
			}
			else
			{
				First = True;

				if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(WaveObjects, PathName(Obj), Ins))
					WaveObjects.InsertItem(Ins, Obj);
			}
		}

		Second = False;
		if (default.SpecialWaveOverride_SpecialWaves[i].SecondPath != "")
		{
			Obj = class<WMSpecialWave>(DynamicLoadObject(default.SpecialWaveOverride_SpecialWaves[i].SecondPath, class'Class', True));
			if (Obj == None)
			{
				LogBadLoadObjectConfigMessage("SpecialWaveOverride_SpecialWaves - SecondPath", i + 1,
					default.SpecialWaveOverride_SpecialWaves[i].SecondPath);
			}
			else
			{
				Second = True;

				if (class'ZedternalReborn.WMBinaryOps'.static.BinarySearchUnique(WaveObjects, PathName(Obj), Ins))
					WaveObjects.InsertItem(Ins, Obj);
			}
		}

		if (First || Second)
		{
			ValidWaves.AddItem(default.SpecialWaveOverride_SpecialWaves[i]);
		}
	}
}

static function bool GetSpecialWaveOverrideAllowed(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.SpecialWaveOverride_bAllowed.Normal;
		case 1 : return default.SpecialWaveOverride_bAllowed.Hard;
		case 2 : return default.SpecialWaveOverride_bAllowed.Suicidal;
		case 3 : return default.SpecialWaveOverride_bAllowed.HoE;
		default: return default.SpecialWaveOverride_bAllowed.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_SpecialWaveOverride"
}
