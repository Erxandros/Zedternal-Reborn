class WMGameInfo_Endless_AllWeapons extends WMGameInfo_Endless;

function BuildWeaponList()
{
	local int i;
	local bool bAllowWeaponVariant;
	local array<int> weaponIndex;
	local class<KFWeaponDefinition> KFWeaponDefClass;

	//get WeaponVariant Probablity/Allowed
	bAllowWeaponVariant = class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_bAllowWeaponVariant;

	InitializeStaticAndStartingWeapons();
	weaponIndex = InitializeTraderItems();
	if (bAllowWeaponVariant)
		CheckForStartingWeaponVariants();

	////////////////////////
	// Create weapon list //
	////////////////////////

	weaponUpgradeArch.length = 0;

	//create starting weapon list and adding them in the trader
	for (i = 0; i < StartingWeaponList.length; ++i)
	{
		PerkStartingWeapon[i] = StartingWeaponList[i];
		KFStartingWeaponPath[i] = PerkStartingWeapon[i].default.WeaponClassPath;

		CheckForWeaponOverrides(StartingWeaponList[i]);
	}

	//adding static weapon in the trader
	for (i = 0; i < StaticWeaponList.length; ++i)
	{
		if (bAllowWeaponVariant)
			ApplyRandomWeaponVariant(StaticWeaponList[i]);
		else
			CheckForWeaponOverrides(StaticWeaponList[i]);
	}

	//Adding other weapons
	for (i = 0; i < weaponIndex.length; ++i)
	{
		KFWeaponDefClass = TraderItems.SaleItems[weaponIndex[i]].WeaponDef;
		if (KFWeaponDefClass != None)
		{
			if (bAllowWeaponVariant)
				ApplyRandomWeaponVariant(TraderItems.SaleItems[weaponIndex[i]].WeaponDef, weaponIndex[i]);
			else
				CheckForWeaponOverrides(TraderItems.SaleItems[weaponIndex[i]].WeaponDef, weaponIndex[i]);
		}
	}

	SetTraderItemsAndPrintWeaponList();
}

defaultproperties
{
	GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo_AllWeapons'
}
