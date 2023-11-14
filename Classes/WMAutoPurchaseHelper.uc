class WMAutoPurchaseHelper extends KFAutoPurchaseHelper;

function InitializeOwnedItemList()
{
	local WMPawn_Human WMP;

	super.InitializeOwnedItemList();

	WMP = WMPawn_Human(Pawn);
	if (WMP != None)
	{
		ArmorItem.SpareAmmoCount = WMP.ZedternalArmor;
		ArmorItem.MaxSpareAmmo = WMP.GetMaxArmor();
	}
}

function bool CanUpgrade(STraderItem SelectedItem, out int CanCarryIndex, out int bCanAffordIndex, optional bool bPlayDialog)
{
	return False;
}

function bool UpgradeWeapon(int OwnedItemIndex)
{
	`log("ZR Info: Weapon upgrades in the trader are disabled in ZedternalReborn");
	return False;
}

////////
//Copy and pasted from KFAutoPurchaseHelper, but changed GetItemIndicesFromArche to GetItemIndicesFromArcheZedternal and a few other minor things
////////

//Overrides KFAutoPurchaseHelper.BoughtAmmo but uses GetItemIndicesFromArcheZedternal and BuyAmmoZedternal
function BoughtAmmo(float AmountPurchased, int Price, EItemType ItemType, optional name ClassName, optional bool bIsSecondaryAmmo)
{
	local int ItemIndex;

	//Fallback to the original function in case the Zedternal classes are not available
	if (WMGFxObject_TraderItems(TraderItems) == None || WMInventoryManager(MyKFIM) == None)
	{
		super.BoughtAmmo(AmountPurchased, Price, ItemType, ClassName, bIsSecondaryAmmo);
		return;
	}

	AddDosh(-Price);

	if (ItemType == EIT_Weapon)
	{
		// Get the proper weapon prices from the servers trader archetype
		WMGFxObject_TraderItems(TraderItems).GetItemIndicesFromArcheZedternal(ItemIndex, ClassName);
	}

	WMInventoryManager(MyKFIM).BuyAmmoZedternal(AmountPurchased, ItemType, ItemIndex, bIsSecondaryAmmo);
}

//Overrides KFAutoPurchaseHelper.AddWeaponToOwnedItemList but uses Zedternal function overrides
function int AddWeaponToOwnedItemList(STraderItem DefaultItem, optional bool bDoNotBuy, optional int OverrideItemUpgradeLevel = INDEX_NONE)
{
	local SItemInformation WeaponInfo;
	local int ItemIndex;
	local int AddedWeaponIndex, OwnedSingleIdx, SingleDualAmmoDiff;
	local bool bAddingDual;
	local float AmmoCostScale;
	local KFGameReplicationInfo KFGRI;

	//Fallback to the original function in case the Zedternal classes are not available
	if (WMGFxObject_TraderItems(TraderItems) == None || WMInventoryManager(MyKFIM) == None)
		return super.AddWeaponToOwnedItemList(DefaultItem, bDoNotBuy, OverrideItemUpgradeLevel);

	KFGRI = KFGameReplicationInfo(WorldInfo.GRI);
	if (KFGRI != None)
		AmmoCostScale = KFGRI.GameAmmoCostScale;
	else
		AmmoCostScale = 1.0f;

	// Magazine capacity affects both spare ammo and max spare ammo. modify this first
	WeaponInfo.MagazineCapacity = DefaultItem.MagazineCapacity;
	CurrentPerk.ModifyMagSizeAndNumber(None, WeaponInfo.MagazineCapacity, DefaultItem.AssociatedPerkClasses,, DefaultItem.ClassName);

	// Newly bought weapons need to have their default values modified by the current perk
	WeaponInfo.MaxSpareAmmo = DefaultItem.MaxSpareAmmo;
	CurrentPerk.ModifyMaxSpareAmmoAmount(None, WeaponInfo.MaxSpareAmmo, DefaultItem);
	WeaponInfo.MaxSpareAmmo += WeaponInfo.MagazineCapacity;

	WeaponInfo.SpareAmmoCount = DefaultItem.InitialSpareMags * DefaultItem.MagazineCapacity;
	CurrentPerk.ModifySpareAmmoAmount(None, WeaponInfo.SpareAmmoCount, DefaultItem);
	WeaponInfo.SpareAmmoCount += WeaponInfo.MagazineCapacity;

	// If adding a dual, adjust the displayed ammo count to reflect ammo of single
	bAddingDual = DefaultItem.SingleClassName != '';
	if (bAddingDual)
	{
		for (OwnedSingleIdx = 0; OwnedSingleIdx < OwnedItemList.Length; ++OwnedSingleIdx)
		{
			if (OwnedItemList[OwnedSingleIdx].DefaultItem.ClassName == DefaultItem.SingleClassName)
			{
				SingleDualAmmoDiff = OwnedItemList[OwnedSingleIdx].SpareAmmoCount - WeaponInfo.SpareAmmoCount;
				SingleDualAmmoDiff = Max(0, SingleDualAmmoDiff); //If buying a dual, always have it be minimum starting ammo capacity

				//If the new weapon has more when adding a dual, we're boosting it to the new full amount. Set UI info properly
				if (WeaponInfo.SpareAmmoCount > OwnedItemList[OwnedSingleIdx].SpareAmmoCount)
				{
					OwnedItemList[OwnedSingleIdx].SpareAmmoCount = WeaponInfo.SpareAmmoCount;
				}
				//Otherwise we're going to maintain ammo and want the weapon info to match intended
				else
				{
					//If rounding is causing problems, make sure our current ammo is never over the new max in the UI
					WeaponInfo.SpareAmmoCount = Min(OwnedItemList[OwnedSingleIdx].SpareAmmoCount, WeaponInfo.MaxSpareAmmo);
				}

				WeaponInfo.ItemUpgradeLevel = OwnedItemList[OwnedSingleIdx].ItemUpgradeLevel;
				break;
			}
		}
	}

	// Allow perk to set spare ammo to max (uses different params than ModifySpareAmmoAmount)
	// mostly just used for firebug
	CurrentPerk.MaximizeSpareAmmoAmount(DefaultItem.AssociatedPerkClasses, WeaponInfo.SpareAmmoCount, DefaultItem.MaxSpareAmmo + DefaultItem.MagazineCapacity);

	WeaponInfo.SecondaryAmmoCount = DefaultItem.InitialSecondaryAmmo;
	CurrentPerk.ModifyMagSizeAndNumber(None, WeaponInfo.MagazineCapacity, DefaultItem.AssociatedPerkClasses, True, DefaultItem.ClassName);
	CurrentPerk.ModifySpareAmmoAmount(None, WeaponInfo.SecondaryAmmoCount, DefaultItem, True);

	WeaponInfo.MaxSecondaryAmmo = DefaultItem.MaxSecondaryAmmo;
	CurrentPerk.ModifyMaxSpareAmmoAmount(None, WeaponInfo.MaxSecondaryAmmo, DefaultItem, True);

	WeaponInfo.AmmoPricePerMagazine = AmmoCostScale * DefaultItem.WeaponDef.default.AmmoPricePerMag;
	WeaponInfo.SellPrice = GetAdjustedSellPriceFor(DefaultItem);

	WeaponInfo.DefaultItem = DefaultItem;

	if(OverrideItemUpgradeLevel > INDEX_NONE)
		WeaponInfo.ItemUpgradeLevel = OverrideItemUpgradeLevel;

	AddedWeaponIndex = AddItemByPriority(WeaponInfo);

	WMGFxObject_TraderItems(TraderItems).GetItemIndicesFromArcheZedternal(ItemIndex, DefaultItem.ClassName);

	if (!bDoNotBuy)
	{
		// Tell the server to buy the weapon using its trader archetype info
		WMInventoryManager(MyKFIM).ServerBuyWeaponZedternal(ItemIndex, WeaponInfo.ItemUpgradeLevel);
	}
	else
	{
		// Tell the server to add the weapon (without buying) using its trader archetype info
		WMInventoryManager(MyKFIM).ServerAddTransactionItemZedternal(ItemIndex, WeaponInfo.ItemUpgradeLevel);
		AddBlocks(MyKFIM.GetWeaponBlocks(DefaultItem, WeaponInfo.ItemUpgradeLevel));
	}

	// if adding a dual, set its transaction ammo (given at trader close) to reflect the single it's replacing
	if (bAddingDual)
	{
		AddTransactionAmmoZedternal(ItemIndex, SingleDualAmmoDiff);
		RemoveWeaponFromOwnedItemList(, DefaultItem.SingleClassName, True);
	}

	return AddedWeaponIndex;
}

//Overrides KFAutoPurchaseHelper.RemoveWeaponFromOwnedItemList but uses Zedternal function overrides, also fixes dual sidearm selling
function RemoveWeaponFromOwnedItemList(optional int OwnedListIdx = INDEX_NONE, optional name ClassName, optional bool bDoNotSell)
{
	local SItemInformation ItemInfo;
	local int ItemIndex;
	local int SingleOwnedIndex;

	//Fallback to the original function in case the Zedternal classes are not available
	if (WMGFxObject_TraderItems(TraderItems) == None || WMInventoryManager(MyKFIM) == None)
	{
		super.RemoveWeaponFromOwnedItemList(OwnedListIdx, ClassName, bDoNotSell);
		return;
	}

	if (OwnedListIdx == INDEX_NONE && ClassName != '')
	{
		for (OwnedListIdx = 0; OwnedListIdx < OwnedItemList.Length; ++OwnedListIdx)
		{
			if (OwnedItemList[OwnedListIdx].DefaultItem.ClassName == ClassName)
				break;
		}
	}

	if (OwnedListIdx >= OwnedItemList.Length)
		return;

	ItemInfo = OwnedItemList[OwnedListIdx];

	if (!bDoNotSell)
	{
		// Sell the weapon from our inventory immediately
		WMGFxObject_TraderItems(TraderItems).GetItemIndicesFromArcheZedternal(ItemIndex, ItemInfo.DefaultItem.ClassName);
		WMInventoryManager(MyKFIM).ServerSellWeaponZedternal(ItemIndex);
	}
	else
	{
		// Remove the weapon from our inventory immediately (without selling)
		AddBlocks(-MyKFIM.GetDisplayedBlocksRequiredFor(ItemInfo.DefaultItem));
		WMGFxObject_TraderItems(TraderItems).GetItemIndicesFromArcheZedternal(ItemIndex, ItemInfo.DefaultItem.ClassName);
		WMInventoryManager(MyKFIM).ServerRemoveTransactionItemZedternal(ItemIndex);
	}

	// If we try to sell a weapons secondary ammo slot
	if (OwnedItemList[OwnedListIdx].bIsSecondaryAmmo)
	{
		OwnedItemList.Remove(OwnedListIdx, 1);
		if (OwnedListIdx - 1 >= 0)
			OwnedItemList.Remove(OwnedListIdx - 1, 1);
	}
	// If the weapon we're selling uses secondary ammo, remove the secondary ammo listing also
	else if (OwnedItemList[OwnedListIdx].DefaultItem.WeaponDef.static.UsesSecondaryAmmo())
	{
		if (OwnedListIdx + 1 < OwnedItemList.Length)
		{
			OwnedItemList.Remove(OwnedListIdx + 1, 1);
			OwnedItemList.Remove(OwnedListIdx, 1);
		}
	}
	else
		OwnedItemList.Remove( OwnedListIdx, 1 );

	// add a single to owned items when removing a dual sidearm
	if (KFPawn_Human(Pawn) != None && KFPawn_Human(Pawn).GetPerk() != None && ItemInfo.DefaultItem.SingleClassName == Name(Split(KFPawn_Human(Pawn).GetPerk().GetSecondaryWeaponClassPath(), ".", True)))
	{
		// When removing a dual, always add a single to the owned list so that it shows up in the player inventory UI.
		// If we don't own the single, then also buy it (add it to the transaction list).

		if (WMGFxObject_TraderItems(TraderItems).GetItemIndicesFromArcheZedternal(ItemIndex, ItemInfo.DefaultItem.SingleClassName))
		{
			SingleOwnedIndex = AddWeaponToOwnedItemList(TraderItems.SaleItems[ItemIndex], True, ItemInfo.ItemUpgradeLevel);

			// modify default single ammo based on how much ammo dual had when sold
			//      The now new single gun will spawn with default ammo. We need to correct that down
			//      to the correct amount. Account for differences in max spare ammo caused by perks.
			AddTransactionAmmoZedternal(ItemIndex, ItemInfo.SpareAmmoCount - (ItemInfo.MaxSpareAmmo / 2.0) + ((ItemInfo.MaxSpareAmmo / 2.0) - OwnedItemList[SingleOwnedIndex].SpareAmmoCount));

			// update the values in the trader UI
			OwnedItemList[SingleOwnedIndex].SpareAmmoCount = ItemInfo.SpareAmmoCount;
		}
	}

	if (MyGfxManager != None && MyGfxManager.TraderMenu != None)
		MyGfxManager.TraderMenu.OwnedItemList = OwnedItemList;
}

//Replaces native private KFAutoPurchaseHelper.AddTransactionAmmo
function AddTransactionAmmoZedternal(int ItemIndex, int Amount)
{
	if (WMInventoryManager(MyKFIM) != None)
		WMInventoryManager(MyKFIM).AddTransactionAmmo(Amount, ItemIndex);
}

defaultproperties
{
	Name="Default__WMAutoPurchaseHelper"
}
