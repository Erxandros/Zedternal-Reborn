class WMGameInfo_Endless_AllWeapons extends WMGameInfo_Endless
	config(GameEndless);

function BuildWeaponList()
{
	local int i, count;
	local bool bAllowWeaponVariant;
	local array<int> weaponIndex;
	local class<KFWeaponDefinition> KFWeaponDefClass, CustomWeaponDef;
	local STraderItem newWeapon;

	weaponIndex.Length = 0;

	TraderItems = new class'KFGFxObject_TraderItems';

	/////////////////
	// Armor Price //
	/////////////////
	if (CustomMode)
		TraderItems.ArmorPrice = class'ZedternalReborn.Config_Game'.static.GetArmorPrice(CustomDifficulty);
	else
		TraderItems.ArmorPrice = class'ZedternalReborn.Config_Game'.static.GetArmorPrice(GameDifficulty);

	if (WMGameReplicationInfo(MyKFGRI) != none)
		WMGameReplicationInfo(MyKFGRI).ArmorPrice = TraderItems.ArmorPrice;

	//////////////////////
	// Register Weapons //
	//////////////////////

	//Scan and register all default weapons from the game
	count = 0;
	for (i = 0; i < DefaultTraderItems.SaleItems.Length; ++i)
	{
		newWeapon.WeaponDef = DefaultTraderItems.SaleItems[i].WeaponDef;
		newWeapon.ItemID = count;
		++count;
		TraderItems.SaleItems.AddItem(newWeapon);
		KFWeaponDefPath.AddItem(PathName(newWeapon.WeaponDef)); //for client
		
		// Add weapons to the list of possible weapons
		if (IsWeaponDefCanBeRandom(DefaultTraderItems.SaleItems[i].WeaponDef))
			weaponIndex[weaponIndex.Length] = count - 1;
	}

	//Add and register custom weapons
	if (class'ZedternalReborn.Config_Weapon'.default.Weapon_bUseCustomWeaponList)
	{
		for (i = 0; i < class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef.length; ++i)
		{
			CustomWeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i],class'Class'));
			if (CustomWeaponDef != None)
			{
				newWeapon.WeaponDef = CustomWeaponDef;
				newWeapon.ItemID = count;
				++count;
				TraderItems.SaleItems.AddItem(newWeapon);
				KFWeaponDefPath.AddItem(PathName(newWeapon.WeaponDef)); //for client

				// Add weapons to the list of possible weapons
				if (IsWeaponDefCanBeRandom(CustomWeaponDef))
					weaponIndex[weaponIndex.Length] = count - 1;

				`log("Custom weapon added: "$class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i]);
			}
			else
			{
				`log("Custom weapon "$class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i]$
					" does not exist, please check spelling or make sure the workshop item is correctly installed");
			}
		}
	}

	//get WeaponVariant Probablity/Allowed
	bAllowWeaponVariant = class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_bAllowWeaponVariant;
	
	////////////////////////
	// Create weapon list //
	////////////////////////

	weaponUpgradeArch.length = 0;

	//create starting weapon list and adding them in the trader
	for (i = 0; i < StartingWeaponList.length; ++i)
	{
		PerkStartingWeapon[i] = StartingWeaponList[i];
		KFStartingWeaponPath[i] = PerkStartingWeapon[i].default.WeaponClassPath;
		
		if (bAllowWeaponVariant)
			ApplyRandomWeaponVariant(PathName(StartingWeaponList[i]), true);
		else
			CheckForWeaponOverrides(StartingWeaponList[i]);
	}

	//adding static weapon in the trader
	for (i = 0; i < StaticWeaponList.length; ++i)
	{
		if (bAllowWeaponVariant)
			ApplyRandomWeaponVariant(PathName(StaticWeaponList[i]), true);
		else
			CheckForWeaponOverrides(StaticWeaponList[i]);
	}

	//Adding other weapons
	for (i = 0; i < weaponIndex.length; ++i)
	{
		KFWeaponDefClass = TraderItems.SaleItems[weaponIndex[i]].WeaponDef;
		if (KFWeaponDefClass != none)
		{
			if (bAllowWeaponVariant)
				ApplyRandomWeaponVariant(PathName(TraderItems.SaleItems[weaponIndex[i]].WeaponDef), false, weaponIndex[i]);
			else
				CheckForWeaponOverrides(TraderItems.SaleItems[weaponIndex[i]].WeaponDef, weaponIndex[i]);
		}
	}

	//Just set the starting weapon count so it is defined
	startingWeaponCount = class'ZedternalReborn.Config_Weapon'.default.Trader_StartingWeaponNumber;

	//Finishing WeaponList
	TraderItems.SetItemsInfo(TraderItems.SaleItems);
	MyKFGRI.TraderItems = TraderItems;

	`log("Weapon List : ");
	for (i = 0; i < KFWeaponName.length; ++i)
	{
		`log(KFWeaponName[i] $ "(" $ i $ ")");
	}
}

defaultproperties
{
	GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo_AllWeapons'
}
