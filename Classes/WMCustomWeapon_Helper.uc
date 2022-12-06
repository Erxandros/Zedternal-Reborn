Class WMCustomWeapon_Helper extends Object;

struct WeaponDefPath
{
	var string	ZedternalWeaponDefPath;
	var string	OriginalWeaponDefPath;
};

var const array<WeaponDefPath> OverrideDefinitions;
var const array<WeaponDefPath> PreciousDefinitions;

//For single player
static function UpdateSkinsStandalone(const out array<string> WeaponDefs)
{
	local int i;

	for (i = 0; i < WeaponDefs.Length; ++i)
	{
		UpdateSkinsHelper(WeaponDefs[i]);
	}
}

//For clients
static function UpdateSkinsClient(const out string WeaponDefs[255])
{
	local byte i;

	for (i = 0; i < 255; ++i)
	{
		if (WeaponDefs[i] == "")
			return;

		UpdateSkinsHelper(WeaponDefs[i]);
	}
}

static function int BinaryStringSearch(const out array<WeaponDefPath> InArray, string Str)
{
	local string MidStr;
	local int Low, Mid, High;

	Str = Caps(Str);
	Low = 0;
	High = InArray.Length - 1;
	while (Low <= High)
	{
		Mid = (Low + High) / 2;
		MidStr = Caps(InArray[Mid].ZedternalWeaponDefPath);
		if (Str < MidStr)
			High = Mid - 1;
		else if (Str > MidStr)
			Low = Mid + 1;
		else
			return Mid;
	}

	return INDEX_NONE;
}

static function int BinaryOverrideSearch(string WeaponDef)
{
	return BinaryStringSearch(default.OverrideDefinitions, WeaponDef);
}

static function int BinaryPreciousSearch(string WeaponDef)
{
	return BinaryStringSearch(default.PreciousDefinitions, WeaponDef);
}

//Override and precious weapons will use the players skins
static function UpdateSkinsHelper(const out string WeaponDef)
{
	local class<KFWeaponDefinition> OrginalWeapon, ZedternalWeapon;
	local int index;
	local WeaponSkin Skin;

	index = BinaryOverrideSearch(WeaponDef);
	if (index != INDEX_NONE)
	{
		ZedternalWeapon = class<KFWeaponDefinition>(DynamicLoadObject(default.OverrideDefinitions[index].ZedternalWeaponDefPath, class'Class'));
		OrginalWeapon = class<KFWeaponDefinition>(DynamicLoadObject(default.OverrideDefinitions[index].OriginalWeaponDefPath, class'Class'));
	}
	else
	{
		index = BinaryPreciousSearch(WeaponDef);
		if (index != INDEX_NONE)
		{
			ZedternalWeapon = class<KFWeaponDefinition>(DynamicLoadObject(default.PreciousDefinitions[index].ZedternalWeaponDefPath, class'Class'));
			OrginalWeapon = class<KFWeaponDefinition>(DynamicLoadObject(default.PreciousDefinitions[index].OriginalWeaponDefPath, class'Class'));
		}
	}

	if (ZedternalWeapon != None && OrginalWeapon != None)
	{
		foreach class'KFWeaponSkinList'.default.Skins(Skin)
		{
			if (class'KFWeaponSkinList'.Static.IsSkinEquip(OrginalWeapon, Skin.Id))
			{
				class'KFWeaponSkinList'.Static.SaveWeaponSkin(ZedternalWeapon, Skin.Id);
				return;
			}
		}

		class'KFWeaponSkinList'.Static.SaveWeaponSkin(ZedternalWeapon, 0); //Clear Skin
	}
}

