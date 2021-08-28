class Config_Trader extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config int Trader_MaxWeapon;
var config int Trader_StartingWeaponNumber;
var config int Trader_NewWeaponEachWave;

var config S_Difficulty_Float Trader_AmmoPriceFactor;
var config S_Difficulty_Int Trader_ArmorPrice;
var config S_Difficulty_Int Trader_GrenadePrice;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Trader_MaxWeapon = 48;
		default.Trader_StartingWeaponNumber = 3;
		default.Trader_NewWeaponEachWave = 3;

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
