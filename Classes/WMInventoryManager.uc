class WMInventoryManager extends KFInventoryManager;

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
	local Inventory Item;

	Item = super.CreateInventory(NewInventoryItemClass, bDoNotActivate);

	if (KFWeapon(Item) != None &&
		Role == ROLE_Authority &&
		WorldInfo.NetMode == NM_DedicatedServer &&
		KFWeapon(Item).default.MagazineCapacity[0] > 0 &&
		KFWeap_Welder(Item) == None &&
		KFWeap_Healer_Syringe(Item) == None)
	{
		Spawn(class'ZedternalReborn.WMWeaponAmmoFix', Item);
	}

	return Item;
}

simulated event ShowOnlyHUDGroup(byte GroupIndex)
{
	local KFGFxMoviePlayer_HUD KFGFxHUD;

	if (KFPlayerController(Instigator.Controller) != None)
	{
		KFGFxHUD = KFPlayerController(Instigator.Controller).MyGFxHUD;
		if (KFGFxHUD != None && KFGFxHUD.WeaponSelectWidget != None)
			KFGFxHUD.WeaponSelectWidget.ShowOnlyHUDGroup(GroupIndex);
	}
}

simulated function ShowAllHUDGroups()
{
	local KFGFxMoviePlayer_HUD KFGFxHUD;

	if (Instigator != None && KFPlayerController(Instigator.Controller) != None)
	{
		KFGFxHUD = KFPlayerController(Instigator.Controller).MyGFxHUD;
		if (KFGFxHUD != None && KFGFxHUD.WeaponSelectWidget != None)
			KFGFxHUD.WeaponSelectWidget.ShowAllHUDGroups();
	}
}

function bool AddArmorFromPickup()
{
	local WMPawn_Human WMPH;

	WMPH = WMPawn_Human(Instigator);
	if (WMPH != None && WMPH.ZedternalArmor != WMPH.GetMaxArmor())
	{
		PlayerController(Instigator.Owner).ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_PickedupArmor);
		PlayGiveInventorySound(ArmorPickupSound);
		WMPH.GiveMaxArmor();
		return True;
	}
	else
	{
		PlayerController(Instigator.Owner).ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_FullArmor);
		return False;
	}
}

function bool AddArmor(int Amount)
{
	local WMPawn_Human WMPH;

	WMPH = WMPawn_Human(Instigator);
	if (WMPH != None && WMPH.ZedternalArmor != WMPH.GetMaxArmor())
	{
		PlayerController(Instigator.Owner).ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_PickedupArmor);
		PlayGiveInventorySound(ArmorPickupSound);
		WMPH.AddArmor(Amount);
		return True;
	}
	else
	{
		PlayerController(Instigator.Owner).ReceiveLocalizedMessage(class'KFLocalMessage_Game', GMT_FullArmor);
		return False;
	}
}

////////
//Copy and pasted from KFInventoryManager, but converted to Zedternal functions to turn bytes into ints to support a larger trader weapon list
////////

simulated function BuyAmmoZedternal( float AmountPurchased, EItemType ItemType, optional int ItemIndex, optional bool bSecondaryAmmo )
{
	local STraderItem WeaponItem;
	local KFWeapon KFW;
	local byte MagAmmoCount;

	MagAmmoCount = 255;

	if ( ItemType == EIT_Weapon )
	{
		// get the client's ammo count and send it to server (in case they're out of sync)
		if( GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex) )
		{
			if( GetWeaponFromClass(KFW, WeaponItem.ClassName) )
			{
				MagAmmoCount = bSecondaryAmmo ? KFW.AmmoCount[1] : KFW.AmmoCount[0];
			}
		}

		ServerBuyAmmoZedternal(int(AmountPurchased), MagAmmoCount, ItemIndex, bSecondaryAmmo);
	}
	else if ( ItemType == EIT_Armor )
	{
		ServerBuyArmorZedternal(AmountPurchased);
	}
	else if ( ItemType == EIT_Grenade )
	{
		ServerBuyGrenadeZedternal(int(AmountPurchased));
	}
}