defaultproperties
{
	//Overrides
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AutoTurret",OriginalWeaponDefPath="KFGame.KFWeapDef_AutoTurret"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Doshinegun",OriginalWeaponDefPath="KFGame.KFWeapDef_Doshinegun"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_BlastBrawlers",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_BlastBrawlers"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Dragonbreath",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Dragonbreath"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGIncendiaryRifle",OriginalWeaponDefPath="KFGame.KFWeapDef_HRGIncendiaryRifle"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGTeslauncher",OriginalWeaponDefPath="KFGameContent.KFWeapDef_HRGTeslauncher"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M16M203",OriginalWeaponDefPath="KFGame.KFWeapDef_M16M203"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicRifleGrenadeLauncher",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicRifleGrenadeLauncher"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Nailgun",OriginalWeaponDefPath="KFGame.KFWeapDef_Nailgun"));
	OverrideDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Nailgun_HRG",OriginalWeaponDefPath="KFGame.KFWeapDef_Nailgun_HRG"));

	//Precious Weapons
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AA12_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AA12"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AbominationAxe_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AbominationAxe"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AF2011_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AF2011"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AK12_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AK12"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AR15_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AR15"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AutoTurret_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AutoTurret"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_BladedPistol_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_BladedPistol"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Blunderbuss_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Blunderbuss"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Bullpup_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Bullpup"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_C4_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_C4"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_CaulkBurn_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_CaulkBurn"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_CenterfireMB464_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_CenterfireMB464"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ChainBat_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ChainBat"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ChiappaRhino_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ChiappaRhino"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Colt1911_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Colt1911"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_CompoundBow_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_CompoundBow"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Crossbow_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Crossbow"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Crovel_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Crovel"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Deagle_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Deagle"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Doshinegun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Doshinegun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_DoubleBarrel_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_DoubleBarrel"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_DragonsBreath_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_DragonsBreath"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ElephantGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ElephantGun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Eviscerator_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Eviscerator"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FAMAS_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FAMAS"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FireAxe_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FireAxe"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FlameThrower_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FlameThrower"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FlareGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FlareGun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FNFal_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FNFal"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FreezeThrower_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FreezeThrower"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_G18_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_G18"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_G36C_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_G36C"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_GravityImploder_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_GravityImploder"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Healthrower_HRG_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Healthrower_HRG"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Hemogoblin_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Hemogoblin"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HK_UMP_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HK_UMP"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_BallisticBouncer_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_BallisticBouncer"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_BarrierRifle_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_BarrierRifle"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_BlastBrawlers_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_BlastBrawlers"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Boomy_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Boomy"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_CranialPopper_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_CranialPopper"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Crossboom_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Crossboom"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Dragonbreath_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Dragonbreath"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_EMP_ArcGenerator_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_EMP_ArcGenerator"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Energy_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Energy"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Kaboomstick_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Kaboomstick"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Locust_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Locust"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_MedicMissile_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_MedicMissile"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_SonicGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_SonicGun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Stunner_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Stunner"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRG_Vampire_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRG_Vampire"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGIncendiaryRifle_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRGIncendiaryRifle"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGIncision_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRGIncision"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGScorcher_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRGScorcher"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGTeslauncher_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRGTeslauncher"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGWinterbite_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRGWinterbite"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HuskCannon_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HuskCannon"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HVStormCannon_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HVStormCannon"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HX25_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HX25"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HZ12_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HZ12"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_IonThruster_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_IonThruster"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Katana_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Katana"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Kriss_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Kriss"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_LazerCutter_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_LazerCutter"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M14EBR_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M14EBR"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M16M203_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M16M203"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M32_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M32"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M4_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M4"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M79_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M79"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M99_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M99"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Mac10_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Mac10"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MaceAndShield_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MaceAndShield"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MB500_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MB500"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicBat_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicBat"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicPistol_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicPistol"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicRifle_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicRifle"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicRifleGrenadeLauncher_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicRifleGrenadeLauncher"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicShotgun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicShotgun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicSMG_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicSMG"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MicrowaveGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MicrowaveGun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MicrowaveRifle_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MicrowaveRifle"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Mine_Reconstructor_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Mine_Reconstructor"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Minigun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Minigun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MKB42_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MKB42"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MosinNagant_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MosinNagant"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MP5RAS_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MP5RAS"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MP7_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MP7"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Nailgun_HRG_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Nailgun_HRG"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Nailgun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Nailgun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_P90_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_P90"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ParasiteImplanter_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ParasiteImplanter"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Pistol_G18C_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Pistol_G18C"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_PowerGloves_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_PowerGloves"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Pulverizer_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Pulverizer"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_RailGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_RailGun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Remington1858_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Remington1858"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Rifle_FrostShotgunAxe_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Rifle_FrostShotgunAxe"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_RPG7_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_RPG7"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_SCAR_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_SCAR"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Scythe_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Scythe"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_SealSqueal_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_SealSqueal"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Seeker6_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Seeker6"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ShrinkRayGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ShrinkRayGun"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Stoner63A_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Stoner63A"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_SW500_HRG_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_SW500_HRG"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_SW500_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_SW500"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ThermiteBore_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ThermiteBore"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Thompson_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Thompson"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Winchester1894_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Winchester1894"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ZedMKIII_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ZedMKIII"));
	PreciousDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Zweihander_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Zweihander"));
}
