class WMInventoryManager extends KFInventoryManager;

simulated function CreateAmmoFix(const out Inventory Inv)
{
	if (KFWeapon(Inv) != None &&
		Role == ROLE_Authority &&
		WorldInfo.NetMode == NM_DedicatedServer &&
		KFWeapon(Inv).default.MagazineCapacity[0] > 0 &&
		KFWeap_Welder(Inv) == None &&
		KFWeap_Healer_Syringe(Inv) == None)
	{
		Spawn(class'ZedternalReborn.WMWeaponAmmoFix', Inv);
	}
}

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
	local Inventory Item;
	local WMGameReplicationInfo WMGRI;
	local KFPerk KFP;
	local class<KFWeapon> KFWInvClass;
	local Name OwnedSidearmName, WeaponName;
	local int i;

	WMGRI = WMGameReplicationInfo(WorldInfo.GRI);

	if (KFPlayerController(Instigator.Owner) != None)
		KFP = KFPlayerController(Instigator.Owner).GetPerk();

	KFWInvClass = class<KFWeapon>(NewInventoryItemClass);
	if (WMGRI != None && KFP != None)
	{
		OwnedSidearmName = Name(Split(KFP.GetSecondaryWeaponClassPath(), ".", True));
		for (i = 0; i < WMGRI.SidearmsList.Length; ++i)
		{
			WeaponName = Name(Split(WMGRI.SidearmsList[i].Sidearm.default.WeaponClassPath, ".", True));
			if (NewInventoryItemClass.Name == WeaponName)
			{
				if (NewInventoryItemClass.Name == OwnedSidearmName)
				{
					if (FindInventoryType(NewInventoryItemClass) == None)
						return CreateInventorySidearm(NewInventoryItemClass, bDoNotActivate);

					break;
				}

				return None;
			}

			if (KFWInvClass != None && KFWInvClass.default.DualClass != None && KFWInvClass.default.DualClass.Name == WeaponName)
			{
				if (KFWInvClass.default.DualClass.Name == OwnedSidearmName)
				{
					if (FindInventoryType(KFWInvClass.default.DualClass) == None)
						return CreateInventorySidearm(KFWInvClass.default.DualClass, bDoNotActivate);

					break;
				}

				return None;
			}
		}
	}

	Item = super.CreateInventory(NewInventoryItemClass, bDoNotActivate);
	if (KFWeapon(Item) != None)
		Item.DroppedPickupClass = class'ZedternalReborn.WMDroppedPickup';
	CreateAmmoFix(Item);
	return Item;
}

simulated function Inventory CreateInventorySidearm(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
	local KFWeapon KFW;

	if (bPendingDelete)
		return None;

	if (class<KFWeapon>(NewInventoryItemClass) != None)
	{
		KFW = KFWeapon(Spawn(NewInventoryItemClass, Owner));
		if (KFW != None)
		{
			KFW.InventorySize = 0;
			KFW.bCanThrow = False;
			KFW.bDropOnDeath = False;
			KFW.bIsBackupWeapon = True;
			KFW.DroppedPickupClass = class'ZedternalReborn.WMDroppedPickup';
			if (!AddInventory(KFW, bDoNotActivate))
			{
				KFW.Destroy();
				KFW = None;
			}
		}

		UpdateHUD();
		PlayGiveInventorySound(ItemPickupSound);

		if (KFW != None)
			CheckForExcessRemoval(KFW);

		CreateAmmoFix(KFW);
		SyncSidearmStats(KFW);
		return KFW;
	}

	return None;
}

reliable client function SyncSidearmStats(KFWeapon KFW)
{
	local KFWeapon KFW_Local;

	foreach DynamicActors(class'KFWeapon', KFW_Local)
	{
		if (KFW_Local == KFW)
		{
			KFW_Local.InventorySize = 0;
			KFW_Local.bCanThrow = False;
			KFW_Local.bDropOnDeath = False;
			KFW_Local.bIsBackupWeapon = True;
			break;
		}
	}
}

simulated function bool IsPrecious9mmInInventory()
{
	local Inventory Inv;

	for (Inv = InventoryChain; Inv != None; Inv = Inv.Inventory)
	{
		if (Inv.Class.Name == 'WMWeap_Pistol_9mm_Precious' || Inv.Class.Name == 'WMWeap_Pistol_Dual9mm_Precious')
			return True;
	}

	return False;
}

simulated function int GetDisplayedBlocksRequiredFor(const out STraderItem ShopItem, optional int OverrideLevelValue = INDEX_NONE)
{
	local int BlocksRequired;
	local KFPlayerController KFPC;
	local KFPerk CurrentPerk;
	local bool IsSidearm;

	IsSidearm = False;
	KFPC = KFPlayerController(Instigator.Owner);
	if (KFPC != None)
	{
		CurrentPerk = KFPC.GetPerk();
		if (CurrentPerk != None && Name(Split(CurrentPerk.GetSecondaryWeaponClassPath(), ".", True)) == ShopItem.SingleClassName)
			IsSidearm = True;
	}

	BlocksRequired = GetWeaponBlocks(ShopItem, OverrideLevelValue);

	if (!(ShopItem.SingleClassName == '' || IsSidearm) && GetIsOwned(ShopItem.SingleClassName))
		BlocksRequired /= 2;

	return BlocksRequired;
}