reliable server private function ServerBuyAmmoZedternal(int AmountPurchased, byte ClientAmmoCount, int ItemIndex, bool bSecondaryAmmo)
{
	local STraderItem WeaponItem;
	local KFWeapon KFW;
	local int ClientMaxMagCapacity;

	if( Role == ROLE_Authority && bServerTraderMenuOpen )
	{
		if( GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex) )
		{
			if( !ProcessAmmoDoshZedternal(WeaponItem, AmountPurchased, bSecondaryAmmo) )
			{
				return;
			}

			if( GetWeaponFromClass(KFW, WeaponItem.ClassName) )
			{
				if( bSecondaryAmmo )
				{
					KFW.AddSecondaryAmmo( AmountPurchased );

					/* __TW_ Analytics */
					`BalanceLog(class'KFGameInfo'.const.GBE_Buy, Instigator.PlayerReplicationInfo, "S.Ammo,"@KFW.class$","@AmountPurchased);
					`AnalyticsLog(("buy", Instigator.PlayerReplicationInfo, "S.ammo", KFW.class, "#"$AmountPurchased));
				}
				else
				{
					// AddAmmo takes AmmoCount into account, but AmmoCount can be out of sync between client and server,
					// so sync server with passed-in client value
					if( ClientAmmoCount != 255 )
					{
						ClientMaxMagCapacity = KFW.default.MagazineCapacity[0];
						if( KFW.GetPerk() != none )
						{
							// account for perks that potentially increase mag size, like commando
							KFW.GetPerk().ModifyMagSizeAndNumber( KFW, ClientMaxMagCapacity );
						}
						KFW.AmmoCount[0] = Clamp( ClientAmmoCount, 0, ClientMaxMagCapacity );
					}
					KFW.AddAmmo( AmountPurchased );

					/* __TW_ Analytics */
					`BalanceLog(class'KFGameInfo'.const.GBE_Buy, Instigator.PlayerReplicationInfo, "Ammo,"@KFW.class$","@AmountPurchased);
					`AnalyticsLog(("buy", Instigator.PlayerReplicationInfo, "ammo", KFW.class, "#"$AmountPurchased));
				}
			}
			else
			{
				// Buying ammo for weapon that is pending purchase
				ServerAddTransactionAmmoZedternal(AmountPurchased, ItemIndex, bSecondaryAmmo);
			}
		}
	}
}

reliable server private event ServerAddTransactionAmmoZedternal( int AmountAdded, int ItemIndex, bool bSecondaryAmmo )
{
	local STraderItem WeaponItem;
	local byte AmmoTypeIndex;
	local int TransactionIndex;

	if( bServerTraderMenuOpen )
	{
		if( GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex) )
		{
			TransactionIndex = GetTransactionItemIndex(WeaponItem.ClassName);
			if( TransactionIndex != INDEX_NONE )
			{
				AmmoTypeIndex = byte(bSecondaryAmmo);
				TransactionItems[TransactionIndex].AddedAmmo[AmmoTypeIndex] += AmountAdded;

				if ( bSecondaryAmmo )
				{
					`BalanceLog(class'KFGameInfo'.const.GBE_Buy, Instigator.PlayerReplicationInfo, "S.Ammo,"@WeaponItem.ClassName$","@AmountAdded);
					`AnalyticsLog(("buy", Instigator.PlayerReplicationInfo, "S.ammo", WeaponItem.ClassName, "#"$AmountAdded));
				}
				else
				{
					`BalanceLog(class'KFGameInfo'.const.GBE_Buy, Instigator.PlayerReplicationInfo, "Ammo,"@WeaponItem.ClassName$","@AmountAdded);
					`AnalyticsLog(("buy", Instigator.PlayerReplicationInfo, "ammo", WeaponItem.ClassName, "#"$AmountAdded));
				}
			}
		}
	}
}

