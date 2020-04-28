Class WMCustomWeapon_Helper extends Info;

const NAME_MAX_LENGTH = 24;

struct WeaponDefPath
{
	var string	ZedternalWeaponDefPath;
	var string	OriginalWeaponDefPath;
};

var const array<WeaponDefPath> WeaponDefinitions;

// Localization
static function string GetItemNamePreciousVariant(string defaultName, string customShortName)
{
	local string str;

	str = defaultName $ " [Precious]";
	if (Len(str) > NAME_MAX_LENGTH)
		return customShortName $ " [Precious]";

	return str;
}

//For single player
static function UpdateSkinsStandalone(const out array<string> WeaponDefs)
{
	local int i;

	for (i = 0; i < WeaponDefs.length; i++)
	{
		UpdateSkinsHelper(WeaponDefs[i]);
	}
}

//For clients
static function UpdateSkinsClient(const out string WeaponDefs[255])
{
	local byte i;

	for (i = 0; i < 255; i++)
	{
		if (WeaponDefs[i] == "")
			return;

		UpdateSkinsHelper(WeaponDefs[i]);
	}
}

//Override and precious weapons will use the players skins
static function UpdateSkinsHelper(const out string WeaponDef)
{
	local class<KFWeaponDefinition> ZedternalWeapon;
	local class<KFWeaponDefinition> OrginalWeapon;
	local int index;
	local WeaponSkin Skin;

	index = default.WeaponDefinitions.Find('ZedternalWeaponDefPath', WeaponDef);
	if (index == -1)
		return;

	ZedternalWeapon = class<KFWeaponDefinition>(DynamicLoadObject(default.WeaponDefinitions[index].ZedternalWeaponDefPath, class'Class'));
	OrginalWeapon = class<KFWeaponDefinition>(DynamicLoadObject(default.WeaponDefinitions[index].OriginalWeaponDefPath, class'Class'));

	foreach class'KFWeaponSkinList'.default.Skins(Skin)
	{
		if (class'KFWeaponSkinList'.Static.IsSkinEquip(OrginalWeapon, skin.Id))
		{
			class'KFWeaponSkinList'.Static.SaveWeaponSkin(ZedternalWeapon, skin.Id);
			return;
		}
	}

	class'KFWeaponSkinList'.Static.SaveWeaponSkin(ZedternalWeapon, 0); //clear skin
}

defaultproperties
{
	//Overrides
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Nailgun",OriginalWeaponDefPath="KFGame.KFWeapDef_Nailgun"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Nailgun_HRG",OriginalWeaponDefPath="KFGame.KFWeapDef_Nailgun_HRG"));

	//Precious Weapons
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Bullpup_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Bullpup"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AK12_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AK12"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_SCAR_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_SCAR"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Stoner63A_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Stoner63A"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MP5RAS_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MP5RAS"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_P90_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_P90"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HK_UMP_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HK_UMP"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Kriss_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Kriss"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Katana_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Katana"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Nailgun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Nailgun"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Zweihander_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Zweihander"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Pulverizer_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Pulverizer"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MaceAndShield_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MaceAndShield"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Eviscerator_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Eviscerator"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_DoubleBarrel_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_DoubleBarrel"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HZ12_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HZ12"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M4_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M4"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AA12_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AA12"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Crossbow_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Crossbow"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M14EBR_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M14EBR"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_RailGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_RailGun"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_CaulkBurn_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_CaulkBurn"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_DragonsBreath_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_DragonsBreath"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FlameThrower_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FlameThrower"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MicrowaveGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MicrowaveGun"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HuskCannon_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HuskCannon"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicSMG_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicSMG"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicShotgun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicShotgun"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Hemogoblin_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Hemogoblin"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicRifle_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicRifle"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M79_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M79"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_C4_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_C4"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_M16M203_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_M16M203"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_RPG7_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_RPG7"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Seeker6_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Seeker6"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Mac10_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Mac10"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_CenterfireMB464_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_CenterfireMB464"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FreezeThrower_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FreezeThrower"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FlareGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FlareGun"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Colt1911_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Colt1911"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Deagle_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Deagle"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_SW500_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_SW500"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AF2011_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AF2011"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicPistol_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicPistol"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AR15_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AR15"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Thompson_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Thompson"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MKB42_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MKB42"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FNFal_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FNFal"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Crovel_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Crovel"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ChainBat_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ChainBat"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_FireAxe_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_FireAxe"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicBat_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicBat"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_PowerGloves_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_PowerGloves"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_IonThruster_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_IonThruster"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_AbominationAxe_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_AbominationAxe"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MB500_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MB500"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_ElephantGun_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_ElephantGun"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_SW500_HRG_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_SW500_HRG"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_Healthrower_HRG_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_Healthrower_HRG"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_HRGIncision_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_HRGIncision"));
	WeaponDefinitions.Add((ZedternalWeaponDefPath="ZedternalReborn.WMWeapDef_MedicRifleGrenadeLauncher_Precious",OriginalWeaponDefPath="KFGame.KFWeapDef_MedicRifleGrenadeLauncher"));
}