simulated function int GetAdjustedSellPriceFor(const out STraderItem OwnedItem, optional const array<SItemInformation> TraderOwnedItems)
{
	local KFPlayerController KFPC;
	local KFPerk CurrentPerk;

	KFPC = KFPlayerController(Instigator.Owner);
	if (KFPC != None)
	{
		CurrentPerk = KFPC.GetPerk();
		if (CurrentPerk != None && CurrentPerk.GetSecondaryWeaponClassPath() ~= OwnedItem.WeaponDef.default.WeaponClassPath)
			return 0;
	}

	return super.GetAdjustedSellPriceFor(OwnedItem, TraderOwnedItems);
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

reliable server function DeleteFromInventory(Inventory ItemToRemove)
{
	if (Role == ROLE_Authority)
	{
		RemoveFromInventory(ItemToRemove);
		ItemToRemove.Destroy();
	}
}

////////
//Copy and pasted from KFInventoryManager, but converted to Zedternal functions to turn bytes into ints to support a larger trader weapon list
////////

//Overrides KFInventoryManager.BuyAmmo and converts ItemIndex to int
simulated function BuyAmmoZedternal(float AmountPurchased, EItemType ItemType, optional int ItemIndex, optional bool bSecondaryAmmo)
{
	local STraderItem WeaponItem;
	local KFWeapon KFW;
	local int MagAmmoCount;

	MagAmmoCount = -1; //Set to -1 to indicate not valid value

	if (ItemType == EIT_Weapon)
	{
		if (GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex))
		{
			if (GetWeaponFromClass(KFW, WeaponItem.ClassName))
				MagAmmoCount = bSecondaryAmmo ? KFW.AmmoCount[1] : KFW.AmmoCount[0];
		}

		ServerBuyAmmoZedternal(int(AmountPurchased), MagAmmoCount, ItemIndex, bSecondaryAmmo);
	}
	else
		BuyAmmo(AmountPurchased, ItemType);
}

