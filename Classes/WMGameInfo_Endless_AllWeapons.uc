class WMGameInfo_Endless_AllWeapons extends WMGameInfo_Endless
	config(GameEndless);


function BuildWeaponList()
{
	local int i, count;
	local bool bAllowWeaponVariant;
	local array<int> weaponIndex;
	local class<KFWeaponDefinition> KFWeaponDefClass;
	local STraderItem newWeapon;
	
	weaponIndex.Length=0;
	
	TraderItems = new class'KFGFxObject_TraderItems';
	
	/////////////////
	// Armor Price //
	/////////////////
	TraderItems.ArmorPrice = class'ZedternalReborn.Config_Game'.static.GetArmorPrice(GameDifficulty);
	if (WMGameReplicationInfo(MyKFGRI) != none)
		WMGameReplicationInfo(MyKFGRI).ArmorPrice = TraderItems.ArmorPrice;
	
	
	//////////////////////
	// Register Weapons //
	//////////////////////
	
	//Scan and register all default weapons from the game
	count = 0;
	for (i=0;i<DefaultTraderItems.SaleItems.Length;i+=1)
	{
		newWeapon.WeaponDef = DefaultTraderItems.SaleItems[i].WeaponDef;
		newWeapon.ItemID = count;
		count++;
		TraderItems.SaleItems.AddItem(newWeapon);
		KFWeaponDefPath.AddItem(PathName(newWeapon.WeaponDef)); //for client
		
		// Add weapons to the list of possible weapons
		if (IsWeaponDefCanBeRandom(DefaultTraderItems.SaleItems[i].WeaponDef))
			weaponIndex[weaponIndex.Length] = count-1;
	}
	
	//Add and register custom weapons
	if (class'ZedternalReborn.Config_Weapon'.default.Weapon_bUseCustomWeaponList)
	{
		for (i=0;i<class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef.length;i+=1)
		{
			newWeapon.WeaponDef = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i],class'Class'));
			newWeapon.ItemID = count;
			count++;
			TraderItems.SaleItems.AddItem(newWeapon);
			KFWeaponDefPath.AddItem(PathName(newWeapon.WeaponDef)); //for client
			
			// Add weapons to the list of possible weapons
			if (IsWeaponDefCanBeRandom(class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_CustomWeaponDef[i],class'Class'))))
				weaponIndex[weaponIndex.Length] = count-1;
		}
	}
	
	//get WeaponVariant Probablity/Allowed
	bAllowWeaponVariant = class'ZedternalReborn.Config_Weapon'.default.WeaponVariant_bAllowWeaponVariant;
	
	////////////////////////
	// Create weapon list //
	////////////////////////
	
	weaponUpgradeArch.length=0;
	
	//create starting weapon list and adding them in the trader
	for (i=0; i<class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList.length; i++)
	{
		PerkStartingWeapon[i] = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[i],class'Class'));
		KFStartingWeaponPath[i] = PerkStartingWeapon[i].default.WeaponClassPath;
		
		KFWeaponDefClass = PerkStartingWeapon[i];
		if (KFWeaponDefClass != none)
		{
			if (bAllowWeaponVariant)
				ApplyRandomWeaponVariant(class'ZedternalReborn.Config_Weapon'.default.Weapon_PlayerStartingWeaponDefList[i]);
			else
				CheckForWeaponOverrides(KFWeaponDefClass);
		}
	}
	
	//adding static weapon in the trader
	for (i=0; i<class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs.length; i++)
	{
		KFWeaponDefClass = class<KFWeaponDefinition>(DynamicLoadObject(class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i],class'Class'));
		if (KFWeaponDefClass != none)
		{
			if (bAllowWeaponVariant)
				ApplyRandomWeaponVariant(class'ZedternalReborn.Config_Weapon'.default.Trader_StaticWeaponDefs[i]);
			else
				CheckForWeaponOverrides(KFWeaponDefClass);
		}
	}
	
	//Adding other weapons
	for (i=0; i<weaponIndex.length; i++)
	{
		KFWeaponDefClass = TraderItems.SaleItems[weaponIndex[i]].WeaponDef;
		if (KFWeaponDefClass != none)
		{
			if (bAllowWeaponVariant)
				ApplyRandomWeaponVariant(PathName(TraderItems.SaleItems[weaponIndex[i]].WeaponDef), weaponIndex[i]);
			else
				CheckForWeaponOverrides(TraderItems.SaleItems[weaponIndex[i]].WeaponDef, weaponIndex[i]);
		}
	}
	
	//Finishing WeaponList
	TraderItems.SetItemsInfo(TraderItems.SaleItems);
	MyKFGRI.TraderItems = TraderItems;
	
	`log("Weapon List : ");
	for (i=0; i<KFWeaponName.length; i++)
	{
		`log(KFWeaponName[i] $ "(" $ i $ ")");
	}
}

defaultproperties
{
   GameReplicationInfoClass=Class'ZedternalReborn.WMGameReplicationInfo_AllWeapons'
}