simulated function BuyUpgradeZedternal(int ItemIndex, int CurrentUpgradeLevel)
{
	local STraderItem WeaponItem;
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(Instigator.Owner);

	// get the client's ammo count and send it to server (in case they're out of sync)
	if (GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex))
	{
		KFPC.GetPurchaseHelper().AddDosh(-WeaponItem.WeaponDef.static.GetUpgradePrice(CurrentUpgradeLevel)); //client tracking
		KFPC.GetPurchaseHelper().AddBlocks(-GetDisplayedBlocksRequiredFor(WeaponItem));//remove the old weight
		KFPC.GetPurchaseHelper().AddBlocks(GetDisplayedBlocksRequiredFor(WeaponItem, CurrentUpgradeLevel + 1)); //add the new
		ServerBuyUpgradeZedternal(ItemIndex, CurrentUpgradeLevel);
	}
}

reliable server private function ServerBuyUpgradeZedternal(int ItemIndex, int CurrentUpgradeLevel)
{
	local STraderItem WeaponItem;
	local KFWeapon KFW;
	local int NewUpgradeLevel;


	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		//is this a transation item or not?
		if (GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex))
		{
			if (!ProcessUpgradeDoshZedternal(WeaponItem, CurrentUpgradeLevel))
			{
				return;
			}

			NewUpgradeLevel = CurrentUpgradeLevel + 1;

			if (GetWeaponFromClass(KFW, WeaponItem.ClassName))
			{
				if (KFW != none)
				{
					KFW.SetWeaponUpgradeLevel(NewUpgradeLevel);
					if (CurrentUpgradeLevel > 0)
					{
						AddCurrentCarryBlocks(-KFW.GetUpgradeStatAdd(EWUS_Weight, CurrentUpgradeLevel));
					}

					AddCurrentCarryBlocks(KFW.GetUpgradeStatAdd(EWUS_Weight, NewUpgradeLevel));
					`BalanceLog(class'KFGameInfo'.const.GBE_Buy, Instigator.PlayerReplicationInfo, "Upgrade," @ KFW.Class $ "," @ NewUpgradeLevel);
					`AnalyticsLog(("upgrade", Instigator.PlayerReplicationInfo, "upgrade", KFW.Class, "#" $ NewUpgradeLevel));
				}
			}
			else
			{
				ServerAddTransactionUpgradeZedternal(ItemIndex, NewUpgradeLevel);
			}
		}
	}
}

reliable server private event ServerAddTransactionUpgradeZedternal(int ItemIndex, int NewUpgradeLevel)
{
	if (bServerTraderMenuOpen)
	{
		AddTransactionUpgrade(ItemIndex, NewUpgradeLevel);
	}
}

reliable server private function ServerBuyArmorZedternal( float PercentPurchased )
{
	local KFPawn_Human KFP;
	local int AmountPurchased;
	local float MaxArmor;

	KFP = KFPawn_Human( Instigator );
	if( Role == ROLE_Authority && KFP != none && bServerTraderMenuOpen )
	{
		if( ProcessArmorDoshZedternal( PercentPurchased ) )
		{
			// We've passed the percent armor purchased into this function, now get the armor count
			MaxArmor = KFP.GetMaxArmor();
			AmountPurchased = FCeil( MaxArmor * (PercentPurchased / 100.0) );

			KFP.AddArmor( AmountPurchased );

			/* __TW_ Analytics */
			`BalanceLog(class'KFGameInfo'.const.GBE_Buy, Instigator.PlayerReplicationInfo, "Armor,"@PercentPurchased);
			// this is a bit spammy, since it buys armor in increments of '3'
			`AnalyticsLog(("buy", Instigator.PlayerReplicationInfo, "armor", "#"$PercentPurchased));
		}
	}
}

reliable server private function ServerBuyGrenadeZedternal( int AmountPurchased )
{
	if ( Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		if(ProcessGrenadeDoshZedternal(AmountPurchased))
		{
			AddGrenades( AmountPurchased );

			/* __TW_ Analytics */
			`BalanceLog(class'KFGameInfo'.const.GBE_Buy, Instigator.PlayerReplicationInfo, "Grenades(s),"$","@AmountPurchased);
			`AnalyticsLog(("buy", Instigator.PlayerReplicationInfo, "grenades", "#"$AmountPurchased));
		}
	}
}

