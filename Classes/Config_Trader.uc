class Config_Trader extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Int Trader_MaxWeapon;
var config S_Difficulty_Int Trader_StartingWeaponNumber;
var config S_Difficulty_Int Trader_NewWeaponEachWave;

var config S_Difficulty_Float Trader_AmmoPriceFactor;
var config S_Difficulty_Int Trader_ArmorPrice;
var config S_Difficulty_Int Trader_GrenadePrice;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Trader_MaxWeapon.Normal = 48;
		default.Trader_MaxWeapon.Hard = 44;
		default.Trader_MaxWeapon.Suicidal = 40;
		default.Trader_MaxWeapon.HoE = 36;
		default.Trader_MaxWeapon.Custom = 36;

		default.Trader_StartingWeaponNumber.Normal = 3;
		default.Trader_StartingWeaponNumber.Hard = 3;
		default.Trader_StartingWeaponNumber.Suicidal = 3;
		default.Trader_StartingWeaponNumber.HoE = 3;
		default.Trader_StartingWeaponNumber.Custom = 3;

		default.Trader_NewWeaponEachWave.Normal = 4;
		default.Trader_NewWeaponEachWave.Hard = 3;
		default.Trader_NewWeaponEachWave.Suicidal = 3;
		default.Trader_NewWeaponEachWave.HoE = 2;
		default.Trader_NewWeaponEachWave.Custom = 2;

		default.Trader_AmmoPriceFactor.Normal = 0.7f;
		default.Trader_AmmoPriceFactor.Hard = 0.7f;
		default.Trader_AmmoPriceFactor.Suicidal = 0.75f;
		default.Trader_AmmoPriceFactor.HoE = 0.8f;
		default.Trader_AmmoPriceFactor.Custom = 0.8f;

		default.Trader_ArmorPrice.Normal = 2;
		default.Trader_ArmorPrice.Hard = 2;
		default.Trader_ArmorPrice.Suicidal = 2;
		default.Trader_ArmorPrice.HoE = 2;
		default.Trader_ArmorPrice.Custom = 2;

		default.Trader_GrenadePrice.Normal = 40;
		default.Trader_GrenadePrice.Hard = 40;
		default.Trader_GrenadePrice.Suicidal = 40;
		default.Trader_GrenadePrice.HoE = 40;
		default.Trader_GrenadePrice.Custom = 40;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local byte i;

	for (i = 0; i < NumberOfDiffs; ++i)
	{
		if (GetStructValueInt(default.Trader_MaxWeapon, i) < 0)
		{
			LogBadStructConfigMessage(i, "Trader max weapons", "amount of weapons",
				string(GetStructValueInt(default.Trader_MaxWeapon, i)),
				"0", "0 max weapons", "Trader_MaxWeapon", 0);
			SetStructValueInt(default.Trader_MaxWeapon, i, 0);
		}

		if (GetStructValueInt(default.Trader_StartingWeaponNumber, i) < 0)
		{
			LogBadStructConfigMessage(i, "Trader starting weapons", "amount of weapons",
				string(GetStructValueInt(default.Trader_StartingWeaponNumber, i)),
				"0", "0 starting weapons", "Trader_StartingWeaponNumber", 0);
			SetStructValueInt(default.Trader_StartingWeaponNumber, i, 0);
		}

		if (GetStructValueInt(default.Trader_NewWeaponEachWave, i) < 0)
		{
			LogBadStructConfigMessage(i, "Trader new weapons each wave", "amount of weapons",
				string(GetStructValueInt(default.Trader_NewWeaponEachWave, i)),
				"0", "0 new weapons each wave", "Trader_NewWeaponEachWave", 0);
			SetStructValueInt(default.Trader_NewWeaponEachWave, i, 0);
		}

		if (GetStructValueFloat(default.Trader_AmmoPriceFactor, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Trader ammo price factor", "factor",
				string(GetStructValueFloat(default.Trader_AmmoPriceFactor, i)),
				"0.0", "0%, free ammo", "Trader_AmmoPriceFactor", 0);
			SetStructValueFloat(default.Trader_AmmoPriceFactor, i, 0.0f);
		}

		if (GetStructValueInt(default.Trader_ArmorPrice, i) < 0)
		{
			LogBadStructConfigMessage(i, "Trader armor price per percent", "armor price",
				string(GetStructValueInt(default.Trader_ArmorPrice, i)),
				"0", "0 dosh per percent, free armor", "Trader_ArmorPrice", 0);
			SetStructValueInt(default.Trader_ArmorPrice, i, 0);
		}

		if (GetStructValueInt(default.Trader_GrenadePrice, i) < 0)
		{
			LogBadStructConfigMessage(i, "Trader grenade price", "grenade price",
				string(GetStructValueInt(default.Trader_GrenadePrice, i)),
				"0", "0 dosh, free grenades", "Trader_GrenadePrice", 0);
			SetStructValueInt(default.Trader_GrenadePrice, i, 0);
		}
	}
}

static function int GetMaxWeapon(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Trader_MaxWeapon.Normal;
		case 1 : return default.Trader_MaxWeapon.Hard;
		case 2 : return default.Trader_MaxWeapon.Suicidal;
		case 3 : return default.Trader_MaxWeapon.HoE;
		default: return default.Trader_MaxWeapon.Custom;
	}
}

static function int GetStartingWeaponNumber(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Trader_StartingWeaponNumber.Normal;
		case 1 : return default.Trader_StartingWeaponNumber.Hard;
		case 2 : return default.Trader_StartingWeaponNumber.Suicidal;
		case 3 : return default.Trader_StartingWeaponNumber.HoE;
		default: return default.Trader_StartingWeaponNumber.Custom;
	}
}

static function int GetNewWeaponEachWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Trader_NewWeaponEachWave.Normal;
		case 1 : return default.Trader_NewWeaponEachWave.Hard;
		case 2 : return default.Trader_NewWeaponEachWave.Suicidal;
		case 3 : return default.Trader_NewWeaponEachWave.HoE;
		default: return default.Trader_NewWeaponEachWave.Custom;
	}
}

static function float GetAmmoPriceFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Trader_AmmoPriceFactor.Normal;
		case 1 : return default.Trader_AmmoPriceFactor.Hard;
		case 2 : return default.Trader_AmmoPriceFactor.Suicidal;
		case 3 : return default.Trader_AmmoPriceFactor.HoE;
		default: return default.Trader_AmmoPriceFactor.Custom;
	}
}

static function int GetArmorPrice(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Trader_ArmorPrice.Normal;
		case 1 : return default.Trader_ArmorPrice.Hard;
		case 2 : return default.Trader_ArmorPrice.Suicidal;
		case 3 : return default.Trader_ArmorPrice.HoE;
		default: return default.Trader_ArmorPrice.Custom;
	}
}

static function int GetGrenadePrice(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Trader_GrenadePrice.Normal;
		case 1 : return default.Trader_GrenadePrice.Hard;
		case 2 : return default.Trader_GrenadePrice.Suicidal;
		case 3 : return default.Trader_GrenadePrice.HoE;
		default: return default.Trader_GrenadePrice.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Trader"
}
