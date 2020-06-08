class Config_Weapon extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

var config int Trader_MaxWeapon;								// maximum number of weapons available in the trader per game
var config int Trader_StartingWeaponNumber;						// number of weapon in trader at wave 1->2
var config int Trader_NewWeaponEachWave;						// number of weapon added in the trader each wave
var config int Weapon_PlayerStartingWeaponNumber;				// player spawn with this number of weapon (ex: if 2, then players could spawn with a shovel and ar-15)
var config array< string > Trader_StaticWeaponDefs;				// weapon that will always be in the trader
var config array< string > Trader_GrenadesDef;					// grenade avaiable in the trader
var config array< string > Weapon_PlayerStartingWeaponDefList;	// players spawn with one or more of these weapon

var config bool Weapon_bUseCustomWeaponList;					// should we add custom weapon to the trader?
var config array< string > Weapon_CustomWeaponDef;				// definitions of custom weapon (ex : custom weapon from workshop)

struct S_Variant
{
	var string WeaponDef;
	var string WeaponDefVariant;
	var string DualWeaponDefVariant;
	var float Probability;
};

//// weapon variation (replacement) ////
// it is possible to set replacement of weapon.
// for exemple, we want to add in game a M79 medic weapon (that shoot medical grenade instead of explosive round)
// we can then decide to replace the original one with our medic one (with a probability between 0 and 1)
var config bool WeaponVariant_bAllowWeaponVariant;			// allow weapon variations (replacement)?
var config array< S_Variant > WeaponVariant_VariantList;	// here, we can configure weapon replacement. 

