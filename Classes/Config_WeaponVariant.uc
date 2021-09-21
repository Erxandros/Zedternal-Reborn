class Config_WeaponVariant extends Config_Common
	config(ZedternalReborn_Weapons);

var config int MODEVERSION;

var config bool WeaponVariant_bAllowWeaponVariant; //Allow weapon variants

struct S_Variant
{
	var string WeaponDef;
	var string WeaponDefVariant;
	var string DualWeaponDefVariant;
	var float Probability;

	structdefaultproperties
	{
		DualWeaponDefVariant=""
		Probability=0.05f
	}
};
var config array<S_Variant> Weapon_VariantWeaponDef; //List of weapon variants

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.WeaponVariant_bAllowWeaponVariant = True;

		default.Weapon_VariantWeaponDef.Length = 93;
		default.Weapon_VariantWeaponDef[0].WeaponDef = "KFGame.KFWeapDef_AA12";
		default.Weapon_VariantWeaponDef[0].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AA12_Precious";
		default.Weapon_VariantWeaponDef[1].WeaponDef = "KFGame.KFWeapDef_AbominationAxe";
		default.Weapon_VariantWeaponDef[1].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AbominationAxe_Precious";
		default.Weapon_VariantWeaponDef[2].WeaponDef = "KFGame.KFWeapDef_AF2011";
		default.Weapon_VariantWeaponDef[2].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AF2011_Precious";
		default.Weapon_VariantWeaponDef[2].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_AF2011Dual_Precious";
		default.Weapon_VariantWeaponDef[3].WeaponDef = "KFGame.KFWeapDef_AK12";
		default.Weapon_VariantWeaponDef[3].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AK12_Precious";
		default.Weapon_VariantWeaponDef[4].WeaponDef = "KFGame.KFWeapDef_AR15";
		default.Weapon_VariantWeaponDef[4].WeaponDefVariant = "ZedternalReborn.WMWeapDef_AR15_Precious";
		default.Weapon_VariantWeaponDef[5].WeaponDef = "KFGame.KFWeapDef_Blunderbuss";
		default.Weapon_VariantWeaponDef[5].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Blunderbuss_Precious";
		default.Weapon_VariantWeaponDef[6].WeaponDef = "KFGame.KFWeapDef_Bullpup";
		default.Weapon_VariantWeaponDef[6].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Bullpup_Precious";
		default.Weapon_VariantWeaponDef[7].WeaponDef = "KFGame.KFWeapDef_C4";
		default.Weapon_VariantWeaponDef[7].WeaponDefVariant = "ZedternalReborn.WMWeapDef_C4_Precious";
		default.Weapon_VariantWeaponDef[8].WeaponDef = "KFGame.KFWeapDef_CaulkBurn";
		default.Weapon_VariantWeaponDef[8].WeaponDefVariant = "ZedternalReborn.WMWeapDef_CaulkBurn_Precious";
		default.Weapon_VariantWeaponDef[9].WeaponDef = "KFGame.KFWeapDef_CenterfireMB464";
		default.Weapon_VariantWeaponDef[9].WeaponDefVariant = "ZedternalReborn.WMWeapDef_CenterfireMB464_Precious";
		default.Weapon_VariantWeaponDef[10].WeaponDef = "KFGame.KFWeapDef_ChainBat";
		default.Weapon_VariantWeaponDef[10].WeaponDefVariant = "ZedternalReborn.WMWeapDef_ChainBat_Precious";
		default.Weapon_VariantWeaponDef[11].WeaponDef = "KFGame.KFWeapDef_ChiappaRhino";
		default.Weapon_VariantWeaponDef[11].WeaponDefVariant = "ZedternalReborn.WMWeapDef_ChiappaRhino_Precious";
		default.Weapon_VariantWeaponDef[11].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_ChiappaRhinoDual_Precious";
		default.Weapon_VariantWeaponDef[12].WeaponDef = "KFGame.KFWeapDef_Colt1911";
		default.Weapon_VariantWeaponDef[12].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Colt1911_Precious";
		default.Weapon_VariantWeaponDef[12].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_Colt1911Dual_Precious";
		default.Weapon_VariantWeaponDef[13].WeaponDef = "KFGame.KFWeapDef_CompoundBow";
		default.Weapon_VariantWeaponDef[13].WeaponDefVariant = "ZedternalReborn.WMWeapDef_CompoundBow_Precious";
		default.Weapon_VariantWeaponDef[14].WeaponDef = "KFGame.KFWeapDef_Crossbow";
		default.Weapon_VariantWeaponDef[14].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Crossbow_Precious";
		default.Weapon_VariantWeaponDef[15].WeaponDef = "KFGame.KFWeapDef_Crovel";
		default.Weapon_VariantWeaponDef[15].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Crovel_Precious";
		default.Weapon_VariantWeaponDef[16].WeaponDef = "KFGame.KFWeapDef_Deagle";
		default.Weapon_VariantWeaponDef[16].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Deagle_Precious";
		default.Weapon_VariantWeaponDef[16].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_DeagleDual_Precious";
		default.Weapon_VariantWeaponDef[17].WeaponDef = "KFGame.KFWeapDef_DoubleBarrel";
		default.Weapon_VariantWeaponDef[17].WeaponDefVariant = "ZedternalReborn.WMWeapDef_DoubleBarrel_Precious";
		default.Weapon_VariantWeaponDef[18].WeaponDef = "KFGame.KFWeapDef_DragonsBreath";
		default.Weapon_VariantWeaponDef[18].WeaponDefVariant = "ZedternalReborn.WMWeapDef_DragonsBreath_Precious";
		default.Weapon_VariantWeaponDef[19].WeaponDef = "KFGame.KFWeapDef_ElephantGun";
		default.Weapon_VariantWeaponDef[19].WeaponDefVariant = "ZedternalReborn.WMWeapDef_ElephantGun_Precious";
		default.Weapon_VariantWeaponDef[20].WeaponDef = "KFGame.KFWeapDef_Eviscerator";
		default.Weapon_VariantWeaponDef[20].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Eviscerator_Precious";
		default.Weapon_VariantWeaponDef[21].WeaponDef = "KFGame.KFWeapDef_FAMAS";
		default.Weapon_VariantWeaponDef[21].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FAMAS_Precious";
		default.Weapon_VariantWeaponDef[22].WeaponDef = "KFGame.KFWeapDef_FireAxe";
		default.Weapon_VariantWeaponDef[22].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FireAxe_Precious";
		default.Weapon_VariantWeaponDef[23].WeaponDef = "KFGame.KFWeapDef_FlameThrower";
		default.Weapon_VariantWeaponDef[23].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FlameThrower_Precious";
		default.Weapon_VariantWeaponDef[24].WeaponDef = "KFGame.KFWeapDef_FlareGun";
		default.Weapon_VariantWeaponDef[24].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FlareGun_Precious";
		default.Weapon_VariantWeaponDef[24].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_FlareGunDual_Precious";
		default.Weapon_VariantWeaponDef[25].WeaponDef = "KFGame.KFWeapDef_FNFal";
		default.Weapon_VariantWeaponDef[25].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FNFal_Precious";
		default.Weapon_VariantWeaponDef[26].WeaponDef = "KFGame.KFWeapDef_FreezeThrower";
		default.Weapon_VariantWeaponDef[26].WeaponDefVariant = "ZedternalReborn.WMWeapDef_FreezeThrower_Precious";
		default.Weapon_VariantWeaponDef[27].WeaponDef = "KFGame.KFWeapDef_G18";
		default.Weapon_VariantWeaponDef[27].WeaponDefVariant = "ZedternalReborn.WMWeapDef_G18_Precious";
		default.Weapon_VariantWeaponDef[28].WeaponDef = "KFGame.KFWeapDef_GravityImploder";
		default.Weapon_VariantWeaponDef[28].WeaponDefVariant = "ZedternalReborn.WMWeapDef_GravityImploder_Precious";
		default.Weapon_VariantWeaponDef[29].WeaponDef = "KFGame.KFWeapDef_Healthrower_HRG";
		default.Weapon_VariantWeaponDef[29].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Healthrower_HRG_Precious";
		default.Weapon_VariantWeaponDef[30].WeaponDef = "KFGame.KFWeapDef_Hemogoblin";
		default.Weapon_VariantWeaponDef[30].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Hemogoblin_Precious";
		default.Weapon_VariantWeaponDef[31].WeaponDef = "KFGame.KFWeapDef_HK_UMP";
		default.Weapon_VariantWeaponDef[31].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HK_UMP_Precious";
		default.Weapon_VariantWeaponDef[32].WeaponDef = "KFGame.KFWeapDef_HRG_BarrierRifle";
		default.Weapon_VariantWeaponDef[32].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRG_BarrierRifle_Precious";
		default.Weapon_VariantWeaponDef[33].WeaponDef = "KFGame.KFWeapDef_HRG_BlastBrawlers";
		default.Weapon_VariantWeaponDef[33].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRG_BlastBrawlers_Precious";
		default.Weapon_VariantWeaponDef[34].WeaponDef = "KFGame.KFWeapDef_HRG_EMP_ArcGenerator";
		default.Weapon_VariantWeaponDef[34].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRG_EMP_ArcGenerator_Precious";
		default.Weapon_VariantWeaponDef[35].WeaponDef = "KFGame.KFWeapDef_HRGIncendiaryRifle";
		default.Weapon_VariantWeaponDef[35].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGIncendiaryRifle_Precious";
		default.Weapon_VariantWeaponDef[36].WeaponDef = "KFGame.KFWeapDef_HRGIncision";
		default.Weapon_VariantWeaponDef[36].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGIncision_Precious";
		default.Weapon_VariantWeaponDef[37].WeaponDef = "KFGame.KFWeapDef_HRG_Kaboomstick";
		default.Weapon_VariantWeaponDef[37].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRG_Kaboomstick_Precious";
		default.Weapon_VariantWeaponDef[38].WeaponDef = "KFGame.KFWeapDef_HRGScorcher";
		default.Weapon_VariantWeaponDef[38].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGScorcher_Precious";
		default.Weapon_VariantWeaponDef[39].WeaponDef = "KFGame.KFWeapDef_HRG_SonicGun";
		default.Weapon_VariantWeaponDef[39].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRG_SonicGun_Precious";
		default.Weapon_VariantWeaponDef[40].WeaponDef = "KFGame.KFWeapDef_HRGTeslauncher";
		default.Weapon_VariantWeaponDef[40].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGTeslauncher_Precious";
		default.Weapon_VariantWeaponDef[41].WeaponDef = "KFGame.KFWeapDef_HRG_Vampire";
		default.Weapon_VariantWeaponDef[41].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRG_Vampire_Precious";
		default.Weapon_VariantWeaponDef[42].WeaponDef = "KFGame.KFWeapDef_HRGWinterbite";
		default.Weapon_VariantWeaponDef[42].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGWinterbite_Precious";
		default.Weapon_VariantWeaponDef[42].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_HRGWinterbiteDual_Precious";
		default.Weapon_VariantWeaponDef[43].WeaponDef = "KFGame.KFWeapDef_HuskCannon";
		default.Weapon_VariantWeaponDef[43].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HuskCannon_Precious";
		default.Weapon_VariantWeaponDef[44].WeaponDef = "KFGame.KFWeapDef_HX25";
		default.Weapon_VariantWeaponDef[44].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HX25_Precious";
		default.Weapon_VariantWeaponDef[45].WeaponDef = "KFGame.KFWeapDef_HZ12";
		default.Weapon_VariantWeaponDef[45].WeaponDefVariant = "ZedternalReborn.WMWeapDef_HZ12_Precious";
		default.Weapon_VariantWeaponDef[46].WeaponDef = "KFGame.KFWeapDef_IonThruster";
		default.Weapon_VariantWeaponDef[46].WeaponDefVariant = "ZedternalReborn.WMWeapDef_IonThruster_Precious";
		default.Weapon_VariantWeaponDef[47].WeaponDef = "KFGame.KFWeapDef_Katana";
		default.Weapon_VariantWeaponDef[47].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Katana_Precious";
		default.Weapon_VariantWeaponDef[48].WeaponDef = "KFGame.KFWeapDef_Kriss";
		default.Weapon_VariantWeaponDef[48].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Kriss_Precious";
		default.Weapon_VariantWeaponDef[49].WeaponDef = "KFGame.KFWeapDef_LazerCutter";
		default.Weapon_VariantWeaponDef[49].WeaponDefVariant = "ZedternalReborn.WMWeapDef_LazerCutter_Precious";
		default.Weapon_VariantWeaponDef[50].WeaponDef = "KFGame.KFWeapDef_M4";
		default.Weapon_VariantWeaponDef[50].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M4_Precious";
		default.Weapon_VariantWeaponDef[51].WeaponDef = "KFGame.KFWeapDef_M14EBR";
		default.Weapon_VariantWeaponDef[51].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M14EBR_Precious";
		default.Weapon_VariantWeaponDef[52].WeaponDef = "KFGame.KFWeapDef_M16M203";
		default.Weapon_VariantWeaponDef[52].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M16M203_Precious";
		default.Weapon_VariantWeaponDef[53].WeaponDef = "KFGame.KFWeapDef_M32";
		default.Weapon_VariantWeaponDef[53].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M32_Precious";
		default.Weapon_VariantWeaponDef[54].WeaponDef = "KFGame.KFWeapDef_M79";
		default.Weapon_VariantWeaponDef[54].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M79_Precious";
		default.Weapon_VariantWeaponDef[55].WeaponDef = "KFGame.KFWeapDef_M99";
		default.Weapon_VariantWeaponDef[55].WeaponDefVariant = "ZedternalReborn.WMWeapDef_M99_Precious";
		default.Weapon_VariantWeaponDef[56].WeaponDef = "KFGame.KFWeapDef_Mac10";
		default.Weapon_VariantWeaponDef[56].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Mac10_Precious";
		default.Weapon_VariantWeaponDef[57].WeaponDef = "KFGame.KFWeapDef_MaceAndShield";
		default.Weapon_VariantWeaponDef[57].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MaceAndShield_Precious";
		default.Weapon_VariantWeaponDef[58].WeaponDef = "KFGame.KFWeapDef_MB500";
		default.Weapon_VariantWeaponDef[58].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MB500_Precious";
		default.Weapon_VariantWeaponDef[59].WeaponDef = "KFGame.KFWeapDef_MedicBat";
		default.Weapon_VariantWeaponDef[59].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicBat_Precious";
		default.Weapon_VariantWeaponDef[60].WeaponDef = "KFGame.KFWeapDef_MedicPistol";
		default.Weapon_VariantWeaponDef[60].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicPistol_Precious";
		default.Weapon_VariantWeaponDef[61].WeaponDef = "KFGame.KFWeapDef_MedicRifle";
		default.Weapon_VariantWeaponDef[61].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicRifle_Precious";
		default.Weapon_VariantWeaponDef[62].WeaponDef = "KFGame.KFWeapDef_MedicRifleGrenadeLauncher";
		default.Weapon_VariantWeaponDef[62].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicRifleGrenadeLauncher_Precious";
		default.Weapon_VariantWeaponDef[63].WeaponDef = "KFGame.KFWeapDef_MedicShotgun";
		default.Weapon_VariantWeaponDef[63].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicShotgun_Precious";
		default.Weapon_VariantWeaponDef[64].WeaponDef = "KFGame.KFWeapDef_MedicSMG";
		default.Weapon_VariantWeaponDef[64].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MedicSMG_Precious";
		default.Weapon_VariantWeaponDef[65].WeaponDef = "KFGame.KFWeapDef_MicrowaveGun";
		default.Weapon_VariantWeaponDef[65].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MicrowaveGun_Precious";
		default.Weapon_VariantWeaponDef[66].WeaponDef = "KFGame.KFWeapDef_MicrowaveRifle";
		default.Weapon_VariantWeaponDef[66].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MicrowaveRifle_Precious";
		default.Weapon_VariantWeaponDef[67].WeaponDef = "KFGame.KFWeapDef_Mine_Reconstructor";
		default.Weapon_VariantWeaponDef[67].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Mine_Reconstructor_Precious";
		default.Weapon_VariantWeaponDef[68].WeaponDef = "KFGame.KFWeapDef_Minigun";
		default.Weapon_VariantWeaponDef[68].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Minigun_Precious";
		default.Weapon_VariantWeaponDef[69].WeaponDef = "KFGame.KFWeapDef_MKB42";
		default.Weapon_VariantWeaponDef[69].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MKB42_Precious";
		default.Weapon_VariantWeaponDef[70].WeaponDef = "KFGame.KFWeapDef_MosinNagant";
		default.Weapon_VariantWeaponDef[70].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MosinNagant_Precious";
		default.Weapon_VariantWeaponDef[71].WeaponDef = "KFGame.KFWeapDef_MP5RAS";
		default.Weapon_VariantWeaponDef[71].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MP5RAS_Precious";
		default.Weapon_VariantWeaponDef[72].WeaponDef = "KFGame.KFWeapDef_MP7";
		default.Weapon_VariantWeaponDef[72].WeaponDefVariant = "ZedternalReborn.WMWeapDef_MP7_Precious";
		default.Weapon_VariantWeaponDef[73].WeaponDef = "KFGame.KFWeapDef_Nailgun";
		default.Weapon_VariantWeaponDef[73].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Nailgun_Precious";
		default.Weapon_VariantWeaponDef[74].WeaponDef = "KFGame.KFWeapDef_Nailgun_HRG";
		default.Weapon_VariantWeaponDef[74].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Nailgun_HRG_Precious";
		default.Weapon_VariantWeaponDef[75].WeaponDef = "KFGame.KFWeapDef_P90";
		default.Weapon_VariantWeaponDef[75].WeaponDefVariant = "ZedternalReborn.WMWeapDef_P90_Precious";
		default.Weapon_VariantWeaponDef[76].WeaponDef = "KFGame.KFWeapDef_Pistol_G18C";
		default.Weapon_VariantWeaponDef[76].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Pistol_G18C_Precious";
		default.Weapon_VariantWeaponDef[76].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_Pistol_DualG18_Precious";
		default.Weapon_VariantWeaponDef[77].WeaponDef = "KFGame.KFWeapDef_PowerGloves";
		default.Weapon_VariantWeaponDef[77].WeaponDefVariant = "ZedternalReborn.WMWeapDef_PowerGloves_Precious";
		default.Weapon_VariantWeaponDef[78].WeaponDef = "KFGame.KFWeapDef_Pulverizer";
		default.Weapon_VariantWeaponDef[78].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Pulverizer_Precious";
		default.Weapon_VariantWeaponDef[79].WeaponDef = "KFGame.KFWeapDef_RailGun";
		default.Weapon_VariantWeaponDef[79].WeaponDefVariant = "ZedternalReborn.WMWeapDef_RailGun_Precious";
		default.Weapon_VariantWeaponDef[80].WeaponDef = "KFGame.KFWeapDef_Remington1858";
		default.Weapon_VariantWeaponDef[80].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Remington1858_Precious";
		default.Weapon_VariantWeaponDef[80].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_Remington1858Dual_Precious";
		default.Weapon_VariantWeaponDef[81].WeaponDef = "KFGame.KFWeapDef_Rifle_FrostShotgunAxe";
		default.Weapon_VariantWeaponDef[81].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Rifle_FrostShotgunAxe_Precious";
		default.Weapon_VariantWeaponDef[82].WeaponDef = "KFGame.KFWeapDef_RPG7";
		default.Weapon_VariantWeaponDef[82].WeaponDefVariant = "ZedternalReborn.WMWeapDef_RPG7_Precious";
		default.Weapon_VariantWeaponDef[83].WeaponDef = "KFGame.KFWeapDef_SCAR";
		default.Weapon_VariantWeaponDef[83].WeaponDefVariant = "ZedternalReborn.WMWeapDef_SCAR_Precious";
		default.Weapon_VariantWeaponDef[84].WeaponDef = "KFGame.KFWeapDef_SealSqueal";
		default.Weapon_VariantWeaponDef[84].WeaponDefVariant = "ZedternalReborn.WMWeapDef_SealSqueal_Precious";
		default.Weapon_VariantWeaponDef[85].WeaponDef = "KFGame.KFWeapDef_Seeker6";
		default.Weapon_VariantWeaponDef[85].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Seeker6_Precious";
		default.Weapon_VariantWeaponDef[86].WeaponDef = "KFGame.KFWeapDef_Stoner63A";
		default.Weapon_VariantWeaponDef[86].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Stoner63A_Precious";
		default.Weapon_VariantWeaponDef[87].WeaponDef = "KFGame.KFWeapDef_SW500";
		default.Weapon_VariantWeaponDef[87].WeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500_Precious";
		default.Weapon_VariantWeaponDef[87].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500Dual_Precious";
		default.Weapon_VariantWeaponDef[88].WeaponDef = "KFGame.KFWeapDef_SW500_HRG";
		default.Weapon_VariantWeaponDef[88].WeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500_HRG_Precious";
		default.Weapon_VariantWeaponDef[88].DualWeaponDefVariant = "ZedternalReborn.WMWeapDef_SW500Dual_HRG_Precious";
		default.Weapon_VariantWeaponDef[89].WeaponDef = "KFGame.KFWeapDef_ThermiteBore";
		default.Weapon_VariantWeaponDef[89].WeaponDefVariant = "ZedternalReborn.WMWeapDef_ThermiteBore_Precious";
		default.Weapon_VariantWeaponDef[90].WeaponDef = "KFGame.KFWeapDef_Thompson";
		default.Weapon_VariantWeaponDef[90].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Thompson_Precious";
		default.Weapon_VariantWeaponDef[91].WeaponDef = "KFGame.KFWeapDef_Winchester1894";
		default.Weapon_VariantWeaponDef[91].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Winchester1894_Precious";
		default.Weapon_VariantWeaponDef[92].WeaponDef = "KFGame.KFWeapDef_Zweihander";
		default.Weapon_VariantWeaponDef[92].WeaponDefVariant = "ZedternalReborn.WMWeapDef_Zweihander_Precious";
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

	for (i = 0; i < default.Weapon_VariantWeaponDef.Length; ++i)
	{
		if (default.Weapon_VariantWeaponDef[i].Probability < 0.0f)
		{
			LogBadConfigMessage("Weapon_VariantWeaponDef - Line" @ string(i + 1) @ "- Probability",
				string(default.Weapon_VariantWeaponDef[i].Probability),
				"0.0", "0%, never selected", "1.0 >= value >= 0.0");
			default.Weapon_VariantWeaponDef[i].Probability = 0.0f;
		}

		if (default.Weapon_VariantWeaponDef[i].Probability > 1.0f)
		{
			LogBadConfigMessage("Weapon_VariantWeaponDef - Line" @ string(i + 1) @ "- Probability",
				string(default.Weapon_VariantWeaponDef[i].Probability),
				"1.0", "100%, always selected", "1.0 >= value >= 0.0");
			default.Weapon_VariantWeaponDef[i].Probability = 1.0f;
		}
	}
}

defaultproperties
{
	Name="Default__Config_WeaponVariant"
}