reliable server function ServerBuyWeaponZedternal( int ItemIndex, optional byte WeaponUpgrade )
{
	local STraderItem PurchasedItem;
	local int BlocksRequired;

	// Find the weapon in the servers TraderItemList
	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		// Get the purchased item info using the item indicies
		if( GetTraderItemFromWeaponListsZedternal(PurchasedItem, ItemIndex) )
		{
			BlocksRequired = GetWeaponBlocks(PurchasedItem, WeaponUpgrade);
			if(CurrentCarryBlocks > CurrentCarryBlocks + BlocksRequired
				|| !ProcessWeaponDoshZedternal(PurchasedItem))
			{
				return;
			}

			`log("ServerBuyWeapon: Adding transaction item" @ PurchasedItem.ClassName, bLogInventory);
			AddTransactionItem( PurchasedItem, WeaponUpgrade );
		}
	}
}

reliable server function ServerAddTransactionItemZedternal( int ItemIndex, optional byte WeaponUpgrade)
{
	local STraderItem PurchasedItem;

	// Find the weapon in the servers TraderItemList
	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		// Get the purchased item info using the item indicies
		if( GetTraderItemFromWeaponListsZedternal(PurchasedItem, ItemIndex) )
		{
			AddTransactionItem( PurchasedItem, WeaponUpgrade );
		}
	}
}

reliable server function ServerSellWeaponZedternal( int ItemIndex )
{
	local STraderItem SoldItem;
	local int SellPrice, TransactionIndex;
	local KFWeapon KFW;
	local KFPlayerReplicationInfo KFPRI;

	// Find the weapon in the servers TraderItemList
	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		// Get the Sold Item info using the Item indicies
		if( KFPRI != none && GetTraderItemFromWeaponListsZedternal(SoldItem, ItemIndex) )
		{
			// If the weapon is in our inventory, sell it immediately
			if( GetWeaponFromClass(KFW, SoldItem.ClassName) )
			{
				`log("ServerSellWeapon: Calling ServerRemoveFromInventory on" @ SoldItem.ClassName, bLogInventory);
				SellPrice = GetAdjustedSellPriceFor(SoldItem);

				KFPRI.AddDosh(SellPrice);
				ServerRemoveFromInventory(KFW);
				KFW.Destroy();
			}
			else // Otherwise it's a transaction item that needs to be removed
			{
				TransactionIndex = GetTransactionItemIndex(SoldItem.ClassName);
				`log("ServerSellWeapon: SoldItem="$SoldItem.ClassName @ "TransactionIndex="$TransactionIndex, bLogInventory);
				if( TransactionIndex != INDEX_NONE )
				{
					SellPrice = GetAdjustedSellPriceFor( SoldItem );

					KFPRI.AddDosh(SellPrice);

					`log("ServerSellWeapon: Calling RemoveTransactionItem on" @ SoldItem.ClassName, bLogInventory);
					RemoveTransactionItem( SoldItem );
				}
			}
		}
	}
}

private function bool ProcessWeaponDoshZedternal(out STraderItem PurchasedItem)
{
	local int BuyPrice;
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if( KFPRI != none )
	{
		BuyPrice = GetAdjustedBuyPriceFor( PurchasedItem );

		// Check if we can buy this weapon using the servers weapon pricing
		if(KFPRI.Score - BuyPrice >= 0)
		{
			// Deduct the purchase from our score
			KFPRI.AddDosh(-BuyPrice);
			return true;
		}
	}

	`log("Server failed to process " @PurchasedItem.ClassName, bLogInventory);
	return false;
}

private function bool ProcessAmmoDoshZedternal(out STraderItem PurchasedItem, int AdditionalAmmo, optional bool bSecondaryAmmo)
{
	local int BuyPrice;
	local float PricePerMag, MagSize, AmmoCostScale;
	local KFPlayerReplicationInfo KFPRI;
	local KFGameReplicationInfo KFGRI;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if (KFGRI != none)
	{
		AmmoCostScale = KFGRI.GameAmmoCostScale;
	}
	else
	{
		AmmoCostScale = 1.0;
	}

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if( KFPRI != none )
	{
		if( bSecondaryAmmo )
		{
			PricePerMag = AmmoCostScale * PurchasedItem.WeaponDef.default.SecondaryAmmoMagPrice;
			MagSize = PurchasedItem.WeaponDef.default.SecondaryAmmoMagSize;

			BuyPrice = FCeil((PricePerMag / MagSize) * float(AdditionalAmmo));
		}
		else
		{
			PricePerMag = AmmoCostScale * PurchasedItem.WeaponDef.default.AmmoPricePerMag;
			MagSize = PurchasedItem.MagazineCapacity;

			BuyPrice = FCeil((PricePerMag / MagSize) * float(AdditionalAmmo));
		}

		// Check if we can buy this weapon using the servers weapon pricing
		if( KFPRI.Score - BuyPrice >= 0 )
		{
			// Deduct the purchase from our score
			KFPRI.AddDosh(-BuyPrice);
			return true;
		}
	}

	`log("Server failed to process " @PurchasedItem.ClassName @"Ammo", bLogInventory);
	return false;
}