//Overrides KFInventoryManager.ServerBuyAmmo and converts ItemIndex to int
reliable server private function ServerBuyAmmoZedternal(int AmountPurchased, int ClientAmmoCount, int ItemIndex, bool bSecondaryAmmo)
{
	local STraderItem WeaponItem;
	local KFWeapon KFW;
	local int ClientMaxMagCapacity;

	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		if (GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex))
		{
			if (!ProcessAmmoDoshZedternal(WeaponItem, AmountPurchased, bSecondaryAmmo))
				return;

			if (GetWeaponFromClass(KFW, WeaponItem.ClassName))
			{
				if (bSecondaryAmmo)
					KFW.AddSecondaryAmmo(AmountPurchased);
				else
				{
					// AddAmmo takes AmmoCount into account, but AmmoCount can be out of sync between client and server,
					// so sync server with passed-in client value
					if (ClientAmmoCount != -1)
					{
						ClientMaxMagCapacity = KFW.default.MagazineCapacity[0];
						if (KFW.GetPerk() != None)
							KFW.GetPerk().ModifyMagSizeAndNumber(KFW, ClientMaxMagCapacity);
						KFW.AmmoCount[0] = Clamp(ClientAmmoCount, 0, ClientMaxMagCapacity);
					}

					KFW.AddAmmo(AmountPurchased);
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

//Used for WMAutoPurchaseHelper.AddTransactionAmmoZedternal to replace native KFAutoPurchaseHelper.AddTransactionAmmo
reliable server function AddTransactionAmmo(int AmountAdded, int ItemIndex)
{
	ServerAddTransactionAmmoZedternal(AmountAdded, ItemIndex, False);
}

//Overrides KFInventoryManager.ServerAddTransactionAmmo and converts ItemIndex to int
reliable server private event ServerAddTransactionAmmoZedternal(int AmountAdded, int ItemIndex, bool bSecondaryAmmo)
{
	local STraderItem WeaponItem;
	local byte AmmoTypeIndex;
	local int TransactionIndex;

	if (bServerTraderMenuOpen)
	{
		if (GetTraderItemFromWeaponListsZedternal(WeaponItem, ItemIndex))
		{
			TransactionIndex = GetTransactionItemIndex(WeaponItem.ClassName);
			if (TransactionIndex != INDEX_NONE)
			{
				AmmoTypeIndex = byte(bSecondaryAmmo);
				TransactionItems[TransactionIndex].AddedAmmo[AmmoTypeIndex] += AmountAdded;
			}
		}
	}
}

//Overrides KFInventoryManager.ServerBuyWeapon and converts ItemIndex to int
reliable server function ServerBuyWeaponZedternal(int ItemIndex, optional byte WeaponUpgrade)
{
	local STraderItem PurchasedItem;
	local int BlocksRequired;

	// Find the weapon in the servers TraderItemList
	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		// Get the purchased item info using the item indices
		if (GetTraderItemFromWeaponListsZedternal(PurchasedItem, ItemIndex))
		{
			BlocksRequired = GetWeaponBlocks(PurchasedItem, WeaponUpgrade);
			if (CurrentCarryBlocks > CurrentCarryBlocks + BlocksRequired || !ProcessWeaponDoshZedternal(PurchasedItem))
				return;

			AddTransactionItem(PurchasedItem, WeaponUpgrade);
		}
	}
}

//Overrides KFInventoryManager.ServerAddTransactionItem and converts ItemIndex to int
reliable server function ServerAddTransactionItemZedternal(int ItemIndex, optional byte WeaponUpgrade)
{
	local STraderItem PurchasedItem;

	// Find the weapon in the servers TraderItemList
	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		// Get the purchased item info using the item indices
		if (GetTraderItemFromWeaponListsZedternal(PurchasedItem, ItemIndex))
			AddTransactionItem(PurchasedItem, WeaponUpgrade);
	}
}

//Overrides KFInventoryManager.ServerSellWeapon and converts ItemIndex to int
reliable server function ServerSellWeaponZedternal(int ItemIndex)
{
	local STraderItem SoldItem;
	local int SellPrice, TransactionIndex;
	local KFWeapon KFW;
	local KFPlayerReplicationInfo KFPRI;

	// Find the weapon in the servers TraderItemList
	if (Role == ROLE_Authority && bServerTraderMenuOpen)
	{
		KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
		// Get the Sold Item info using the Item indices
		if (KFPRI != None && GetTraderItemFromWeaponListsZedternal(SoldItem, ItemIndex))
		{
			// If the weapon is in our inventory, sell it immediately
			if (GetWeaponFromClass(KFW, SoldItem.ClassName))
			{
				SellPrice = GetAdjustedSellPriceFor(SoldItem);
				KFPRI.AddDosh(SellPrice);
				ServerRemoveFromInventory(KFW);
				KFW.Destroy();
			}
			else // Otherwise it's a transaction item that needs to be removed
			{
				TransactionIndex = GetTransactionItemIndex(SoldItem.ClassName);
				if (TransactionIndex != INDEX_NONE)
				{
					SellPrice = GetAdjustedSellPriceFor(SoldItem);
					KFPRI.AddDosh(SellPrice);
					RemoveTransactionItem(SoldItem);
				}
			}
		}
	}
}

//Overrides KFInventoryManager.ServerRemoveTransactionItem to use GetTraderItemFromWeaponListsZedternal
reliable server final function ServerRemoveTransactionItemZedternal(int ItemIndex)
{
	local STraderItem ItemToRemove;
	local KFWeapon InvWeap;

	if (bServerTraderMenuOpen)
	{
		if (GetTraderItemFromWeaponListsZedternal(ItemToRemove, ItemIndex))
		{
			RemoveTransactionItem(ItemToRemove);

			// remove from inventory if necessary (like after buying a dual when owning a single)
			if( GetWeaponFromClass(InvWeap, ItemToRemove.ClassName))
				RemoveFromInventory(InvWeap);
		}
	}
}

//Overrides KFInventoryManager.ProcessWeaponDosh because it is a private and final function that can not be used
private function bool ProcessWeaponDoshZedternal(out STraderItem PurchasedItem)
{
	local int BuyPrice;
	local KFPlayerReplicationInfo KFPRI;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != None)
	{
		BuyPrice = GetAdjustedBuyPriceFor(PurchasedItem);

		// Check if we can buy this weapon using the servers weapon pricing
		if (KFPRI.Score - BuyPrice >= 0)
		{
			// Deduct the purchase from our score
			KFPRI.AddDosh(-BuyPrice);
			return True;
		}
	}

	return False;
}

//Overrides KFInventoryManager.ProcessAmmoDosh because it is a private and final function that can not be used
private function bool ProcessAmmoDoshZedternal(out STraderItem PurchasedItem, int AdditionalAmmo, optional bool bSecondaryAmmo)
{
	local int BuyPrice;
	local float PricePerMag, MagSize, AmmoCostScale;
	local KFPlayerReplicationInfo KFPRI;
	local KFGameReplicationInfo KFGRI;

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if (KFGRI != None)
		AmmoCostScale = KFGRI.GameAmmoCostScale;
	else
		AmmoCostScale = 1.0f;

	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if (KFPRI != none)
	{
		if (bSecondaryAmmo)
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
		if (KFPRI.Score - BuyPrice >= 0)
		{
			// Deduct the purchase from our score
			KFPRI.AddDosh(-BuyPrice);
			return True;
		}
	}

	return False;
}

//Overrides KFInventoryManager.GetTraderItemFromWeaponLists and converts ItemIndex to int
private simulated function bool GetTraderItemFromWeaponListsZedternal(out STraderItem TraderItem, int ItemIndex)
{
	local KFGFxObject_TraderItems TraderItemsObject;

	TraderItemsObject = KFGameReplicationInfo(WorldInfo.GRI).TraderItems;
	if (ItemIndex < TraderItemsObject.SaleItems.Length)
	{
		TraderItem = TraderItemsObject.SaleItems[ItemIndex];
		return True;
	}

	return False;
}

defaultproperties
{
	Name="Default__WMInventoryManager"
}