static function UpdateConfig()
{
	local int i;
	local S_Variant newVariant;

	if (default.MODEVERSION < 1)
	{
		default.Trader_MaxWeapon = 24;
		default.Trader_StartingWeaponNumber = 3;
		default.Trader_NewWeaponEachWave = 2;
		default.Weapon_PlayerStartingWeaponNumber = 1;

		default.Trader_StaticWeaponDefs.length = 2;
		default.Trader_StaticWeaponDefs[0] = "KFGame.KFWeapDef_MedicPistol";
		default.Trader_StaticWeaponDefs[1] = "KFGame.KFWeapDef_9mm";

		default.Trader_GrenadesDef.length = 9;
		default.Trader_GrenadesDef[0] = "KFGame.KFWeapDef_Grenade_Berserker";
		default.Trader_GrenadesDef[1] = "KFGame.KFWeapDef_Grenade_Commando";
		default.Trader_GrenadesDef[2] = "KFGame.KFWeapDef_Grenade_Demo";
		default.Trader_GrenadesDef[3] = "KFGame.KFWeapDef_Grenade_Firebug";
		default.Trader_GrenadesDef[4] = "KFGame.KFWeapDef_Grenade_Medic";
		default.Trader_GrenadesDef[5] = "KFGame.KFWeapDef_Grenade_Gunslinger";
		default.Trader_GrenadesDef[6] = "KFGame.KFWeapDef_Grenade_Sharpshooter";
		default.Trader_GrenadesDef[7] = "KFGame.KFWeapDef_Grenade_Support";
		default.Trader_GrenadesDef[8] = "KFGame.KFWeapDef_Grenade_SWAT";

		default.Weapon_PlayerStartingWeaponDefList.length = 8;
		default.Weapon_PlayerStartingWeaponDefList[0]="KFGame.KFWeapDef_AR15";
		default.Weapon_PlayerStartingWeaponDefList[1]="KFGame.KFWeapDef_MB500";
		default.Weapon_PlayerStartingWeaponDefList[2]="KFGame.KFWeapDef_Crovel";
		default.Weapon_PlayerStartingWeaponDefList[3]="KFGame.KFWeapDef_HX25";
		default.Weapon_PlayerStartingWeaponDefList[4]="KFGame.KFWeapDef_CaulkBurn";
		default.Weapon_PlayerStartingWeaponDefList[5]="KFGame.KFWeapDef_Remington1858";
		default.Weapon_PlayerStartingWeaponDefList[6]="KFGame.KFWeapDef_Winchester1894";
		default.Weapon_PlayerStartingWeaponDefList[7]="KFGame.KFWeapDef_MP7";
		default.Weapon_bUseCustomWeaponList = false;
		default.Weapon_CustomWeaponDef.length = 1;
		default.Weapon_CustomWeaponDef[0] = "Class.Weapon_Definition_Example";

		default.WeaponVariant_bAllowWeaponVariant = true;		

		default.WeaponVariant_VariantList.length = 43;
		default.WeaponVariant_VariantList[0].WeaponDef = "KFGame.KFWeapDef_Bullpup";
		default.WeaponVariant_VariantList[0].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Bullpup_Precious";
		default.WeaponVariant_VariantList[1].WeaponDef = "KFGame.KFWeapDef_AK12";
		default.WeaponVariant_VariantList[1].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AK12_Precious";
		default.WeaponVariant_VariantList[2].WeaponDef = "KFGame.KFWeapDef_SCAR";
		default.WeaponVariant_VariantList[2].WeaponDefVariant = "ZedternalReborn.WMWeapDef_SCAR_Precious";
		default.WeaponVariant_VariantList[3].WeaponDef = "KFGame.KFWeapDef_Stoner63A";
		default.WeaponVariant_VariantList[3].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Stoner63A_Precious";
		default.WeaponVariant_VariantList[4].WeaponDef = "KFGame.KFWeapDef_MP5RAS";
		default.WeaponVariant_VariantList[4].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MP5RAS_Precious";
		default.WeaponVariant_VariantList[5].WeaponDef = "KFGame.KFWeapDef_P90";
		default.WeaponVariant_VariantList[5].WeaponDefVariant = "ZedternalReborn.WMWeapDef_P90_Precious";
		default.WeaponVariant_VariantList[6].WeaponDef = "KFGame.KFWeapDef_HK_UMP";
		default.WeaponVariant_VariantList[6].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HK_UMP_Precious";
		default.WeaponVariant_VariantList[7].WeaponDef = "KFGame.KFWeapDef_Kriss";
		default.WeaponVariant_VariantList[7].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Kriss_Precious";
		default.WeaponVariant_VariantList[8].WeaponDef = "KFGame.KFWeapDef_Katana";
		default.WeaponVariant_VariantList[8].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Katana_Precious";
		default.WeaponVariant_VariantList[9].WeaponDef = "KFGame.KFWeapDef_Nailgun";
		default.WeaponVariant_VariantList[9].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Nailgun_Precious";
		default.WeaponVariant_VariantList[10].WeaponDef = "KFGame.KFWeapDef_Zweihander";
		default.WeaponVariant_VariantList[10].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Zweihander_Precious";
		default.WeaponVariant_VariantList[11].WeaponDef = "KFGame.KFWeapDef_Pulverizer";
		default.WeaponVariant_VariantList[11].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Pulverizer_Precious";
		default.WeaponVariant_VariantList[12].WeaponDef = "KFGame.KFWeapDef_MaceAndShield";
		default.WeaponVariant_VariantList[12].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MaceAndShield_Precious";
		default.WeaponVariant_VariantList[13].WeaponDef = "KFGame.KFWeapDef_Eviscerator";
		default.WeaponVariant_VariantList[13].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Eviscerator_Precious";
		default.WeaponVariant_VariantList[14].WeaponDef = "KFGame.KFWeapDef_DoubleBarrel";
		default.WeaponVariant_VariantList[14].WeaponDefVariant = "ZedternalReborn.WMWeapDef_DoubleBarrel_Precious";
		default.WeaponVariant_VariantList[15].WeaponDef = "KFGame.KFWeapDef_HZ12";
		default.WeaponVariant_VariantList[15].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HZ12_Precious";
		default.WeaponVariant_VariantList[16].WeaponDef = "KFGame.KFWeapDef_M4";
		default.WeaponVariant_VariantList[16].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M4_Precious";
		default.WeaponVariant_VariantList[17].WeaponDef = "KFGame.KFWeapDef_AA12";
		default.WeaponVariant_VariantList[17].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AA12_Precious";
		default.WeaponVariant_VariantList[18].WeaponDef = "KFGame.KFWeapDef_Crossbow";
		default.WeaponVariant_VariantList[18].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Crossbow_Precious";
		default.WeaponVariant_VariantList[19].WeaponDef = "KFGame.KFWeapDef_M14EBR";
		default.WeaponVariant_VariantList[19].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M14EBR_Precious";
		default.WeaponVariant_VariantList[20].WeaponDef = "KFGame.KFWeapDef_Railgun";
		default.WeaponVariant_VariantList[20].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Railgun_Precious";
		default.WeaponVariant_VariantList[21].WeaponDef = "KFGame.KFWeapDef_CaulkBurn";
		default.WeaponVariant_VariantList[21].WeaponDefVariant = "ZedternalReborn.WMWeapDef_CaulkBurn_Precious";
		default.WeaponVariant_VariantList[22].WeaponDef = "KFGame.KFWeapDef_DragonsBreath";
		default.WeaponVariant_VariantList[22].WeaponDefVariant = "ZedternalReborn.WMWeapDef_DragonsBreath_Precious";
		default.WeaponVariant_VariantList[23].WeaponDef = "KFGame.KFWeapDef_Flamethrower";
		default.WeaponVariant_VariantList[23].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Flamethrower_Precious";
		default.WeaponVariant_VariantList[24].WeaponDef = "KFGame.KFWeapDef_MicrowaveGun";
		default.WeaponVariant_VariantList[24].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MicrowaveGun_Precious";
		default.WeaponVariant_VariantList[25].WeaponDef = "KFGame.KFWeapDef_HuskCannon";
		default.WeaponVariant_VariantList[25].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HuskCannon_Precious";
		default.WeaponVariant_VariantList[26].WeaponDef = "KFGame.KFWeapDef_MedicSMG";
		default.WeaponVariant_VariantList[26].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicSMG_Precious";
		default.WeaponVariant_VariantList[27].WeaponDef = "KFGame.KFWeapDef_MedicShotgun";
		default.WeaponVariant_VariantList[27].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicShotgun_Precious";
		default.WeaponVariant_VariantList[28].WeaponDef = "KFGame.KFWeapDef_Hemogoblin";
		default.WeaponVariant_VariantList[28].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Hemogoblin_Precious";
		default.WeaponVariant_VariantList[29].WeaponDef = "KFGame.KFWeapDef_MedicRifle";
		default.WeaponVariant_VariantList[29].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicRifle_Precious";
		default.WeaponVariant_VariantList[30].WeaponDef = "KFGame.KFWeapDef_M79";
		default.WeaponVariant_VariantList[30].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M79_Precious";
		default.WeaponVariant_VariantList[31].WeaponDef = "KFGame.KFWeapDef_C4";
		default.WeaponVariant_VariantList[31].WeaponDefVariant = "ZedternalReborn.WMWeapDef_C4_Precious";
		default.WeaponVariant_VariantList[32].WeaponDef = "KFGame.KFWeapDef_M16M203";
		default.WeaponVariant_VariantList[32].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M16M203_Precious";
		default.WeaponVariant_VariantList[33].WeaponDef = "KFGame.KFWeapDef_RPG7";
		default.WeaponVariant_VariantList[33].WeaponDefVariant = "ZedternalReborn.WMWeapDef_RPG7_Precious";
		default.WeaponVariant_VariantList[34].WeaponDef = "KFGame.KFWeapDef_Seeker6";
		default.WeaponVariant_VariantList[34].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Seeker6_Precious";
		default.WeaponVariant_VariantList[35].WeaponDef = "KFGame.KFWeapDef_Mac10";
		default.WeaponVariant_VariantList[35].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Mac10_Precious";
		default.WeaponVariant_VariantList[36].WeaponDef = "KFGame.KFWeapDef_CenterfireMB464";
		default.WeaponVariant_VariantList[36].WeaponDefVariant = "ZedternalReborn.WMWeapDef_CenterfireMB464_Precious";
		default.WeaponVariant_VariantList[37].WeaponDef = "KFGame.KFWeapDef_FreezeThrower";
		default.WeaponVariant_VariantList[37].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FreezeThrower_Precious";

		for (i = 0; i <= 37; i++)
		{
			default.WeaponVariant_VariantList[i].DualWeaponDefVariant = "";
		}

		default.WeaponVariant_VariantList[38].WeaponDef = "KFGame.KFWeapDef_FlareGun";
		default.WeaponVariant_VariantList[38].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FlareGun_Precious";
		default.WeaponVariant_VariantList[38].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_FlareGunDual_Precious";
		default.WeaponVariant_VariantList[39].WeaponDef = "KFGame.KFWeapDef_Colt1911";
		default.WeaponVariant_VariantList[39].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Colt1911_Precious";
		default.WeaponVariant_VariantList[39].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_Colt1911Dual_Precious";
		default.WeaponVariant_VariantList[40].WeaponDef = "KFGame.KFWeapDef_Deagle";
		default.WeaponVariant_VariantList[40].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Deagle_Precious";
		default.WeaponVariant_VariantList[40].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_DeagleDual_Precious";
		default.WeaponVariant_VariantList[41].WeaponDef = "KFGame.KFWeapDef_SW500";
		default.WeaponVariant_VariantList[41].WeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500_Precious";
		default.WeaponVariant_VariantList[41].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500Dual_Precious";
		default.WeaponVariant_VariantList[42].WeaponDef = "KFGame.KFWeapDef_AF2011";
		default.WeaponVariant_VariantList[42].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AF2011_Precious";
		default.WeaponVariant_VariantList[42].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_AF2011Dual_Precious";

		for (i = 0; i <= 42; i++)
		{
			default.WeaponVariant_VariantList[i].Probability = 0.017500;
		}
	}

	if (default.MODEVERSION < 2)
	{
		//Fix FlameThrower
		i = default.WeaponVariant_VariantList.Find('WeaponDef', "KFGame.KFWeapDef_Flamethrower");
		if (i != -1)
		{
			default.WeaponVariant_VariantList[i].WeaponDef = "KFGame.KFWeapDef_FlameThrower";
			default.WeaponVariant_VariantList[i].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FlameThrower_Precious";
		}

		//Fix RailGun
		i = default.WeaponVariant_VariantList.Find('WeaponDef', "KFGame.KFWeapDef_Railgun");
		if (i != -1)
		{
			default.WeaponVariant_VariantList[i].WeaponDef = "KFGame.KFWeapDef_RailGun";
			default.WeaponVariant_VariantList[i].WeaponDefVariant = "ZedternalReborn.WMWeapDef_RailGun_Precious";
		}

		i = default.WeaponVariant_VariantList.length;

		//Add new precious weapons
		newVariant.WeaponDef = "KFGame.KFWeapDef_MedicPistol";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicPistol_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_AR15";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_AR15_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_Thompson";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_Thompson_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_MKB42";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MKB42_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_FNFal";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_FNFal_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_Crovel";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_Crovel_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_ChainBat";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_ChainBat_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_FireAxe";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_FireAxe_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_MedicBat";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicBat_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_PowerGloves";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_PowerGloves_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_IonThruster";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_IonThruster_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_AbominationAxe";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_AbominationAxe_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_MB500";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MB500_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_ElephantGun";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_ElephantGun_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_SW500_HRG";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500_HRG_Precious";
		newVariant.DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500Dual_HRG_Precious";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_Healthrower_HRG";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_Healthrower_HRG_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_HRGIncision";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGIncision_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_MedicRifleGrenadeLauncher";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicRifleGrenadeLauncher_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_HX25";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_HX25_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_SealSqueal";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_SealSqueal_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_M32";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_M32_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_HRGIncendiaryRifle";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGIncendiaryRifle_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_MicrowaveRifle";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MicrowaveRifle_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_Remington1858";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_Remington1858_Precious";
		newVariant.DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_Remington1858Dual_Precious";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_ChiappaRhino";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_ChiappaRhino_Precious";
		newVariant.DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_ChiappaRhinoDual_Precious";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_HRGWinterbite";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGWinterbite_Precious";
		newVariant.DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGWinterbiteDual_Precious";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_Winchester1894";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_Winchester1894_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_MosinNagant";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MosinNagant_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_CompoundBow";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_CompoundBow_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_M99";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_M99_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_MP7";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_MP7_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_Nailgun_HRG";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_Nailgun_HRG_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_G18";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_G18_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		newVariant.WeaponDef = "KFGame.KFWeapDef_LazerCutter";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_LazerCutter_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		for (i = i; i < default.WeaponVariant_VariantList.length; i++)
		{
			default.WeaponVariant_VariantList[i].Probability = 0.017500;
		}
	}

	if (default.MODEVERSION < 3)
	{
		//Changed single 1858 to dual 1858
		i = default.Weapon_PlayerStartingWeaponDefList.Find("KFGame.KFWeapDef_Remington1858");
		if (i != -1)
		{
			default.Weapon_PlayerStartingWeaponDefList[i] = "KFGame.KFWeapDef_Remington1858Dual";
		}

		i = default.WeaponVariant_VariantList.length;

		newVariant.WeaponDef = "KFGame.KFWeapDef_HRG_Kaboomstick";
		newVariant.WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRG_Kaboomstick_Precious";
		newVariant.DualWeaponDefVariant = "";
		default.WeaponVariant_VariantList.AddItem(newVariant);

		for (i = i; i < default.WeaponVariant_VariantList.length; ++i)
		{
			default.WeaponVariant_VariantList[i].Probability = 0.017500;
		}
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
}