private function bool ProcessUpgradeDoshZedternal(const out STraderItem PurchasedItem, int NewUpgradeLevel)
{
	local int BuyPrice;
	local KFPlayerController KFPC;
	local KFPlayerReplicationInfo KFPRI;

	KFPC = KFPlayerController(Instigator.Owner);
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPC != none && KFPRI != none)
	{
		BuyPrice = PurchasedItem.WeaponDef.static.GetUpgradePrice(NewUpgradeLevel);
		if (BuyPrice <= KFPRI.Score)
		{
			KFPRI.AddDosh(-BuyPrice);
			return true;
		}
	}

	return false;
}

private function bool ProcessGrenadeDoshZedternal(int AmountPurchased)
{
	local int BuyPrice;
	local KFGFxObject_TraderItems TraderItems;
	local KFPlayerController KFPC;
	local KFPlayerReplicationInfo KFPRI;

	KFPC = KFPlayerController(Instigator.Owner);
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if( KFPC != none && KFPRI != none )
	{
		TraderItems = KFGameReplicationInfo( WorldInfo.GRI ).TraderItems;
		BuyPrice = TraderItems.GrenadePrice * AmountPurchased;
		if(BuyPrice <= KFPRI.Score)
		{
			KFPRI.AddDosh(-BuyPrice);
			return true;
		}
	}

	`log("Server failed to buy grenades");
	return false;
}

private function bool ProcessArmorDoshZedternal(float PercentPurchased)
{
	local int BuyPrice;
	local KFGFxObject_TraderItems TraderItems;
	local KFPlayerController KFPC;
	local KFPerk CurrentPerk;
	local int ArmorPricePerPercent;
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if( KFPRI != none )
	{
		TraderItems = KFGameReplicationInfo( WorldInfo.GRI ).TraderItems;
		ArmorPricePerPercent = TraderItems.ArmorPrice;

		KFPC = KFPlayerController(Instigator.Owner);
		if( KFPC != none )
		{
			CurrentPerk = KFPC.GetPerk();
			if( CurrentPerk != none )
			{
				ArmorPricePerPercent *= CurrentPerk.GetArmorDiscountMod();
			}
		}

		BuyPrice = FCeil(ArmorPricePerPercent * PercentPurchased);
		if(BuyPrice <= KFPRI.Score)
		{
			KFPRI.AddDosh(-BuyPrice);
			return true;
		}
	}

	`log("Server failed to buy armor");
	return false;
}

private simulated function bool GetTraderItemFromWeaponListsZedternal(out STraderItem TraderItem, int ItemIndex )
{
	local KFGFxObject_TraderItems TraderItemsObject;

	TraderItemsObject = KFGameReplicationInfo( WorldInfo.GRI ).TraderItems;
	if( ItemIndex < TraderItemsObject.SaleItems.Length )
	{
		TraderItem = TraderItemsObject.SaleItems[ItemIndex];
		return true;
	}

	return false;
}

defaultproperties
{
	Name="Default__WMInventoryManager"
}
